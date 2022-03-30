import 'package:http/http.dart' show Client, Response;
import 'package:retry/retry.dart';

import '../logging/logging.dart';
import 'cache.dart';

// TODO: add timeout
abstract class HttpClient {
  Future<String> getBody(
    Uri uri, {
    Duration maxAge,
    int maxAttempts,
    CheckResponse checkResponse,
    Duration timeout,
  });
}

class HttpClientImpl implements HttpClient {
  HttpClientImpl(this.client, this.cache);

  final Client client;
  final Cache cache;
  static final _log = Logger('HttpClient');

  @override
  Future<String> getBody(
    Uri uri, {
    Duration maxAge = Duration.zero,
    int maxAttempts = 8,
    CheckResponse checkResponse = defaultCheckResponse,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final cached = maxAge > Duration.zero;

    if (cached) {
      // print(uri.toString());
      final body = await cache.get(uri.toString());
      if (body != null) {
        return body;
      }
    }

    return await retry(
      () async {
        // _log.info('request: $uri');
        final response = await client.get(uri).timeout(timeout);
        await checkResponse(response);
        await cache.put(uri.toString(), response.body, maxAge);
        return response.body;
      },
      maxAttempts: maxAttempts,
    );
  }
}

typedef CheckResponse = Future<void> Function(Response);

Future<void> defaultCheckResponse(Response response) async {
  if (response.statusCode != 200) {
    throw Exception('statusCode != 200');
  }
}

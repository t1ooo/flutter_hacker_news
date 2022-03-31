import 'package:http/http.dart' show Client, Response;
import 'package:retry/retry.dart';

import '../clock/clock.dart';
import '../logging/logging.dart';
import 'cache.dart';

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
  HttpClientImpl(this.client, this.cache, [this.throttle]);

  final Client client;
  final Cache cache;
  final Throttle? throttle;
  static final _log = Logger('HttpClientImpl');

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

    await throttle?.wait();

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

class Throttle<T> {
  Throttle({
    this.delay = const Duration(milliseconds: 100),
    this.minDelay = const Duration(milliseconds: 1),
    this.clock = const Clock(),
  });

  final Duration delay;
  final Duration minDelay;
  final Clock clock;
  DateTime _expired = DateTime(1970);

  Future<void> wait() async {
    final diff = _expired.difference(_now());
    if (diff > Duration.zero) {
      await Future.delayed(diff);
    }

    // int waitCounter = -1;
    while (true) {
      // waitCounter++;
      final diff = _expired.difference(_now());
      if (diff > Duration.zero) {
        // if (diff < minDelay) {
        //   print(diff);
        // }
        // print(diff);
        // await Future.delayed(diff);
        await Future.delayed(diff.max(minDelay));
        continue;
      }
      break;
    }

    // if (waitCounter > 0) print('wait: $waitCounter');

    _expired = _now().add(delay);
  }

  DateTime _now() => clock.now();
}

extension DurationMath on Duration {
  Duration max(Duration other) {
    if (this >= other) {
      return this;
    }
    return other;
  }
}

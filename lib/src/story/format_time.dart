import '../hacker_news_api/hacker_news_api.dart';

String formatItemTime(int unixTimeSec) {
  final diff = DateTime.now().toUtc().difference(
        dateTimeUnixTime(unixTimeSec),
      );

  if (diff.inDays > 0) {
    return '${diff.inDays} days ago';
  }
  if (diff.inHours > 0) {
    return '${diff.inHours} hours ago';
  }
  return '${diff.inMinutes} minutes ago';
}

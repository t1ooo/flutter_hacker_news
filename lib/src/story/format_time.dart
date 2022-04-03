import '../util/data_time.dart';

String formatItemTime(int unixTimeSec) {
  final diff =
      DateTime.now().toUtc().difference(dateTimeFromUnixTime(unixTimeSec));

  if (diff.inDays > 0) {
    return '${diff.inDays} days ago';
  }
  if (diff.inHours > 0) {
    return '${diff.inHours} hours ago';
  }
  return '${diff.inMinutes} minutes ago';
}

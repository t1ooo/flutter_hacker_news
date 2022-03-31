String formatItemTime(int unixTimeS) {
  final diff = DateTime.now().toUtc().difference(
        DateTime.fromMillisecondsSinceEpoch(unixTimeS * 1000),
      );

  if (diff.inDays > 0) {
    return '${diff.inDays} days ago';
  }
  if (diff.inHours > 0) {
    return '${diff.inHours} hours ago';
  }
  return '${diff.inMinutes} minutes ago';
}

/// return [DateTime] from unix time in seconds
DateTime dateTimeFromUnixTime(int unixTimeSec) {
  return DateTime.fromMillisecondsSinceEpoch(unixTimeSec * 1000);
}

/// return unix time in seconds from [DateTime]
int unixTimeFromDateTime(DateTime dt) {
  return dt.millisecondsSinceEpoch ~/ 1000;
}

extension StringExtension on String {
  String get removeExceptionTextIfContains {
    if (contains('Exception:')) return replaceFirst('Exception:', '');
    return this;
  }

  DateTime get parsedDatetime {
    final tSplitDatetime = split('T');
    final dateSplit = tSplitDatetime[0];
    final timeSplit = tSplitDatetime[1];

    final dateMultiSplit = dateSplit.split('-');
    final year = int.parse(dateMultiSplit[0]);
    final month = int.parse(dateMultiSplit[1]);
    final date = int.parse(dateMultiSplit[2]);

    final timeMultiSplit = timeSplit.split(':');
    final hour = int.parse(timeMultiSplit[0]);
    final minutes = int.parse(timeMultiSplit[1]);

    return DateTime(year, month, date, hour, minutes);
  }
}

extension IntExtension on int {

  String toHumanReadableTime() {
    final duration = Duration(seconds: this);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

}

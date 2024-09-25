String getDateFormattedText(DateTime inputTime) {
  final DateTime now = DateTime.now();
  final Duration difference = now.difference(inputTime);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} second${difference.inSeconds == 1 ? '' : 's'} ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  } else if (difference.inDays < 30) {
    return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  } else if (difference.inDays < 365) {
    final int months = (difference.inDays / 30).floor();
    return '$months month${months == 1 ? '' : 's'} ago';
  } else if (difference.inDays < 365 * 2) {
    final int years = (difference.inDays / 365).floor();
    return '$years year${years == 1 ? '' : 's'} ago';
  } else {
    return 'on ${inputTime.day}/${inputTime.month}/${inputTime.year}';
  }
  }
const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatDate(DateTime dt) {
  return '${_months[dt.month - 1]} ${dt.day}, ${dt.year}';
}

String formatDateTime(DateTime dt) {
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '${_months[dt.month - 1]} ${dt.day}, ${dt.year} $h:$m';
}

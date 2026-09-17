import 'package:intl/intl.dart';

String formatDate(DateTime? date) {
  if (date == null) return '';
  return DateFormat('d MMM yyyy').format(date);
}

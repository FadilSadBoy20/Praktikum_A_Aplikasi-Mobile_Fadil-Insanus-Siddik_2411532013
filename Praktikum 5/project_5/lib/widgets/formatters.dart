import 'package:intl/intl.dart';

String formatRupiah(num amount) {
  final value = amount.round().toString();
  final grouped = value.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  return 'Rp $grouped';
}

String formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

String formatDateLong(DateTime date) {
  final formatter = DateFormat('d MMMM yyyy', 'id_ID');
  return formatter.format(date);
}

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('d MMM yyyy HH:mm', 'id_ID');
  return formatter.format(dateTime);
}

String formatPhoneNumber(String phone) {
  // Remove all non-digit characters
  final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
  
  // Format: 0812-3456-7890
  if (cleanPhone.length >= 10) {
    final part1 = cleanPhone.substring(0, 4);
    final part2 = cleanPhone.substring(4, 8);
    final part3 = cleanPhone.substring(8);
    return '$part1-$part2-$part3';
  }
  
  return phone;
}

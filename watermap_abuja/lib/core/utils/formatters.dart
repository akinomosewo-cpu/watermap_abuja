import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final NumberFormat _naira = NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 0);

  static String currency(num amount) => _naira.format(amount);

  static String relativeTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  static String shortDate(DateTime time) => DateFormat('MMM d').format(time);
}

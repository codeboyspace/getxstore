import 'package:intl/intl.dart';

class PriceFormatter {
  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static String format(num amount) => _currency.format(amount);
}

import 'package:flutter_test/flutter_test.dart';
import 'package:getx/app/utils/price_formatter.dart';

void main() {
  test('formats rupee amounts using Indian digit grouping', () {
    expect(PriceFormatter.format(1234), '₹1,234');
    expect(PriceFormatter.format(100000), '₹1,00,000');
    expect(PriceFormatter.format(1234567), '₹12,34,567');
  });
}

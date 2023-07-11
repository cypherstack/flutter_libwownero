import 'package:intl/intl.dart';
import 'package:wow_cw_core/crypto_currency.dart';

// TODO - NOT USE FLOATING POINT ARITHMETIC FOR MONEY

class AmountConverter {
  static const _wowneroAmountLength = 11;
  static const _wowneroAmountDivider = 100000000000;
  static final _wowneroAmountFormat = NumberFormat()
    ..maximumFractionDigits = _wowneroAmountLength
    ..minimumFractionDigits = 1;

  static double? amountIntToDouble(CryptoCurrency cryptoCurrency, int amount) {
    switch (cryptoCurrency) {
      case CryptoCurrency.wow:
        return _wowneroAmountToDouble(amount);
      default:
        return null;
    }
  }

  static int? amountStringToInt(CryptoCurrency cryptoCurrency, String amount) {
    switch (cryptoCurrency) {
      case CryptoCurrency.wow:
        return _wowneroParseAmount(amount);
      default:
        return null;
    }
  }

  static String? amountIntToString(CryptoCurrency cryptoCurrency, int amount) {
    switch (cryptoCurrency) {
      case CryptoCurrency.wow:
        return _wowneroAmountToString(amount);
      default:
        return null;
    }
  }

  static double cryptoAmountToDouble(
          {required num amount, required num divider}) =>
      amount / divider;

  static String _wowneroAmountToString(int amount) =>
      _wowneroAmountFormat.format(
          cryptoAmountToDouble(amount: amount, divider: _wowneroAmountDivider));

  static double _wowneroAmountToDouble(int amount) =>
      cryptoAmountToDouble(amount: amount, divider: _wowneroAmountDivider);

  static int _wowneroParseAmount(String amount) =>
      _wowneroAmountFormat.parse(amount).toInt();
}

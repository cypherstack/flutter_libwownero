//import 'package:flutter_libmonero/generated/i18n.dart';
import 'package:wow_cw_core/transaction_priority.dart';

class WowneroTransactionPriority extends TransactionPriority {
  const WowneroTransactionPriority({String? title, int? raw})
      : super(title: title, raw: raw);

  static const all = [
    WowneroTransactionPriority.slow,
    WowneroTransactionPriority.regular,
    WowneroTransactionPriority.medium,
    WowneroTransactionPriority.fast,
    WowneroTransactionPriority.fastest
  ];
  static const slow = WowneroTransactionPriority(title: 'Slow', raw: 0);
  static const regular = WowneroTransactionPriority(title: 'Regular', raw: 1);
  static const medium = WowneroTransactionPriority(title: 'Medium', raw: 2);
  static const fast = WowneroTransactionPriority(title: 'Fast', raw: 3);
  static const fastest = WowneroTransactionPriority(title: 'Fastest', raw: 4);
  static const standard = slow;

  static List<WowneroTransactionPriority> get forWalletType =>
      WowneroTransactionPriority.all;

  static WowneroTransactionPriority? deserialize({int? raw}) {
    switch (raw) {
      case 0:
        return slow;
      case 1:
        return regular;
      case 2:
        return medium;
      case 3:
        return fast;
      case 4:
        return fastest;
      default:
        return null;
    }
  }

  @override
  String toString() {
    switch (this) {
      case WowneroTransactionPriority.slow:
        return 'Slow'; // S.current.transaction_priority_slow;
      case WowneroTransactionPriority.regular:
        return 'Regular'; // S.current.transaction_priority_regular;
      case WowneroTransactionPriority.medium:
        return 'Medium'; // S.current.transaction_priority_medium;
      case WowneroTransactionPriority.fast:
        return 'Fast'; // S.current.transaction_priority_fast;
      case WowneroTransactionPriority.fastest:
        return 'Fastest'; // S.current.transaction_priority_fastest;
      default:
        return '';
    }
  }
}

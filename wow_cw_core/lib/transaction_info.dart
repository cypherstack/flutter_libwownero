import 'package:wow_cw_core/keyable.dart';
import 'package:wow_cw_core/transaction_direction.dart';

abstract class TransactionInfo extends Object with Keyable {
  String? id;
  int? amount;
  int? fee;
  TransactionDirection? direction;
  bool? isPending;
  DateTime? date;
  int? height;
  int? confirmations;
  String amountFormatted();
  String fiatAmount();
  String feeFormatted();
  void changeFiatAmount(String amount);

  @override
  dynamic get keyIndex => id;

  Map<String, dynamic>? additionalInfo;
}

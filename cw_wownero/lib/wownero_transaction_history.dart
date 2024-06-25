import 'dart:core';

import 'package:cw_wownero/wownero_transaction_info.dart';
import 'package:mobx/mobx.dart';
import 'package:wow_cw_core/transaction_history.dart';

part 'wownero_transaction_history.g.dart';

class WowneroTransactionHistory = WowneroTransactionHistoryBase
    with _$WowneroTransactionHistory;

abstract class WowneroTransactionHistoryBase
    extends TransactionHistoryBase<WowneroTransactionInfo> with Store {
  WowneroTransactionHistoryBase() {
    transactions = ObservableMap<String, WowneroTransactionInfo>();
  }

  @override
  Future<void> save() async {}

  @override
  void addOne(WowneroTransactionInfo transaction) =>
      transactions![transaction.id] = transaction;

  @override
  void addMany(Map<String, WowneroTransactionInfo> transactions) =>
      this.transactions!.addAll(transactions);
}

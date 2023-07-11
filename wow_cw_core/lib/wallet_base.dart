import 'package:mobx/mobx.dart';
import 'package:wow_cw_core/balance.dart';
import 'package:wow_cw_core/crypto_currency.dart';
import 'package:wow_cw_core/node.dart';
import 'package:wow_cw_core/pending_transaction.dart';
import 'package:wow_cw_core/sync_status.dart';
import 'package:wow_cw_core/transaction_history.dart';
import 'package:wow_cw_core/transaction_info.dart';
import 'package:wow_cw_core/transaction_priority.dart';
import 'package:wow_cw_core/wallet_addresses.dart';
import 'package:wow_cw_core/wallet_info.dart';

abstract class WalletBase<
    BalanceType extends Balance,
    HistoryType extends TransactionHistoryBase,
    TransactionType extends TransactionInfo> {
  WalletBase(this.walletInfo);

  static String idFor(String name) => '_' + name;

  WowneroWalletInfo walletInfo;

  CryptoCurrency? get currency => CryptoCurrency.wow;

  String? get id => walletInfo.id;

  String? get name => walletInfo.name;

  //String get address;

  //set address(String address);

  ObservableMap<CryptoCurrency?, BalanceType>? get balance;

  SyncStatus? get syncStatus;

  set syncStatus(SyncStatus? status);

  String get seed;

  Object get keys;

  WalletAddresses get walletAddresses;

  HistoryType? transactionHistory;

  Future<void> connectToNode({required WowneroNode node});

  Future<void> startSync();

  Future<PendingTransaction> createTransaction(Object credentials);

  int calculateEstimatedFee(TransactionPriority priority, int amount);

  // void fetchTransactionsAsync(
  //     void Function(TransactionType transaction) onTransactionLoaded,
  //     {void Function() onFinished});

  Future<Map<String, TransactionType>> fetchTransactions();

  Future<void> save();

  Future<void> rescan({int? height});

  void close();

  Future<void> changePassword(String password);
}

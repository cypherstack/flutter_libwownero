import 'package:wow_cw_core/account_list.dart';
import 'package:wow_cw_core/wallet_addresses.dart';
import 'package:wow_cw_core/wallet_info.dart';

abstract class WalletAddressesWithAccount<T> extends WalletAddresses {
  WalletAddressesWithAccount(WowneroWalletInfo walletInfo) : super(walletInfo);

  T get account;

  set account(T account);

  AccountList<T> get accountList;
}

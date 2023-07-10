import 'package:wow_cw_core/wallet_base.dart';
import 'package:wow_cw_core/wallet_credentials.dart';
import 'package:wow_cw_core/wallet_type.dart';

abstract class WowneroWalletService<N extends WowneroWalletCredentials,
    RFS extends WalletCredentials, RFK extends WalletCredentials> {
  WalletType getType();

  Future<WalletBase> create(N credentials);

  Future<WalletBase> restoreFromSeed(RFS credentials);

  Future<WalletBase> restoreFromKeys(RFK credentials);

  Future<WalletBase> openWallet(String name, String password);

  Future<bool> isWalletExit(String name);

  Future<void> remove(String wallet);
}

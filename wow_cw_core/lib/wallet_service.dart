import 'package:wow_cw_core/wallet_base.dart';
import 'package:wow_cw_core/wallet_credentials.dart';

abstract class WalletService<N extends WowneroWalletCredentials,
    RFS extends WowneroWalletCredentials, RFK extends WowneroWalletCredentials> {
  Future<WalletBase> create(N credentials);

  Future<WalletBase> restoreFromSeed(RFS credentials);

  Future<WalletBase> restoreFromKeys(RFK credentials);

  Future<WalletBase> openWallet(String name, String password);

  Future<bool> isWalletExit(String name);

  Future<void> remove(String wallet);
}

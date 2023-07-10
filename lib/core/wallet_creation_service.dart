// import 'package:flutter_libmonero/di.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stack_wallet_backup/generate_password.dart';
import 'package:wow_cw_core/wallet_base.dart';
import 'package:wow_cw_core/wallet_credentials.dart';
import 'package:wow_cw_core/wallet_service.dart';
import 'package:wow_cw_core/wallet_type.dart';

import 'key_service.dart';

class WalletCreationService {
  WowneroWalletService? walletService;
  WalletCreationService(
      {this.secureStorage,
      this.keyService,
      this.sharedPreferences,
      this.walletService}) {
    if (type != null) {
      changeWalletType();
    }
  }

  WalletType type = WalletType.monero;
  final dynamic secureStorage;
  final SharedPreferences? sharedPreferences;
  final KeyService? keyService;
  WowneroWalletService? _service;

  void changeWalletType() {
    this.type = WalletType.monero;
    _service = walletService;
  }

  Future<WalletBase> create(WowneroWalletCredentials credentials) async {
    final password = generatePassword();
    credentials.password = password;
    await keyService!
        .saveWalletPassword(password: password, walletName: credentials.name);
    return await _service!.create(credentials);
  }

  Future<WalletBase> restoreFromKeys(WowneroWalletCredentials credentials) async {
    final password = generatePassword();
    credentials.password = password;
    await keyService!
        .saveWalletPassword(password: password, walletName: credentials.name);
    return await _service!.restoreFromKeys(credentials);
  }

  Future<WalletBase> restoreFromSeed(WowneroWalletCredentials credentials) async {
    final password = generatePassword();
    credentials.password = password;
    await keyService!
        .saveWalletPassword(password: password, walletName: credentials.name);
    return await _service!.restoreFromSeed(credentials);
  }
}

// import 'package:flutter_libmonero/di.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stack_wallet_backup/generate_password.dart';
import 'package:wow_cw_core/wallet_base.dart';
import 'package:wow_cw_core/wallet_credentials.dart';
import 'package:wow_cw_core/wallet_service.dart';

import 'key_service.dart';

class WalletCreationService {
  WalletCreationService({
    this.secureStorage,
    this.keyService,
    this.sharedPreferences,
    this.walletService,
  });

  WalletService? walletService;

  final dynamic secureStorage;
  final SharedPreferences? sharedPreferences;
  final KeyService? keyService;

  Future<WalletBase> create(WowneroWalletCredentials credentials) async {
    final password = generatePassword();
    credentials.password = password;
    await keyService!
        .saveWalletPassword(password: password, walletName: credentials.name);
    return await walletService!.create(credentials);
  }

  Future<WalletBase> restoreFromKeys(WowneroWalletCredentials credentials) async {
    final password = generatePassword();
    credentials.password = password;
    await keyService!
        .saveWalletPassword(password: password, walletName: credentials.name);
    return await walletService!.restoreFromKeys(credentials);
  }

  Future<WalletBase> restoreFromSeed(WowneroWalletCredentials credentials) async {
    final password = generatePassword();
    credentials.password = password;
    await keyService!
        .saveWalletPassword(password: password, walletName: credentials.name);
    return await walletService!.restoreFromSeed(credentials);
  }
}

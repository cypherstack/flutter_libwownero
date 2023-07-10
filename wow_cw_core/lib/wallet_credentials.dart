import 'package:wow_cw_core/wallet_info.dart';

abstract class WowneroWalletCredentials {
  WowneroWalletCredentials({this.name, this.password, this.height, this.walletInfo});

  final String? name;
  final int? height;
  String? password;
  WalletInfo? walletInfo;
}

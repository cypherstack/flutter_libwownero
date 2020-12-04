import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:cake_wallet/entities/wallet_type.dart';

part 'wallet_info.g.dart';

@HiveType(typeId: 4)
class WalletInfo extends HiveObject {
  WalletInfo(this.id, this.name, this.displayName, this.type, this.isRecovery,
      this.restoreHeight, this.timestamp, this.dirPath, this.path);

  factory WalletInfo.external(
      {@required String id,
      @required String name,
      @required String displayName,
      @required WalletType type,
      @required bool isRecovery,
      @required int restoreHeight,
      @required DateTime date,
      @required String dirPath,
      @required String path}) {
    return WalletInfo(id, name, displayName, type, isRecovery, restoreHeight,
        date.millisecondsSinceEpoch ?? 0, dirPath, path);
  }

  static const boxName = 'WalletInfo';

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  WalletType type;

  @HiveField(3)
  bool isRecovery;

  @HiveField(4)
  int restoreHeight;

  @HiveField(5)
  int timestamp;

  @HiveField(6)
  String dirPath;

  @HiveField(7)
  String path;

  @HiveField(8)
  String displayName;

  String get displayedName => displayName ?? name;

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(timestamp);
}

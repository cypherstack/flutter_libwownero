import 'package:hive/hive.dart';

part 'wallet_info.g.dart';

@HiveType(typeId: WalletInfo.typeId)
class WalletInfo extends HiveObject {
  WalletInfo(
    this.id,
    this.name,
    this.isRecovery,
    this.restoreHeight,
    this.timestamp,
    this.dirPath,
    this.path,
    this.address,
  );

  factory WalletInfo.external({
    required String id,
    required String name,
    required bool isRecovery,
    required int restoreHeight,
    required DateTime date,
    required String dirPath,
    required String path,
    required String address,
  }) {
    return WalletInfo(
      id,
      name,
      isRecovery,
      restoreHeight,
      date.millisecondsSinceEpoch,
      dirPath,
      path,
      address,
    );
  }

  static const typeId = 69;
  static const boxName = 'WowneroWalletInfo';

  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  bool? isRecovery;

  @HiveField(3)
  int? restoreHeight;

  @HiveField(4)
  int? timestamp;

  @HiveField(5)
  String? dirPath;

  @HiveField(6)
  String? path;

  @HiveField(7)
  String? address;

  @HiveField(8)
  Map<String, String>? addresses;

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(timestamp!);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletInfoAdapter extends TypeAdapter<WalletInfo> {
  @override
  final int typeId = 69;

  @override
  WalletInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalletInfo(
      fields[0] as String?,
      fields[1] as String?,
      fields[2] as bool?,
      fields[3] as int?,
      fields[4] as int?,
      fields[5] as String?,
      fields[6] as String?,
      fields[7] as String?,
    )..addresses = (fields[8] as Map?)?.cast<String, String>();
  }

  @override
  void write(BinaryWriter writer, WalletInfo obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isRecovery)
      ..writeByte(3)
      ..write(obj.restoreHeight)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.dirPath)
      ..writeByte(6)
      ..write(obj.path)
      ..writeByte(7)
      ..write(obj.address)
      ..writeByte(8)
      ..write(obj.addresses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

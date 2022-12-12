// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DashboardCompoAdapter extends TypeAdapter<DashboardCompo> {
  @override
  final int typeId = 1;

  @override
  DashboardCompo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DashboardCompo(
      fields[0] as bool,
      fields[1] as bool,
      fields[2] as bool,
      fields[3] as bool,
      fields[4] as bool,
      fields[5] as bool,
      fields[6] as bool,
      fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DashboardCompo obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.outOfStock)
      ..writeByte(1)
      ..write(obj.sold)
      ..writeByte(2)
      ..write(obj.unsold)
      ..writeByte(3)
      ..write(obj.almostFinished)
      ..writeByte(4)
      ..write(obj.mostSell)
      ..writeByte(5)
      ..write(obj.todayOrders)
      ..writeByte(6)
      ..write(obj.todayIncome)
      ..writeByte(7)
      ..write(obj.totalUsers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardCompoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

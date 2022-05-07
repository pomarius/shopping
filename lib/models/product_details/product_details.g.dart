// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductDetailsAdapter extends TypeAdapter<ProductDetails> {
  @override
  final int typeId = 2;

  @override
  ProductDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductDetails(
      code: fields[0] as String,
      description: fields[1] as String,
      measurements: (fields[2] as List).cast<String>(),
      fits: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductDetails obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.measurements)
      ..writeByte(3)
      ..write(obj.fits);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

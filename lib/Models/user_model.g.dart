// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SignUpModelAdapter extends TypeAdapter<SignUpModel> {
  @override
  final int typeId = 0;

  @override
  SignUpModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SignUpModel(
      firstName: fields[0] as String,
      lastName: fields[1] as String,
      mobileNo: fields[2] as String,
      email: fields[3] as String,
      id: fields[4] as String,
      profilePic: fields[5] as String,
      bankStatus: fields[6] as bool,
      kycStatus: fields[7] as int,
      premiumStatus: fields[8] as int,
      kycExpDate: fields[9] as DateTime?,
      premiumExpDate: fields[10] as DateTime?,
      isEmiratesIdDone: fields[11] as bool,
      isTradeLicenseDone: fields[12] as bool,
      paymentLink: fields[13] as String,
      referral_code: fields[14] as String,
      referral_link: fields[15] as String,
      kycID: fields[16] as String,
      loginTime: fields[17] as DateTime?,
      email_status: fields[18] as bool
    );
  }

  @override
  void write(BinaryWriter writer, SignUpModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.mobileNo)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.profilePic)
      ..writeByte(6)
      ..write(obj.bankStatus)
      ..writeByte(7)
      ..write(obj.kycStatus)
      ..writeByte(8)
      ..write(obj.premiumStatus)
      ..writeByte(9)
      ..write(obj.kycExpDate)
      ..writeByte(10)
      ..write(obj.premiumExpDate)
      ..writeByte(11)
      ..write(obj.isEmiratesIdDone)
      ..writeByte(12)
      ..write(obj.isTradeLicenseDone)
      ..writeByte(13)
      ..write(obj.paymentLink)
      ..writeByte(14)
      ..write(obj.referral_code)
      ..writeByte(15)
      ..write(obj.referral_link)
      ..writeByte(16)
      ..write(obj.kycID)
      ..writeByte(17)
      ..write(obj.loginTime)
      ..writeByte(18)
      ..write(obj.email_status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignUpModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

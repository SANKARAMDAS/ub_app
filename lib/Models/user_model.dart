import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0, adapterName: 'SignUpModelAdapter')
class SignUpModel extends Equatable {
  @HiveField(0)
  final String firstName;
  @HiveField(1)
  final String lastName;
  @HiveField(2)
  final String mobileNo;
  @HiveField(3)
  final String email;
  @HiveField(4)
  final String id;
  @HiveField(5)
  final String profilePic;
  @HiveField(6)
  final bool bankStatus;
  @HiveField(7)
  final int kycStatus;
  @HiveField(8)
  final int premiumStatus;
  @HiveField(9)
  final DateTime? kycExpDate;
  @HiveField(10)
  final DateTime? premiumExpDate;
  @HiveField(11)
  final bool isEmiratesIdDone;
  @HiveField(12)
  final bool isTradeLicenseDone;
  @HiveField(13)
  final String paymentLink;
  @HiveField(14)
  final String referral_code;
  @HiveField(15)
  final String referral_link;
  @HiveField(16)
  final String kycID;
  @HiveField(17)
  final DateTime? loginTime;
  @HiveField(18)
  final bool email_status;

  SignUpModel(
      {required this.firstName,
      required this.lastName,
      required this.mobileNo,
      required this.email,
      this.id: '',
      this.profilePic: '',
      this.bankStatus: false,
      this.kycStatus: 0,
      this.premiumStatus: 0,
      this.kycExpDate,
      this.premiumExpDate,
      this.isEmiratesIdDone: false,
      this.isTradeLicenseDone: false,
      this.paymentLink: '',
      this.referral_code: '',
      this.referral_link: '',
      this.kycID: '',
      this.loginTime,
      this.email_status:false
      });

  SignUpModel copyWith(
          {String? firstName,
          String? lastName,
          String? mobileNo,
          String? email,
          String? id,
          String? profilePic,
          bool? bankStatus,
          int? kycStatus,
          int? premiumStatus,
          DateTime? kycExpDate,
          DateTime? premiumExpDate,
          bool? isEmiratesIdDone,
          bool? isTradeLicenseDone,
          String? referral_code,
          String? referral_link,
          String? kycID,
          String? paymentLink,
          DateTime? loginTime,
            bool? email_status,
         }) =>
      SignUpModel(
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        mobileNo: mobileNo ?? this.mobileNo,
        bankStatus: bankStatus ?? this.bankStatus,
        id: id ?? this.id,
        kycExpDate: kycExpDate ?? this.kycExpDate,
        kycStatus: kycStatus ?? this.kycStatus,
        premiumExpDate: premiumExpDate ?? this.premiumExpDate,
        premiumStatus: premiumStatus ?? this.premiumStatus,
        profilePic: profilePic ?? this.profilePic,
        isEmiratesIdDone: isEmiratesIdDone ?? this.isEmiratesIdDone,
        isTradeLicenseDone: isTradeLicenseDone ?? this.isTradeLicenseDone,
        paymentLink: paymentLink ?? this.paymentLink,
        referral_code: referral_code ?? this.referral_code,
        referral_link: referral_link ?? this.referral_link,
        kycID: kycID ?? this.kycID,
        loginTime: loginTime??this.loginTime,
        email_status: email_status?? this.email_status
      );

  factory SignUpModel.fromJson(
    Map<String, dynamic> json,
    String filePath, {
    required bool bankStatus,
    required String kycExpDate,
    required int kycStatus,
    required String premiumExpDate,
    required int premiumStatus,
    required bool isEmiratesIdDone,
    required bool isTradeLicenseDone,
    required String paymentLink,
    required String referral_link,
    required String referral_code,
        required bool email_status,
    // required String kycID,
  }) {
    return SignUpModel(
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        mobileNo: json['mobile_no'] ?? '',
        email: json['email_id'] ?? '',
        id: json['_id'] ?? '',
        profilePic: filePath,
        bankStatus: bankStatus,
        kycExpDate: kycExpDate.isEmpty
            ? null
            : DateFormat('dd/MM/yyyy').parse(kycExpDate),
        kycStatus: kycStatus,
        premiumExpDate: DateTime.tryParse(premiumExpDate),
        premiumStatus: premiumStatus,
        isEmiratesIdDone: isEmiratesIdDone,
        isTradeLicenseDone: isTradeLicenseDone,
        paymentLink: paymentLink,
        referral_code: referral_code,
        referral_link: referral_link,
        email_status: email_status
        // kycID: kycID,
        );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['mobile_no'] = mobileNo;
    map['email_id'] = email;
    map['profilePic'] = profilePic;
    map['referral_link'] = referral_link;
    map['referral_code'] = referral_code;
    map['payment_link'] = paymentLink;
    map['email_status'] = email_status;
    return map;
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        mobileNo,
        email,
        profilePic,
        referral_code,
        referral_link,
    email_status
      ];
}

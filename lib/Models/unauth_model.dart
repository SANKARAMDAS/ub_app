import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'unauth_model.g.dart';

@HiveType(typeId: 2, adapterName: 'UnAuthModelAdapter')
class UnAuthModel extends Equatable {
  @HiveField(0)
  final DateTime? loginTime;
  @HiveField(1)
  final bool? seen;
  

  UnAuthModel({
    this.loginTime,
    this.seen
  });

  UnAuthModel copyWith({DateTime? loginTime, bool? seen}) =>
      UnAuthModel(
        loginTime: loginTime ?? this.loginTime,
        seen: seen ?? this.seen,
      );

  factory UnAuthModel.fromJson(
    Map<String, dynamic> json,
    String filePath, {
    bool? seen,
    // required String kycID,
  }) {
    return UnAuthModel(
      loginTime: json['loginTime'] ?? '',
      seen: json['seen'] ?? false);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['loginTime'] = loginTime;
    map['seen'] = seen ?? false;
    return map;
  }

  @override
  List<Object?> get props => [
        loginTime,
        seen
      ];
}

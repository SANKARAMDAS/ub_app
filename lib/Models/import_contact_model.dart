import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ImportContactModel extends Equatable {
  static const tableName = 'PHONEBOOKCONTACTSTABLE';

  static const columnId = 'ID';

  static const columnCustomerId = 'CUSTOMERID';

  static const columnName = 'NAME';

  static const columnMobileNo = 'MOBILENO';

  static const columnAvatar = 'AVATAR';

  final String id;
  final String? customerId;
  final String name;
  final String mobileNo;
  final Uint8List? avatar;

  ImportContactModel({
    required this.id,
    this.customerId,
    required this.name,
    required this.mobileNo,
    this.avatar,
  });

  Map<String, dynamic> toDb() => {
        columnId: id,
        columnCustomerId: customerId,
        columnName: name,
        columnMobileNo: mobileNo,
        columnAvatar: avatar,
      };

  factory ImportContactModel.fromDb(Map<String, dynamic> element) {
    return ImportContactModel(
        id: element[ImportContactModel.columnId],
        name: element[ImportContactModel.columnName],
        mobileNo: element[ImportContactModel.columnMobileNo],
        avatar: element[ImportContactModel.columnAvatar],
        customerId: element[ImportContactModel.columnCustomerId]);
  }

  @override
  List<Object?> get props => [id];
}

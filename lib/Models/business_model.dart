import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'business_model.g.dart';

@HiveType(typeId: 1, adapterName: 'BusinessModelAdapter')
class BusinessModel extends Equatable {
  static const tableName = 'BUSINESS_TABLE';

  static const columnBusinessId = 'BUSINESSID';

  static const columnName = 'NAME';

  static const columnDeleteAction = 'DELETEACTION';

  static const columnIsChanged = 'ISCHANGED';

  static const columnIsDeleted = 'ISDELETED';

  @HiveField(0)
  final String businessId;
  @HiveField(1)
  final String businessName;
  @HiveField(2)
  final bool deleteAction;
  @HiveField(3)
  final bool isChanged;
  @HiveField(4)
  final bool isDeleted;

  BusinessModel(
      {required this.businessId,
      required this.businessName,
      required this.isChanged,
      required this.isDeleted,
      required this.deleteAction});

  Map<String, dynamic> toDb() => {
        columnBusinessId: businessId,
        columnName: businessName,
        columnDeleteAction: deleteAction ? 1 : 0,
        columnIsChanged: isChanged ? 1 : 0,
        columnIsDeleted: isDeleted ? 1 : 0
      };

  factory BusinessModel.fromDb(Map<String, dynamic> element) {
    return BusinessModel(
        businessId: element[columnBusinessId],
        businessName: element[columnName],
        deleteAction: element[columnDeleteAction] == 1 ? true : false,
        isChanged: element[columnIsChanged] == 1 ? true : false,
        isDeleted: element[columnIsDeleted] == 1 ? true : false);
  }

  Map<String, dynamic> toJson() => {
        'name': businessName,
        'uid': businessId,
        'deleteAction': deleteAction,
      };

  @override
  List<Object?> get props =>
      [businessId, businessName, isChanged, isDeleted, deleteAction];
}

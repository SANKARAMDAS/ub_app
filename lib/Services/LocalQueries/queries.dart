import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:urbanledger/Models/SuspenseAccountModel.dart';
import 'package:urbanledger/Models/analytics_model.dart';
import 'package:urbanledger/Models/business_model.dart';
import 'package:urbanledger/Models/cashbook_entry_model.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/customer_ranking_model.dart';
import 'package:urbanledger/Models/import_contact_model.dart';
import 'package:urbanledger/Models/settlement_history_model.dart';
import 'package:urbanledger/Models/transaction_model.dart';
import 'package:urbanledger/Services/APIs/customer_ranking_api.dart';
import 'package:urbanledger/Services/LocalQueries/mobile_analytics_queries.dart';
// import 'package:urbanledger/Models/user_profile_model.dart';
import 'package:urbanledger/Services/local_db.dart';
import 'package:urbanledger/Utility/app_methods.dart';
import 'package:urbanledger/chat_module/utils/custom_shared_preferences.dart';

import '../../screens/Components/custom_widgets.dart';

class Queries with MobileAnalyticsQueries {
  Queries._();

  static final Queries queries = Queries._();

  static final Future<Database> db = LocalDb.db.database;

  ///CustomerQueries
  ///To insert customer
  Future<int?> insertCustomer(CustomerModel customerModel) async {
    final _db = await db;
    try {
      return await _db.insert(
          CustomerModel.customerTableName, customerModel.toDb(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

//SuspenseAccountInsertion
  Future<int?> insertSuspenseAccount(SuspenseData suspenseModel) async {
    final _db = await db;
    try {
      return await _db.insert(SuspenseData.tableName, suspenseModel.toDb(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<int?> insertSettlementHistory(
      SettlementHistoryData settlementHistoryData) async {
    final _db = await db;
    try {
      return await _db.insert(
          SettlementHistoryData.tableName, settlementHistoryData.toDb(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<int?> insertCustomerRanking(
      CustomerRankingData customerRankingData) async {
    final _db = await db;
    try {
      /* final totalEntryCount = await _db.rawQuery('''SELECT COUNT(${CustomerRankingData.columnCustomerId}) as TOTALCOUNT FROM ${CustomerRankingData.tableName} WHERE ${CustomerRankingData.columnCustomerId}= "${customerRankingData.id}" AND ${CustomerRankingData.columnType}="${customerRankingData.type}"''');

      int totalCount = (totalEntryCount.length) != 0
          ? int.tryParse(totalEntryCount.first['TOTALCOUNT'].toString()) ?? 0
          : 0;
      if(totalCount>0){
        return 0;
      }*/
      return await _db.insert(
          CustomerRankingData.tableName, customerRankingData.toDb(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<void> clearCustomerRankingType(String type) async {
    final _db = await db;
    final batch = _db.batch();
    try {
      batch.delete(CustomerRankingData.tableName,
          where: '${CustomerRankingData.columnType} = ?',
          whereArgs: [type]); // suspense Account

      await batch.commit(noResult: true);
    } catch (e) {
      recordError(e, StackTrace.current);
      return;
    }
  }

  Future<bool?> checkDuplicateCustomerRanking(
      CustomerRankingData customerRankingData) async {
    final _db = await db;
    bool resultValue = false;
    try {
      var result = await _db.query(CustomerRankingData.tableName,
          where: '${CustomerRankingData.columnCustomerId} = ?',
          whereArgs: [customerRankingData.id]);
      if (result.length > 0) resultValue = true;
      return resultValue;
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  //PREMIUM ACC

  Future getPREMIUMSTATS() async {
    final _db = await db;

    // String? k = UID?.join(', ');
    debugPrint('SELECT TYPE,AMOUNT FROM TB_ANALYTICS');
    try {
      List m = await _db.rawQuery(
        'SELECT TYPE,AMOUNT FROM TB_ANALYTICS',
      );

      debugPrint('records' + m.toString());
      return m;
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

//SUspense Add c from ledger
  Future<List> getCustomerFromLedger({List<String>? UID}) async {
    final _db = await db;

    // String? k = UID?.join(', ');
    debugPrint(
        'select DISTINCT BUSSINESS from TRANSACTION_TABLE where BUSSINESS IN(${jsonEncode(UID).replaceAll("\"", "\'")})');
    try {
      List<Map> m = await _db.rawQuery(
        'select DISTINCT BUSSINESS from TRANSACTION_TABLE where BUSSINESS IN(${jsonEncode(UID).replaceAll("\"", "\'").replaceAll('[', '').replaceAll(']', '')})',
      );

      debugPrint('records' + m.toString());
      return m;
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  //Suspense get
  Future<List<SuspenseData>> getSuspenseAccount() async {
    final _db = await db;
    try {
      return (await _db.query(SuspenseData.tableName,
              where: '${SuspenseData.columnIsMoved} = ?', whereArgs: [0]))
          .map((element) {
        debugPrint('check11' + element.toString());
        return SuspenseData().fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List<SettlementHistoryData>> getSettlementHistory() async {
    final _db = await db;
    try {
      return (await _db.query(SettlementHistoryData.tableName)).map((element) {
        debugPrint('check11' + element.toString());
        return SettlementHistoryData().fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List<SuspenseData>> getSuspenseAccountForFilter(
      DateTime start, DateTime end) async {
    final _db = await db;
    try {
      return (await _db.query(SuspenseData.tableName,
              where:
                  '${SuspenseData.columnIsMoved} = ? AND ${SuspenseData.columncreatedAt} >= ? AND ${SuspenseData.columncreatedAt} <= ? ',
              whereArgs: [0, start.toIso8601String(), end.toIso8601String()]))
          .map((element) {
        debugPrint('check11' + element.toString());
        return SuspenseData().fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List<SettlementHistoryData>> getSettlementHistoryForFilter(
      DateTime start, DateTime end) async {
    final _db = await db;
    try {
      return (await _db.query(SettlementHistoryData.tableName,
              where:
                  'STRFTIME(\'%Y-%m-%d\', ${SettlementHistoryData.column_createdAt}) >= STRFTIME(\'%Y-%m-%d\',?) AND STRFTIME(\'%Y-%m-%d\', ${SettlementHistoryData.column_createdAt}) <= STRFTIME(\'%Y-%m-%d\',?) ',
              whereArgs: [start.toIso8601String(), end.toIso8601String()]))
          .map((element) {
        debugPrint('check11' + element.toString());
        return SettlementHistoryData().fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  //Suspense getOffline
  Future<List<SuspenseData>> getSuspenseOfflineAccount() async {
    final _db = await db;
    try {
      return (await _db.query(SuspenseData.tableName,
              where: '${SuspenseData.columnIsMoved} = ?', whereArgs: [1]))
          .map((element) {
        debugPrint('check11' + element.toString());
        return SuspenseData().fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List<SettlementHistoryData>> getSettlementHistoryOfflineData() async {
    final _db = await db;
    try {
      return (await _db.query(SettlementHistoryData.tableName)).map((element) {
        debugPrint('check11' + element.toString());
        return SettlementHistoryData().fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<CustomerRankingModel> getCustomerRanking(
      int limit, RequestType type, int pageNo) async {
    CustomerRankingModel customerRankingModel = new CustomerRankingModel();
    final _db = await db;
    int offSet = ((limit) * (pageNo - 1));
    String valueType = type == RequestType.PAY ? 'pay' : 'recieve';
    try {
      final totalColumnCount = await _db.rawQuery(
          '''SELECT COUNT(${CustomerRankingData.columnCustomerId}) as TOTALCOUNT FROM ${CustomerRankingData.tableName} WHERE ${CustomerRankingData.columnType}="${valueType}"''');
      int totalCount = (totalColumnCount.length) != 0
          ? int.tryParse(totalColumnCount.first['TOTALCOUNT'].toString()) ?? 0
          : 0;
      int pageCount = (totalCount / limit).round();
      var resultMap = (await _db.rawQuery('''
      SELECT * FROM ${CustomerRankingData.tableName}
     WHERE ${CustomerRankingData.columnType}="${valueType}"
     ORDER BY ${CustomerRankingData.columnId}
     LIMIT $limit OFFSET $offSet
    '''));
      List<CustomerRankingData> crList = resultMap.map((element) {
        return CustomerRankingData().fromDb(element);
      }).toList();
      print(crList.length);
      customerRankingModel.data = crList;
      customerRankingModel.totalPages = pageCount;

      return customerRankingModel;
    } catch (e) {
      recordError(e, StackTrace.current);
      return customerRankingModel;
    }
  }

  Future<List<CustomerRankingData>> getCustomerRankingForFilter(
      DateTime start, DateTime end) async {
    final _db = await db;
    try {
      return (await _db.query(CustomerRankingData.tableName,
              where:
                  '${SuspenseData.columncreatedAt} >= ? AND ${SuspenseData.columncreatedAt} <= ? ',
              whereArgs: [start.toIso8601String(), end.toIso8601String()]))
          .map((element) {
        debugPrint('check11' + element.toString());
        return CustomerRankingData().fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  //update suspense
  Future<int?> updateIsMovedOffline(SuspenseData suspenseModel) async {
    final _db = await db;
    try {
      return await _db.update(
        SuspenseData.tableName,
        {SuspenseData.columnIsMoved: 1},
        where: '${SuspenseData.columntransactionId} = ?',
        whereArgs: [suspenseModel.transactionId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  //delete suspense
  Future<int?> deleteIsMovedOffline(transactionId) async {
    final _db = await db;
    try {
      return await _db.delete(
        SuspenseData.tableName,
        where: '${SuspenseData.columntransactionId} = ?',
        whereArgs: [transactionId],
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  ///To update customer
  Future<int?> updateCustomer(CustomerModel customerModel) async {
    final _db = await db;
    try {
      return await _db.update(
        CustomerModel.customerTableName,
        customerModel.toDb(),
        where: '${CustomerModel.columnId} = ?',
        whereArgs: [customerModel.customerId],
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<int?> updatePartialCustomerDetails(CustomerModel customerModel) async {
    final _db = await db;
    try {
      return await _db.update(
        CustomerModel.customerTableName,
        {
          CustomerModel.columnId: customerModel.customerId,
          CustomerModel.columnName: customerModel.name,
          CustomerModel.columnMobileNo:
              customerModel.mobileNo!.replaceAll('+', '').replaceAll(' ', ''),
          CustomerModel.columnAvatar: customerModel.avatar,
          CustomerModel.columnIsChanged: 1,
        },
        where: '${CustomerModel.columnId} = ?',
        whereArgs: [customerModel.customerId],
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  ///To get Customer of a specific business which are not deleted
  Future<List<CustomerModel>> getCustomers(String businessId) async {
    final _db = await db;
    try {
      return (await _db.query(CustomerModel.customerTableName,
              where:
                  '${CustomerModel.columnBusinessId} = ? AND ${CustomerModel.columnIsDeleted} = ?',
              whereArgs: [businessId, 0]))
          .map((element) {
        return CustomerModel().fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  ///To get customer count for a particular business
  Future<int> getCustomerCount(String businessId) async {
    final _db = await db;
    try {
      final totalCount = await _db.rawQuery(
          'SELECT COUNT(${CustomerModel.columnId}) as TOTALCOUNT FROM ${CustomerModel.customerTableName} WHERE ${CustomerModel.columnBusinessId} = ? AND ${CustomerModel.columnIsDeleted} = ?',
          [businessId, 0]);
      return (totalCount.length) != 0
          ? int.tryParse(totalCount.first['TOTALCOUNT'].toString()) ?? 0
          : 0;
    } catch (e) {
      recordError(e, StackTrace.current);
      return 0;
    }
  }

  ///To get customers to sync mainly which are modified and not deleted
  Future<List<CustomerModel>> getCustomerstoSync() async {
    final _db = await db;
    try {
      return (await _db.query(CustomerModel.customerTableName,
              where:
                  '${CustomerModel.columnIsChanged}=? AND ${CustomerModel.columnIsDeleted}=?',
              whereArgs: [1, 0]))
          .map((element) {
        return CustomerModel().fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  //To get unrecognized link/QR
  Future<List> unAuthorizedTranaction() async {
    final _db = await db;
    double total = 0.0;
    int totalLinks = 0;

    try {
      List<Map> m = await _db.rawQuery(
          '''Select Count(id) as COUNT, type,through, Sum(amount) as TOTALAMOUNT
      From tb_analytics 
      Group by type,through''');

      return [
        {
          "links":
              m.where((element) => element['type'] == 'LINK').toList().length >
                      0
                  ? m
                      .where((element) => element['type'] == 'LINK')
                      .toList()
                      .first['COUNT']
                  : 0,
          "qrcode": m
                      .where((element) => element['type'] == 'QRCODE')
                      .toList()
                      .length >
                  0
              ? m
                  .where((element) => element['type'] == 'QRCODE')
                  .toList()
                  .first['COUNT']
              : 0,
          "app": m
                      .where((element) => element['type'] == 'DIRECT')
                      .toList()
                      .length >
                  0
              ? m
                  .where((element) => element['type'] == 'DIRECT')
                  .toList()
                  .first['COUNT']
              : 0,
        },
        total
      ];
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  /*Future<double> totalSettledAmount() async {
    final _db = await db;


    try {
      List<Map> m = await _db.rawQuery(
          '''Select Sum(${SettlementHistoryData.column_totalSettlementAmount}) as TOTALAMOUNT
      From ${SettlementHistoryData.tableName} 
      ''');

      return (m.length) != 0
          ? double.tryParse(m.first['TOTALAMOUNT'].toString()) ?? 0
          : 0;


    } catch (e) {
      recordError(e, StackTrace.current);
      return 0;
    }
  }*/

  ///To get total payable amount of customers which are not deleted
  Future<double> getTotalPayforAllCustomers(String businessId) async {
    final _db = await db;
    try {
      final totalPay = await _db.rawQuery(
          'SELECT SUM(${CustomerModel.columnTransactionAmount}) as TOTALPAY FROM ${CustomerModel.customerTableName} WHERE ${CustomerModel.columnBusinessId} = ? AND ${CustomerModel.columnTransactionType} = ? AND ${CustomerModel.columnIsDeleted} = ?',
          [businessId, 'PAY', 0]);
      return (totalPay.length) != 0
          ? double.tryParse(totalPay.first['TOTALPAY'].toString()) ?? 0
          : 0;
    } catch (e) {
      recordError(e, StackTrace.current);
      return 0;
    }
  }

  ///To get total receiveable amount of customers which are not deleted
  Future<double> getTotalReceiveforAllCustomers(String businessId) async {
    final _db = await db;
    try {
      final totalReceive = await _db.rawQuery(
          'SELECT SUM(${CustomerModel.columnTransactionAmount}) as TOTALRECEIVE FROM ${CustomerModel.customerTableName} WHERE ${CustomerModel.columnBusinessId} = ? AND ${CustomerModel.columnTransactionType} = ? AND ${CustomerModel.columnIsDeleted} = ?',
          [businessId, 'RECEIVE', 0]);
      return (totalReceive.length) != 0
          ? double.tryParse(totalReceive.first['TOTALRECEIVE'].toString()) ?? 0
          : 0;
    } catch (e) {
      recordError(e, StackTrace.current);
      return 0;
    }
  }

  ///Common Function which returns both amounts
  Future<List<double>> getTotalPayReceiveForCustomer(String businessId) async {
    try {
      return await Future.wait([
        getTotalPayforAllCustomers(businessId),
        getTotalReceiveforAllCustomers(businessId)
      ]);
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  ///To check if the customer exist before inserting new customer
  Future<bool> isCustomerAdded(String mobileNo) async {
    final _db = await db;
    try {
      List<Map> maps = await _db.query(CustomerModel.customerTableName,
          columns: [CustomerModel.columnMobileNo],
          where: '${CustomerModel.columnMobileNo}=?',
          whereArgs: [mobileNo]);
      if (maps.length > 0) return true;
      return false;
    } catch (e) {
      recordError(e, StackTrace.current);
      return false;
    }
  }

  Future<String> getCustomerId(String mobileNo) async {
    final _db = await db;
    try {
      final maps = await _db.query(CustomerModel.customerTableName,
          columns: [CustomerModel.columnId],
          where: '${CustomerModel.columnMobileNo}=?',
          whereArgs: [mobileNo]);
      if (maps.isEmpty) return '';
      return maps.first[CustomerModel.columnId] as String;
    } catch (e) {
      recordError(e, StackTrace.current);
      return '';
    }
  }

  Future<int?> updateCustomerDetails(double amount,
      TransactionType? transactionType, String? customerId) async {
    final _db = await db;
    final Map<String, dynamic> map = {
      CustomerModel.columnTransactionAmount: removeDecimalif0(amount),
      CustomerModel.columnUpdatedDate: DateTime.now().toIso8601String(),
      CustomerModel.columnTransactionType: transactionType == null
          ? null
          : transactionType == TransactionType.Pay
              ? 'PAY'
              : 'RECEIVE',
      CustomerModel.columnIsChanged: 1
    };

    try {
      return await _db.update(CustomerModel.customerTableName, map,
          where: '${CustomerModel.columnId} = ?', whereArgs: [customerId]);
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<int?> updateCollectionDate(
      DateTime? collectionDate, String? customerId) async {
    final _db = await db;
    final Map<String, dynamic> map = {
      CustomerModel.columnCollectionDate: collectionDate?.toIso8601String(),
      CustomerModel.columnIsChanged: 1
    };
    try {
      return await _db.update(CustomerModel.customerTableName, map,
          where: '${CustomerModel.columnId} = ?', whereArgs: [customerId]);
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<int?> updateChatId(String? chatId,
      {String? customerId, String? mobileNo}) async {
    debugPrint('chat id id ' + chatId.toString());
    debugPrint('customer id id ' + customerId.toString());
    final _db = await db;
    final Map<String, dynamic> map = {
      CustomerModel.columnChatId: chatId,
      CustomerModel.columnIsChanged: 1
    };
    try {
      if (mobileNo?.isNotEmpty ?? false) {
        return await _db.update(CustomerModel.customerTableName, map,
            where: '${CustomerModel.columnMobileNo} = ?',
            whereArgs: [mobileNo]);
      } else {
        return await _db.update(CustomerModel.customerTableName, map,
            where: '${CustomerModel.columnId} = ?', whereArgs: [customerId]);
      }
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<int?> updateCustomerIsChanged(
      int isChanged, String customerId, String? chatId) async {
    final _db = await db;
    final Map<String, dynamic> map = {
      CustomerModel.columnChatId: chatId,
      CustomerModel.columnIsChanged: isChanged
    };
    try {
      return await _db.update(CustomerModel.customerTableName, map,
          // {CustomerModel.columnIsChanged: isChanged},
          where: '${CustomerModel.columnId} = ?',
          whereArgs: [customerId]);
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<int?> updateCustomerIsDeleted(
      String customerId, int isDeleted, String businessId) async {
    final _db = await db;
    try {
      return await _db.update(
        CustomerModel.customerTableName,
        {CustomerModel.columnIsDeleted: isDeleted},
        where:
            '${CustomerModel.columnId} = ? AND ${CustomerModel.columnBusinessId} = ?',
        whereArgs: [customerId, businessId],
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<int?> deleteCustomer(String customerId, String businessId) async {
    final _db = await db;
    try {
      return await _db.delete(
        CustomerModel.customerTableName,
        where:
            '${CustomerModel.columnId} = ? AND ${CustomerModel.columnBusinessId} = ?',
        whereArgs: [customerId, businessId],
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  //UpdateCustomerName
  // Future<int> updateCustomerName(
  //     String name, int customerId) async {
  //   final _db = await db;
  //   final CustomerModel customerModel = CustomerModel();
  //   final Map<String, dynamic> map = {
  //     customerModel.columnName: name,
  //     customerModel.columnUpdatedDate: DateTime.now().toIso8601String(),

  //     customerModel.columnIsChanged: 1
  //   };

  //   return await _db.update(customerModel.customerTableName, map,
  //       where: '${customerModel.columnId} = ?', whereArgs: [customerId]);
  // }

  ///TransactionQueries
  Future<int?> insertLedgerTransaction(
      TransactionModel transactionModel) async {
    final _db = await db;
    try {
      return await _db.insert(
        TransactionModel.tableName,
        transactionModel.toDb(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<int?> updateLedgerTransaction(
      TransactionModel transactionModel) async {
    final _db = await db;
    try {
      return await _db.update(
        TransactionModel.tableName,
        transactionModel.toDb(),
        where: '${TransactionModel.columnTransactionId} = ?',
        whereArgs: [transactionModel.transactionId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<int?> deleteLedgerTransaction(
      TransactionModel transactionModel) async {
    final _db = await db;
    try {
      return await _db.delete(
        TransactionModel.tableName,
        where: '${TransactionModel.columnTransactionId} = ?',
        whereArgs: [transactionModel.transactionId],
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<int?> updateLedgerIsDeleted(
      TransactionModel transactionModel, int isDeleted) async {
    final _db = await db;
    try {
      return await _db.update(
        TransactionModel.tableName,
        {TransactionModel.columnIsDeleted: isDeleted},
        where: '${TransactionModel.columnTransactionId} = ?',
        whereArgs: [transactionModel.transactionId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<int?> updateLedgerIsChanged(
      TransactionModel transactionModel, int isChanged) async {
    final _db = await db;
    try {
      return await _db.update(
        TransactionModel.tableName,
        {TransactionModel.columnIsChanged: isChanged},
        where: '${TransactionModel.columnTransactionId} = ?',
        whereArgs: [transactionModel.transactionId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<List<TransactionModel>> getLedgerTransactions(
      String? customerId) async {
    final _db = await db;
    try {
      return (await _db.query(TransactionModel.tableName,
              where:
                  '${TransactionModel.columnCustomerId} = ? AND ${TransactionModel.columnIsDeleted} = ?',
              whereArgs: [customerId, 0],orderBy: '${TransactionModel.columnDate} DESC'))
          .map((element) {
        return TransactionModel().fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List<TransactionModel>> getLedgerTransactionsToSync() async {
    final _db = await db;
    try {
      return (await _db.query(TransactionModel.tableName,
              where:
                  '${TransactionModel.columnIsChanged} = ? AND ${TransactionModel.columnIsDeleted} = ?',
              whereArgs: [1, 0]))
          .map((element) {
        return TransactionModel().fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List<TransactionModel>> getDeletedLedgerTransactionsToSync() async {
    final _db = await db;
    try {
      return (await _db.query(TransactionModel.tableName,
              where: '${TransactionModel.columnIsDeleted} = ?', whereArgs: [1]))
          .map((element) {
        return TransactionModel().fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<double> getTotalPaidAmount(String customerId) async {
    final _db = await db;
    double amount = 0.0;
    try {
      (await _db.query(TransactionModel.tableName,
              columns: [TransactionModel.columnAmount],
              where:
                  '${TransactionModel.columnTransactionType} = ? AND ${TransactionModel.columnCustomerId} = ? AND ${TransactionModel.columnIsDeleted} = ?',
              whereArgs: ['PAY', customerId, 0]))
          .forEach((element) {
        amount +=
            double.tryParse(element[TransactionModel.columnAmount] as String) ??
                0;
      });
      return amount;
    } catch (e) {
      recordError(e, StackTrace.current);
      return 0;
    }
  }

  Future<double> getTotalReceivedAmount(String customerId) async {
    final _db = await db;
    double amount = 0.0;

    try {
      (await _db.query(TransactionModel.tableName,
              columns: [TransactionModel.columnAmount],
              where:
                  '${TransactionModel.columnTransactionType} = ? AND ${TransactionModel.columnCustomerId} = ? AND ${TransactionModel.columnIsDeleted} = ?',
              whereArgs: ['RECEIVE', customerId, 0]))
          .forEach((element) {
        amount +=
            double.tryParse(element[TransactionModel.columnAmount] as String) ??
                0;
      });
      return amount;
    } catch (e) {
      recordError(e, StackTrace.current);
      return 0;
    }
  }

  Future<double> getPaidMinusReceived(String customerId) async {
    final futures = await Future.wait(
        [getTotalPaidAmount(customerId), getTotalReceivedAmount(customerId)]);

    return futures.last - futures.first;
  }

  Future<bool> checkCustomerAdded(mobileNo, String businessId) async {
    final _db = await db;
    try {
      final checkCustomer = await _db.rawQuery(
          'SELECT count(*) as count FROM ${CustomerModel.customerTableName} WHERE ${CustomerModel.columnBusinessId} = ? AND ${CustomerModel.columnMobileNo} == "$mobileNo" AND ${CustomerModel.columnIsDeleted} = ?',
          [businessId, 0]);
      if (checkCustomer.first['count'] == 0) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      recordError(e, StackTrace.current);
      return false;
    }
  }

  Future<List<CustomerModel>> getCustomerDetails(String mobileNo, String businessId) async {
    final _db = await db;
    try {
      return (await _db.query(CustomerModel.customerTableName,
              where:
                  '${CustomerModel.columnMobileNo} = ? AND ${CustomerModel.columnBusinessId} = ? AND ${CustomerModel.columnIsDeleted} = ?',
              whereArgs: [mobileNo, businessId, 0]))
          .map((element) {
        return CustomerModel().fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  // Future getCustomerDetails(String mobileNo, String businessId) async {
  //   final _db = await db;
  //   try {
  //     final maps = await _db.query(CustomerModel.customerTableName,
  //         // columns: [CustomerModel.columnId],
  //         where:
  //             '${CustomerModel.columnMobileNo}=? AND ${CustomerModel.columnBusinessId}=? AND ${CustomerModel.columnIsDeleted}=?',
  //         whereArgs: [mobileNo, businessId, 0]);
  //     debugPrint(maps.first.toString());
  //     if (maps.isEmpty) return maps.first as CustomerModel;
  //     return maps.first as CustomerModel;
  //   } catch (e) {
  //     recordError(e, StackTrace.current);
  //     return [] as CustomerModel;
  //   }
  // }

//Suspense
  Future checkCustomerAddedForSuspense(mobileNo, String businessId) async {
    final _db = await db;
    try {
      final checkCustomer = await _db.rawQuery(
          'SELECT ${CustomerModel.columnId} FROM ${CustomerModel.customerTableName} WHERE ${CustomerModel.columnBusinessId} = ? AND ${CustomerModel.columnMobileNo} == "$mobileNo" AND ${CustomerModel.columnIsDeleted} = ?',
          [businessId, 0]);
      return checkCustomer.length > 0
          ? checkCustomer.first[CustomerModel.columnId].toString()
          : '';
    } catch (e) {
      recordError(e, StackTrace.current);
      return '';
    }

    // return (totalPay?.length ?? 0) != 0
    //     ? double.tryParse(totalPay.first['TOTALPAY'].toString() ?? '0') ?? 0
    //     : 0;
  }

  ///CashBook Queries
  Future<int?> insertCashbookEntry(
      CashbookEntryModel cashbookEntryModel) async {
    final _db = await db;
    try {
      return await _db.insert(
        CashbookEntryModel.tableName,
        cashbookEntryModel.toDb(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<int?> updateCashbookEntry(
      CashbookEntryModel cashbookEntryModel) async {
    final _db = await db;
    try {
      return await _db.update(
        CashbookEntryModel.tableName,
        cashbookEntryModel.toDb(),
        where:
            '${CashbookEntryModel.columnEntryId} = ? AND ${CashbookEntryModel.columnBusinessId} = ?',
        whereArgs: [cashbookEntryModel.entryId, cashbookEntryModel.businessId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<int?> deleteCashbookEntry(
      CashbookEntryModel cashbookEntryModel) async {
    final _db = await db;
    try {
      return await _db.delete(
        CashbookEntryModel.tableName,
        where:
            '${CashbookEntryModel.columnEntryId} = ? AND ${CashbookEntryModel.columnBusinessId} = ?',
        whereArgs: [cashbookEntryModel.entryId, cashbookEntryModel.businessId],
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<int?> updateCashbookEntryIsDeleted(
    CashbookEntryModel cashbookEntryModel,
    int isDeleted,
  ) async {
    final _db = await db;
    try {
      return await _db.update(
        CashbookEntryModel.tableName,
        {CashbookEntryModel.columnIsDeleted: isDeleted},
        where:
            '${CashbookEntryModel.columnEntryId} = ? AND ${CashbookEntryModel.columnBusinessId} = ?',
        whereArgs: [cashbookEntryModel.entryId, cashbookEntryModel.businessId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<int?> updateCashbookEntryIsChanged(
      CashbookEntryModel cashbookEntryModel, int isChanged) async {
    final _db = await db;
    try {
      return await _db.update(
        CashbookEntryModel.tableName,
        {CashbookEntryModel.columnIsChanged: isChanged},
        where:
            '${CashbookEntryModel.columnEntryId} = ? AND ${CashbookEntryModel.columnBusinessId} = ?',
        whereArgs: [cashbookEntryModel.entryId, cashbookEntryModel.businessId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<List<CashbookEntryModel>> getCashbookEntrys(
      DateTime date, String businessId) async {
    final _db = await db;
    try {
      return (await _db.query(CashbookEntryModel.tableName,
              where:
                  '${CashbookEntryModel.columnBusinessId} = ? AND ${CashbookEntryModel.columnIsDeleted} = ? AND ${CashbookEntryModel.columnCreatedDateOnly} = ?',
              whereArgs: [
            businessId,
            0,
            '${date.toIso8601String().substring(0, 10)}'
          ]))
          .map((element) {
        return CashbookEntryModel.fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List<CashbookEntryModel>> getCashbookEntrysBetweenDate(
      DateTime startDate, DateTime endDate, String businessId) async {
    final _db = await db;
    try {
      return (await _db.query(CashbookEntryModel.tableName,
              where:
                  '${CashbookEntryModel.columnBusinessId} = ? AND ${CashbookEntryModel.columnIsDeleted} = ? AND ${CashbookEntryModel.columnCreatedDateOnly} >= ? AND ${CashbookEntryModel.columnCreatedDateOnly} <= ?',
              whereArgs: [
            businessId,
            0,
            '${startDate.toIso8601String().substring(0, 10)}',
            '${endDate.toIso8601String().substring(0, 10)}'
          ],
              columns: [
            CashbookEntryModel.columnAmount,
            CashbookEntryModel.columnEntryType,
            CashbookEntryModel.columnCreatedDate,
            CashbookEntryModel.columnPaymentMode
          ]))
          .map((element) {
        return CashbookEntryModel.fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  ///Passing businessId is Not Required Here as we are targetting all the entries which are to be synced.
  Future<List<CashbookEntryModel>> getCashbookEntrysToSync() async {
    final _db = await db;
    try {
      return (await _db.query(CashbookEntryModel.tableName,
              where:
                  '${CashbookEntryModel.columnIsChanged} = ? AND ${CashbookEntryModel.columnIsDeleted} = ?',
              whereArgs: [1, 0]))
          .map((element) {
        return CashbookEntryModel.fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  ///Passing businessId is Not Required Here as we are targetting all the entries which are to be synced.
  Future<List<CashbookEntryModel>> getDeletedCashbookEntrysToSync() async {
    final _db = await db;
    try {
      return (await _db.query(CashbookEntryModel.tableName,
              where: '${CashbookEntryModel.columnIsDeleted} = ?',
              whereArgs: [1]))
          .map((element) {
        return CashbookEntryModel.fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<double> getTotalCashInHand(DateTime date, String businessId) async {
    final _db = await db;
    try {
      final totalCash = await _db.rawQuery(
          'SELECT SUM(${CashbookEntryModel.columnAmount}) as TOTALCASH FROM ${CashbookEntryModel.tableName} WHERE ${CashbookEntryModel.columnBusinessId} = ? AND  ${CashbookEntryModel.columnEntryType} = ? AND ${CashbookEntryModel.columnCreatedDateOnly} = ? AND ${CashbookEntryModel.columnIsDeleted} = ?',
          [businessId, 'IN', date.toIso8601String().substring(0, 10), 0]);
      return (totalCash.length) != 0
          ? double.tryParse(totalCash.first['TOTALCASH'].toString()) ?? 0
          : 0;
    } catch (e) {
      recordError(e, StackTrace.current);
      return 0;
    }
  }

  Future<double> getTotalCashInHandUntilDate(
      DateTime date, String businessId) async {
    final _db = await db;
    try {
      final totalCash = await _db.rawQuery(
          'SELECT (IFNULL(SUM(${CashbookEntryModel.columnAmount}),0) - (SELECT IFNULL(SUM(${CashbookEntryModel.columnAmount}),0) FROM ${CashbookEntryModel.tableName} WHERE ${CashbookEntryModel.columnEntryType} = ? AND ${CashbookEntryModel.columnCreatedDateOnly} <= ? AND ${CashbookEntryModel.columnBusinessId} = ? AND ${CashbookEntryModel.columnIsDeleted} = ?) ) as TOTALCASH FROM ${CashbookEntryModel.tableName} WHERE ${CashbookEntryModel.columnBusinessId} = ? AND ${CashbookEntryModel.columnEntryType} = ? AND ${CashbookEntryModel.columnCreatedDateOnly} <= ? AND ${CashbookEntryModel.columnIsDeleted} = ?',
          [
            'OUT',
            date.toIso8601String().substring(0, 10),
            businessId,
            0,
            businessId,
            'IN',
            date.toIso8601String().substring(0, 10),
            0
          ]);
      return (totalCash.length) != 0
          ? double.tryParse(totalCash.first['TOTALCASH'].toString()) ?? 0
          : 0;
    } catch (e) {
      recordError(e, StackTrace.current);
      return 0;
    }
  }

  Future<double> getTotalCashOutToday(DateTime date, String businessId) async {
    final _db = await db;
    try {
      final totalCash = await _db.rawQuery(
          'SELECT SUM(${CashbookEntryModel.columnAmount}) as TOTALCASH FROM ${CashbookEntryModel.tableName} WHERE ${CashbookEntryModel.columnBusinessId} = ? AND  ${CashbookEntryModel.columnEntryType} = ? AND ${CashbookEntryModel.columnCreatedDateOnly} = ? AND ${CashbookEntryModel.columnIsDeleted} = ?',
          [businessId, 'OUT', date.toIso8601String().substring(0, 10), 0]);
      return (totalCash.length) != 0
          ? double.tryParse(totalCash.first['TOTALCASH'].toString()) ?? 0
          : 0;
    } catch (e) {
      recordError(e, StackTrace.current);
      return 0;
    }
  }

  Future<double> dailyBalance(DateTime date, String businessId) async {
    final futures = await Future.wait([
      getTotalCashInHand(date, businessId),
      getTotalCashOutToday(date, businessId)
    ]);
    return futures.first - futures.last;
  }

  Future<double> getTotalOnlineAmount(DateTime date, String businessId) async {
    final _db = await db;
    try {
      final totalCash = await _db.rawQuery(
          'SELECT SUM(${CashbookEntryModel.columnAmount}) as TOTALCASH FROM ${CashbookEntryModel.tableName} WHERE ${CashbookEntryModel.columnBusinessId} = ? AND  ${CashbookEntryModel.columnPaymentMode} = ? AND ${CashbookEntryModel.columnCreatedDateOnly} = ? AND ${CashbookEntryModel.columnIsDeleted} = ?',
          [businessId, 'Online', date.toIso8601String().substring(0, 10), 0]);
      return (totalCash.length) != 0
          ? double.tryParse(totalCash.first['TOTALCASH'].toString()) ?? 0
          : 0;
    } catch (e) {
      recordError(e, StackTrace.current);
      return 0;
    }
  }

  Future<double> getTotalInOnlineAmount(
      DateTime date, String businessId) async {
    final _db = await db;
    try {
      final totalCash = await _db.rawQuery(
          'SELECT SUM(${CashbookEntryModel.columnAmount}) as TOTALCASH FROM ${CashbookEntryModel.tableName} WHERE ${CashbookEntryModel.columnBusinessId} = ? AND  ${CashbookEntryModel.columnPaymentMode} = ? AND ${CashbookEntryModel.columnEntryType} = ? AND ${CashbookEntryModel.columnCreatedDateOnly} = ? AND ${CashbookEntryModel.columnIsDeleted} = ?',
          [
            businessId,
            'Online',
            'IN',
            date.toIso8601String().substring(0, 10),
            0
          ]);
      return (totalCash.length) != 0
          ? double.tryParse(totalCash.first['TOTALCASH'].toString()) ?? 0
          : 0;
    } catch (e) {
      recordError(e, StackTrace.current);
      return 0;
    }
  }

  Future<double> getTotalOutOnlineAmount(
      DateTime date, String businessId) async {
    final _db = await db;
    try {
      final totalCash = await _db.rawQuery(
          'SELECT SUM(${CashbookEntryModel.columnAmount}) as TOTALCASH FROM ${CashbookEntryModel.tableName} WHERE ${CashbookEntryModel.columnBusinessId} = ? AND ${CashbookEntryModel.columnPaymentMode} = ? AND ${CashbookEntryModel.columnEntryType} = ? AND ${CashbookEntryModel.columnCreatedDateOnly} = ? AND ${CashbookEntryModel.columnIsDeleted} = ?',
          [
            businessId,
            'Online',
            'OUT',
            date.toIso8601String().substring(0, 10),
            0
          ]);
      return (totalCash.length) != 0
          ? double.tryParse(totalCash.first['TOTALCASH'].toString()) ?? 0
          : 0;
    } catch (e) {
      recordError(e, StackTrace.current);
      return 0;
    }
  }

  Future<DateTime?> getOldestDateCashbookRecord() async {
    final _db = await db;
    final date = await _db.rawQuery(
      'SELECT * FROM ${CashbookEntryModel.tableName} ORDER BY ${CashbookEntryModel.columnCreatedDate} LIMIT 1',
    );
    if (date.isEmpty) return null;
    return DateTime.tryParse(
            date.first[CashbookEntryModel.columnCreatedDate] as String)!
        .date;
  }

  ///ImportedContacts
  Future<int?> insertContact(ImportContactModel importContactModel) async {
    final _db = await db;
    try {
      return await _db.insert(
          ImportContactModel.tableName, importContactModel.toDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<List<ImportContactModel>> getContacts() async {
    final _db = await db;
    try {
      return (await _db.query(ImportContactModel.tableName)).map((element) {
        return ImportContactModel.fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<int?> updateContact(String customerId, String mobile) async {
    final _db = await db;
    try {
      return await _db.update(
        ImportContactModel.tableName,
        {
          ImportContactModel.columnCustomerId: customerId,
        },
        where: '${ImportContactModel.columnMobileNo} = ?',
        whereArgs: [mobile],
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  ///Business
  Future<int?> insertBusiness(BusinessModel businessModel) async {
    final _db = await db;
    try {
      return await _db.insert(BusinessModel.tableName, businessModel.toDb(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<int?> updateBusiness(BusinessModel businessModel) async {
    final _db = await db;
    try {
      return await _db.update(
        BusinessModel.tableName,
        {
          BusinessModel.columnName: businessModel.businessName,
        },
        where: '${BusinessModel.columnBusinessId} = ?',
        whereArgs: [businessModel.businessId],
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<List<BusinessModel>> getBusinesses() async {
    final _db = await db;
    try {
      return (await _db.query(BusinessModel.tableName,
              where: '${BusinessModel.columnIsDeleted} = ?', whereArgs: [0]))
          .map((element) {
        return BusinessModel.fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<int?> updateBusinessIsDeleted(String businessId, int isDeleted) async {
    final _db = await db;
    try {
      return await _db.update(
        BusinessModel.tableName,
        {BusinessModel.columnIsDeleted: isDeleted},
        where: '${BusinessModel.columnBusinessId} = ?',
        whereArgs: [businessId],
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<List<BusinessModel>> getBusinessToSync() async {
    final _db = await db;
    try {
      return (await _db.query(BusinessModel.tableName,
              where:
                  '${BusinessModel.columnIsChanged} = ? AND ${BusinessModel.columnIsDeleted} = ?',
              whereArgs: [1, 0]))
          .map((element) {
        return BusinessModel.fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List<BusinessModel>> getDeletedBusinessToSync() async {
    final _db = await db;
    try {
      return (await _db.query(BusinessModel.tableName,
              where: '${BusinessModel.columnIsDeleted} = ?', whereArgs: [1]))
          .map((element) {
        return BusinessModel.fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<int?> updateBusinessIsChanged(
      BusinessModel businessModel, int isChanged) async {
    final _db = await db;
    try {
      return await _db.update(
        BusinessModel.tableName,
        {BusinessModel.columnIsChanged: isChanged},
        where: '${BusinessModel.columnBusinessId} = ?',
        whereArgs: [businessModel.businessId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<int?> deleteBusiness(BusinessModel businessModel) async {
    final _db = await db;
    try {
      return await _db.delete(
        BusinessModel.tableName,
        where: '${BusinessModel.columnBusinessId} = ?',
        whereArgs: [businessModel.businessId],
      );
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  ///GLOBAL REPORT

  Future<List> getCustomerTransactionDataOnDate(
      DateTime start, DateTime end, String businessId) async {
    final _db = await db;
    try {
      List<Map> m = await _db.rawQuery(
          '''SELECT  c.ID, SUM(CASE  WHEN t.TRANSACTIONTYPE = 'PAY' THEN CAST(t.AMOUNT AS Decimal)  ELSE 0 END) as PAY ,SUM(CASE  WHEN t.TRANSACTIONTYPE = 'RECEIVE' THEN t.AMOUNT ELSE 0 END)  AS RECEIVE, c.NAME, c.MOBILENO
             FROM CUSTOMER c
             INNER JOIN  TRANSACTION_TABLE t
             ON c.ID = t.CUSTOMERID WHERE c.BUSINESSID = ? AND t.DATE>= ? AND t.DATE <= ? AND c.ISDELETED = ? AND t.ISDELETED = ? GROUP BY c.ID''',
          [businessId, start.toIso8601String(), end.toIso8601String(), 0, 0]);
      // '''SELECT COUNT(ID) as TOTALCOUNT, SUM(CASE  WHEN TRANSACTIONTYPE = 'PAY' THEN CAST(TRANSACTIONAMOUNT AS Decimal)  ELSE 0 END) as PAY ,SUM(CASE  WHEN TRANSACTIONTYPE = 'RECEIVE' THEN TRANSACTIONAMOUNT ELSE 0 END)  AS RECEIVE
      //    FROM CUSTOMER
      //    WHERE EXISTS
      //    (SELECT CUSTOMERID FROM TRANSACTION_TABLE  WHERE DATE>= ? AND DATE <= ?) AND BUSINESSID = ?''',
      // [ start.toIso8601String(), end.toIso8601String(),businessId,]
      // m.sort((a, b) => (a['ID'] as String).compareTo(b['ID']as String));
      double pay = 0;
      double receive = 0;
      double totalPay = 0;
      double totalReceive = 0;
      // int count = 0;
      // for (int i = 0; i < m.length + 1; i++) {
      //   if (i == m.length) {
      //     if ((receive - pay).isNegative) {
      //       totalPay += receive - pay;
      //       receive = 0;
      //       pay = 0;
      //     } else {
      //       totalReceive += receive - pay;
      //       receive = 0;
      //       pay = 0;
      //     }
      //   } else if (i == 0) {
      //     if (m[i]['TRANSACTIONTYPE'] == 'PAY') {
      //       pay += double.tryParse(m[i]['AMOUNT']) ?? 0;
      //     } else {
      //       receive += double.tryParse(m[i]['AMOUNT']) ?? 0;
      //     }
      //     count++;
      //   } else {
      //     if (m[i]['ID'] == m[i - 1]['ID']) {
      //       if (m[i]['TRANSACTIONTYPE'] == 'PAY') {
      //         pay += double.tryParse(m[i]['AMOUNT']) ?? 0;
      //       } else {
      //         receive += double.tryParse(m[i]['AMOUNT']) ?? 0;
      //       }
      //     } else {
      //       if ((receive - pay).isNegative) {
      //         totalPay += receive - pay;
      //         receive = 0;
      //         pay = 0;
      //       } else {
      //         totalReceive += receive - pay;
      //         receive = 0;
      //         pay = 0;
      //       }
      //       count++;
      //     }
      //   }
      //
      // }
      for (int i = 0; i < m.length; i++) {
        pay = double.tryParse(m[i]['PAY'].toString()) ?? 0;
        receive = double.tryParse(m[i]['RECEIVE'].toString()) ?? 0;
        if ((receive - pay).isNegative) {
          totalPay += receive - pay;
          receive = 0;
          pay = 0;
        } else {
          totalReceive += receive - pay;
          receive = 0;
          pay = 0;
        }
      }
      return [
        m.length,
        // double.tryParse(m.first['PAY'].toString()) ?? 0.0,
        // double.tryParse(m.first['RECEIVE'].toString()) ?? 0.0,
        totalPay,
        totalReceive, m
      ];
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<DateTime> oldestCustomerTransactionData() async {
    final _db = await db;
    try {
      List<Map> m = await _db.rawQuery(
        '''SELECT MIN(t.DATE) AS DATE
             FROM CUSTOMER c
             INNER JOIN  TRANSACTION_TABLE t
             ON c.ID = t.CUSTOMERID''',
      );

      return DateTime.tryParse(m.first['DATE']) ?? DateTime.now();
    } catch (e) {
      recordError(e, StackTrace.current);
      return DateTime.now();
    }
  }

  Future<DateTime> oldestCustomerSuspenseData() async {
    final _db = await db;
    try {
      List<Map> m = await _db.rawQuery(
        '''SELECT MIN(${SuspenseData.columncreatedAt}) AS DATE
             FROM ${SuspenseData.tableName} where ${SuspenseData.columnIsMoved} = 0
             ''',
      );

      return DateTime.tryParse(m.first['DATE']) ?? DateTime.now();
    } catch (e) {
      recordError(e, StackTrace.current);
      return DateTime.now();
    }
  }

  Future<DateTime> oldestSettlementHistoryData() async {
    final _db = await db;
    try {
      List<Map> m = await _db.rawQuery(
        '''SELECT MIN(${SettlementHistoryData.column_createdAt}) AS DATE
             FROM ${SettlementHistoryData.tableName}
             ''',
      );

      return DateTime.tryParse(m.first['DATE']) ?? DateTime.now();
    } catch (e) {
      recordError(e, StackTrace.current);
      return DateTime.now();
    }
  }

  getPrimaryBusiness() async {
    final _db = await db;
    try {
      var m = await _db.rawQuery(
          "SELECT BUSINESSID FROM BUSINESS_TABLE WHERE DELETEACTION = 0");
      Map<String, dynamic> data = m.first;
      await CustomSharedPreferences.setString(
          'primaryBusiness', data['BUSINESSID']);
      String data1 = await (CustomSharedPreferences.get('primaryBusiness'));
      debugPrint('qwe: ' + data1);
      // return data;
    } catch (e) {}
  }

  Future<void> clearULTables() async {
    final _db = await db;
    final batch = _db.batch();
    try {
      batch.delete(TransactionModel.tableName);
      batch.delete(CustomerModel.customerTableName);
      batch.delete(CashbookEntryModel.tableName);
      batch.delete(ImportContactModel.tableName);
      batch.delete(BusinessModel.tableName);
      batch.delete(Datum.tableName); // mobile analytics
      batch.delete(SuspenseData.tableName);
      batch.delete(CustomerRankingData.tableName); // suspense Account

      await batch.commit(noResult: true);
    } catch (e) {
      recordError(e, StackTrace.current);
      return;
    }
  }

  Future<void> clearImportedContacts() async {
    final _db = await db;
    final batch = _db.batch();
    try {
      batch.delete(ImportContactModel.tableName);

      oldestSettlementHistoryData() {}
      await batch.commit(noResult: true);
    } catch (e) {
      recordError(e, StackTrace.current);
      return;
    }
  }

  Future<void> clearSuspenseTable() async {
    final _db = await db;
    final batch = _db.batch();
    try {
      batch.delete(SuspenseData.tableName); // suspense Account

      await batch.commit(noResult: true);
    } catch (e) {
      recordError(e, StackTrace.current);
      return;

      getSettlementHistoryOfflineData() {}
    }
  }

  Future<void> clearSettlementHistoryTable() async {
    final _db = await db;
    final batch = _db.batch();
    try {
      batch.delete(SettlementHistoryData.tableName); // suspense Account

      await batch.commit(noResult: true);
    } catch (e) {
      recordError(e, StackTrace.current);
      return;
    }
  }
}

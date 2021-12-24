import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:urbanledger/Models/analytics_model.dart';
import 'package:urbanledger/Services/local_db.dart';
import 'package:urbanledger/Utility/app_services.dart';

mixin MobileAnalyticsQueries {
  ///Mobile Analytics
  static final Future<Database> db = LocalDb.db.database;

  Future<List<Map>> getCustomerCountForThisYear(
      DateTime start, DateTime end) async {
    final _db = await db;
    int isDeleted = 0;
    try {
      List<Map> m = await _db.rawQuery('''WITH RECURSIVE dates(date) AS (
  VALUES('${start.toIso8601String()}')
  UNION ALL
  SELECT date(date, '+1 day')
  FROM dates
  WHERE date <= date('${end.toIso8601String()}', '-1 days')
)
SELECT 
STRFTIME('%m-%Y', date) as MONTH  ,
(Select Count(id)
           From CUSTOMER 
           Where STRFTIME('%m-%Y',UPDATEDDATE)=STRFTIME('%m-%Y', date) AND isDeleted = ${isDeleted.toInt()}) as COUNT
FROM dates; 
           Group by  STRFTIME('%m-%Y', CREATEDDATE) 
           Order by  STRFTIME('%Y', CREATEDDATE)''');
      return m;
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List<Map>> getCustomerCountForThisMonth(
      DateTime start, DateTime end) async {
    final _db = await db;
    int isDeleted = 0;
    try {
      debugPrint("WITH RECURSIVE dates(date) AS (VALUES('${start.toIso8601String()}') UNION ALL SELECT DATE(date, '+1 day') FROM dates WHERE date < date('now','localtime')))) SELECT STRFTIME('%d-%m-%Y', date) as DAY, (Select Count(id) From CUSTOMER Where STRFTIME('%d-%m-%Y',UPDATEDDATE)=STRFTIME('%d-%m-%Y', date) AND isDeleted = ${isDeleted.toInt()}) as COUNT FROM dates");
      List<Map> m = await _db.rawQuery('''WITH RECURSIVE dates(date) AS (
  VALUES('${start.toIso8601String()}')
  UNION ALL
  SELECT DATE(date, '+1 day')
  FROM dates
  WHERE date < date('${end.toIso8601String()}')
)
SELECT 
STRFTIME('%d-%m-%Y', date) as DAY  ,
(Select Count(id)
           From CUSTOMER 
           Where STRFTIME('%d-%m-%Y',UPDATEDDATE)=STRFTIME('%d-%m-%Y', date) AND isDeleted = ${isDeleted.toInt()}) as COUNT
FROM dates;''');
      return m;
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List<Map>> getCustomerCountForMoreYears(
      DateTime start, DateTime end) async {
    final _db = await db;
    int isDeleted = 0;
    try {
      List<Map> m = await _db.rawQuery('''WITH RECURSIVE dates(date) AS (
        VALUES('${start.toIso8601String()}')
        UNION ALL
        SELECT DATE(date, '+1 day')
        FROM dates
        WHERE date <= date('${end.toIso8601String()}', '-1 days')
      )
      SELECT 
      STRFTIME('%Y', date) as DAY  ,
      (Select Count(id)
                From CUSTOMER 
                Where STRFTIME('%Y',UPDATEDDATE)=STRFTIME('%Y', date) AND isDeleted = ${isDeleted.toInt()}) as COUNT
      FROM dates; 
           Group by  STRFTIME('%Y', CREATEDDATE) 
           Order by  STRFTIME('%Y', CREATEDDATE)''');
      return m;
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List<Map>> getCustomerCountForYears(
      DateTime start, DateTime end) async {
    final _db = await db;
    try {
      List<Map> m = await _db.rawQuery(
          '''Select Count(ID) as COUNT,STRFTIME('%Y', CREATEDDATE) as YEAR 
      From CUSTOMER 
      Where UPDATEDDATE >= ? AND UPDATEDDATE <= ?  AND ISDELETED = ?
      Group by  STRFTIME('%Y', UPDATEDDATE)  
      Order by  STRFTIME('%Y', UPDATEDDATE)''',
          [start.toIso8601String(), end.toIso8601String(), 0]);
      return m;
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List> getLinkCountForYears(DateTime start, DateTime end) async {
    final _db = await db;
    double total = 0.0;
    int totalLinks = 0;
    try {
      List<Map> m = await _db.rawQuery(
          // '''Select Count(id) as COUNT,STRFTIME('%m-%Y', created_at) as DAY  ,Sum(amount) as TOTALAMOUNT
          //  From tb_analytics
          //  Where created_at >= ? AND created_at <= ? AND type = ?
          //  Group by  STRFTIME('%m-%Y', created_at)
          //  Order by  STRFTIME('%m-%Y', created_at)''',
          // [start.toIso8601String(), end.toIso8601String(), 'LINK']
          '''WITH RECURSIVE dates(date) AS (
              VALUES('${start.toIso8601String()}')
              UNION ALL
              SELECT date(date, '+1 day')
              FROM dates
              WHERE date <= date('${end.toIso8601String()}', '-1 days')
            )
            SELECT 
            STRFTIME('%m-%Y', date) as DAY,
            (Select Sum(amount) 
                      From tb_analytics 
                      Where STRFTIME('%m-%Y',created_at)=STRFTIME('%m-%Y', date) AND type = 'LINK') as TOTALAMOUNT,
            (Select Count(id) 
                        From tb_analytics 
                        Where STRFTIME('%m-%Y',created_at)=STRFTIME('%m-%Y', date) AND type = 'LINK') as COUNT
            FROM dates; 
           Group by  STRFTIME('%m-%Y', created_at) 
           Order by  STRFTIME('%m-%Y', created_at)''');

      return [
        m,
        totalLinks,
        total,
      ];
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List> getLinkCountForMoreYears(DateTime start, DateTime end) async {
    final _db = await db;
    double total = 0.0;
    int totalLinks = 0;
    try {
      List<Map> m = await _db.rawQuery('''WITH RECURSIVE dates(date) AS (
              VALUES('${start.toIso8601String()}')
              UNION ALL
              SELECT date(date, '+1 day')
              FROM dates
              WHERE date <= date('${end.toIso8601String()}', '-1 days')
            )
            SELECT 
            STRFTIME('%Y', date) as DAY,
            (Select Sum(amount) 
                      From tb_analytics 
                      Where STRFTIME('%Y',created_at)=STRFTIME('%Y', date) AND type = 'LINK') as TOTALAMOUNT,
            (Select Count(id) 
                        From tb_analytics 
                        Where STRFTIME('%Y',created_at)=STRFTIME('%Y', date) AND type = 'LINK') as COUNT
            FROM dates; 
           Group by  STRFTIME('%Y', created_at) 
           Order by  STRFTIME('%Y', created_at)''');

      return [
        m,
        totalLinks,
        total,
      ];
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List> getQRCountForYears(DateTime start, DateTime end) async {
    final _db = await db;
    double total = 0.0;
    int totalLinks = 0;
    try {
      List<Map> m = await _db.rawQuery(
          // '''Select Count(id) as COUNT,STRFTIME('%m-%Y', created_at) as DAY  ,Sum(amount) as TOTALAMOUNT
          //  From tb_analytics
          //  Where created_at >= ? AND created_at <= ? AND type = ?
          //  Group by  STRFTIME('%m-%Y', created_at)
          //  Order by  STRFTIME('%m-%Y', created_at)''',
          // [start.toIso8601String(), end.toIso8601String(), 'QRCODE']
          '''WITH RECURSIVE dates(date) AS (
              VALUES('${start.toIso8601String()}')
              UNION ALL
              SELECT date(date, '+1 day')
              FROM dates
              WHERE date <= date('${end.toIso8601String()}', '-1 days')
            )
            SELECT DISTINCT
            STRFTIME('%m-%Y', date) as DAY,
            (Select Sum(amount) 
                      From tb_analytics 
                      Where STRFTIME('%m-%Y',created_at)=STRFTIME('%m-%Y', date) AND type = 'QRCODE') as TOTALAMOUNT,
            (Select Count(id) 
                        From tb_analytics 
                        Where STRFTIME('%m-%Y',created_at)=STRFTIME('%m-%Y', date) AND type = 'QRCODE') as COUNT
            FROM dates;''');

      m.forEach((element) {
        total += double.tryParse(element['TOTALAMOUNT'].toString()) ?? 0.0;
        totalLinks += int.tryParse(element['COUNT'].toString()) ?? 0;
      });

      return [
        m,
        totalLinks,
        total,
      ];
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List> getQRCountForMoreYears(DateTime start, DateTime end) async {
    final _db = await db;
    double total = 0.0;
    int totalLinks = 0;
    try {
      List<Map> m = await _db.rawQuery('''WITH RECURSIVE dates(date) AS (
        VALUES('${start.toIso8601String()}')
        UNION ALL
        SELECT date(date, '+1 Day')
        FROM dates
        WHERE date <= date('${end.toIso8601String()}', '-1 days')
        )
        SELECT DISTINCT
        STRFTIME('%Y', date) as DAY,
        (Select Sum(amount)
        From tb_analytics
        Where STRFTIME('%Y',created_at)=STRFTIME('%Y', date) AND type = 'QRCODE') as TOTALAMOUNT,
        (Select Count(id)
        From tb_analytics
        Where STRFTIME('%Y',created_at)=STRFTIME('%Y', date) AND type = 'QRCODE') as COUNT
        FROM dates;''');

      m.forEach((element) {
        total += double.tryParse(element['TOTALAMOUNT'].toString()) ?? 0.0;
        totalLinks += int.tryParse(element['COUNT'].toString()) ?? 0;
      });

      return [
        m,
        totalLinks,
        total,
      ];
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<Map<String, dynamic>> getCountAndAmount(
      String type, DateTime start, DateTime end) async {
    final _db = await db;
    try {
      print(
          "SELECT Count(id) as COUNT, Sum(amount) as TOTAL FROM tb_analytics WHERE created_at >= '" +
              start.toIso8601String() +
              "' AND created_at <= '" +
              end.toIso8601String() +
              "' AND type = '" +
              type +
              "'");
      var data = (await _db.rawQuery(
          "SELECT Count(id) as COUNT, Sum(amount) as TOTAL FROM tb_analytics WHERE created_at >= '" +
              start.toIso8601String() +
              "' AND created_at <= '" +
              end.toIso8601String() +
              "' AND type = '" +
              type +
              "'"));
      // Get first result
      var dbItem = data.first;
      Map<String, dynamic> mapRead = {
        'COUNT': dbItem['COUNT'] ?? 0,
        'TOTAL': dbItem['TOTAL'] ?? 0
      };
      print('qwertyuiop: ' + mapRead.toString());
      return mapRead;
    } catch (e) {
      recordError(e, StackTrace.current);
      return {};
    }
  }

  Future<Map<String, dynamic>> getCustomerCounts(
      DateTime start, DateTime end) async {
    final _db = await db;
    try {
      // print(
      //     "SELECT Count(id) as COUNT, Sum(amount) as TOTAL FROM tb_analytics WHERE created_at >= '" +
      //         start.toIso8601String() +
      //         "' AND created_at <= '" +
      //         end.toIso8601String() +
      //         "' AND type = 'LINK'");
      var data = (await _db.rawQuery(
          "SELECT Count(id) as COUNT FROM CUSTOMER WHERE UPDATEDDATE >= '" +
              start.toIso8601String() +
              "' AND UPDATEDDATE <= '" +
              end.toIso8601String() +
              "' AND ISDELETED =0"));
      // Get first result
      var dbItem = data.first;
      Map<String, dynamic> mapRead = {'COUNT': dbItem['COUNT']};
      print('qwertyuiop: ' + mapRead.toString());
      return mapRead;
    } catch (e) {
      recordError(e, StackTrace.current);
      return {};
    }
  }

  Future<int?> insertAnalytics(Datum importAnalyticsModel) async {
    print('dddd :' + importAnalyticsModel.toJson().toString());
    final _db = await db;
    try {
      return await _db.insert(Datum.tableName, importAnalyticsModel.toDb(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    } catch (e) {
      recordError(e, StackTrace.current);
      return null;
    }
  }

  Future<List> getTotalLinkGenerated(DateTime start, DateTime end) async {
    final _db = await db;
    double total = 0.0;
    int totalLinks = 0;

    try {
      List<Map> m = await _db.rawQuery(
          '''Select Count(id) as COUNT, type,through, Sum(amount) as TOTALAMOUNT
      From tb_analytics 
      Where created_at >= ? AND created_at <= ?
      Group by type,through''',
          [start.toIso8601String(), end.toIso8601String()]);

      m.forEach((element) {
        total += double.tryParse(element['TOTALAMOUNT'].toString()) ?? 0.0;
        totalLinks += int.tryParse(element['COUNT'].toString()) ?? 0;
      });

      return [
        {
          "Global/Dynamic Payment Link": getPercentage(
              m.where((element) => element['type'] == 'LINK').toList().length >
                      0
                  ? m
                      .where((element) => element['type'] == 'LINK')
                      .toList()
                      .first['COUNT']
                  : 0,
              totalLinks),
          "Static/Global QR code": getPercentage(
              m
                          .where((element) => element['type'] == 'QRCODE')
                          .toList()
                          .length >
                      0
                  ? m
                      .where((element) => element['type'] == 'QRCODE')
                      .toList()
                      .first['COUNT']
                  : 0,
              totalLinks),
          "UL App payment": getPercentage(
              m
                          .where((element) => element['type'] == 'DIRECT' && element['type'] == 'CHAT')
                          .toList()
                          .length >
                      0
                  ? m
                      .where((element) => element['type'] == 'DIRECT' && element['type'] == 'CHAT')
                      .toList()
                      .first['COUNT']
                  : 0,
              totalLinks),
        },
        total
      ];
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<double> getPieTotalAmount(DateTime start, DateTime end) async {
    final _db = await db;
    try {
      final totalPay = await _db.rawQuery(
          'SELECT SUM(amount) as TOTAL_AMOUNT from tb_analytics WHERE created_at >= ? AND created_at <= ?',
          [start.toIso8601String(), end.toIso8601String()]);
      return (totalPay.length) != 0
          ? double.tryParse(totalPay.first['TOTAL_AMOUNT'].toString()) ?? 0
          : 0;
    } catch (e) {
      recordError(e, StackTrace.current);
      return 0;
    }
  }

  double getPercentage(int value, int totalValue) {
    return (value * 100) / totalValue;
  }

  Future<List> getLinksData(DateTime start, DateTime end) async {
    final _db = await db;
    double total = 0.0;
    int totalLinks = 0;

    try {
      List<Map> m = await _db.rawQuery('''WITH RECURSIVE dates(date) AS (
              VALUES('${start.toIso8601String()}')
              UNION ALL
              SELECT date(date, '+1 day')
              FROM dates
              WHERE date < date('${end.toIso8601String()}')
            )
            SELECT 
            STRFTIME('%d-%m-%Y', date) as DAY,
            (Select Sum(amount) 
                      From tb_analytics 
                      Where STRFTIME('%d-%m-%Y',created_at)=STRFTIME('%d-%m-%Y', date) AND type = 'LINK') as TOTALAMOUNT,
            (Select Count(id) 
                        From tb_analytics 
                        Where STRFTIME('%d-%m-%Y',created_at)=STRFTIME('%d-%m-%Y', date) AND type = 'LINK') as COUNT
            FROM dates; 
           Group by  STRFTIME('%d-%m-%Y', created_at) 
           Order by  STRFTIME('%Y-%m-%d', created_at)''');

      m.forEach((element) {
        total += double.tryParse(element['TOTALAMOUNT'].toString()) ?? 0.0;
        totalLinks += int.tryParse(element['COUNT'].toString()) ?? 0;
      });

      return [
        m,
        totalLinks,
        total,
      ];
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List> getQRData(DateTime start, DateTime end) async {
    final _db = await db;
    double total = 0.0;
    int totalQR = 0;

    try {
      debugPrint(
          "WITH RECURSIVE dates(date) AS (VALUES('${start.toIso8601String()}') UNION ALL SELECT date(date, '+1 day') FROM dates WHERE date <= '${end.toIso8601String()}') SELECT STRFTIME('%d-%m-%Y', date) as DAY, (Select Sum(amount) From tb_analytics Where STRFTIME('%d-%m-%Y',created_at)=STRFTIME('%d-%m-%Y', date) AND type = 'QRCODE') as TOTALAMOUNT, (Select Count(id) From tb_analytics Where STRFTIME('%d-%m-%Y',created_at)=STRFTIME('%d-%m-%Y', date) AND type = 'QRCODE') as COUNT FROM dates");
      List<Map> m = await _db.rawQuery('''WITH RECURSIVE dates(date) AS (
              VALUES('${start.toIso8601String()}')
              UNION ALL
              SELECT date(date, '+1 day')
              FROM dates
              WHERE date < date('${end.toIso8601String()}')
            )
            SELECT 
            STRFTIME('%d-%m-%Y', date) as DAY,
            (Select Sum(amount) 
                      From tb_analytics 
                      Where STRFTIME('%d-%m-%Y',created_at)=STRFTIME('%d-%m-%Y', date) AND type = 'QRCODE') as TOTALAMOUNT,
            (Select Count(id) 
                        From tb_analytics 
                        Where STRFTIME('%d-%m-%Y',created_at)=STRFTIME('%d-%m-%Y', date) AND type = 'QRCODE') as COUNT
            FROM dates;''');

      m.forEach((element) {
        total += double.tryParse(element['TOTALAMOUNT'].toString()) ?? 0.0;
        totalQR += int.tryParse(element['COUNT'].toString()) ?? 0;
      });

      return [
        m,
        totalQR,
        total,
      ];
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List> getQRDataMonthly(DateTime start, DateTime end) async {
    final _db = await db;
    double total = 0.0;
    int totalQR = 0;

    try {
      // debugPrint("WITH RECURSIVE dates(date) AS (VALUES('${start.toIso8601String()}') UNION ALL SELECT date(date, '+1 day') FROM dates WHERE date <= '${end.toIso8601String()}') SELECT STRFTIME('%d-%m-%Y', date) as DAY, (Select Sum(amount) From tb_analytics Where STRFTIME('%d-%m-%Y',created_at)=STRFTIME('%d-%m-%Y', date) AND type = 'QRCODE') as TOTALAMOUNT, (Select Count(id) From tb_analytics Where STRFTIME('%d-%m-%Y',created_at)=STRFTIME('%d-%m-%Y', date) AND type = 'QRCODE') as COUNT FROM dates");
      List<Map> m = await _db.rawQuery('''WITH RECURSIVE dates(date) AS (
              VALUES('${start.toIso8601String()}')
              UNION ALL
              SELECT date(date, '+1 day')
              FROM dates
              WHERE date <= date('${end.toIso8601String()}', '-1 days')
            )
            SELECT DISTINCT
            STRFTIME('%m-%Y', date) as DAY,
            (Select Sum(amount) 
                      From tb_analytics 
                      Where STRFTIME('%m-%Y',created_at)=STRFTIME('%m-%Y', date) AND type = 'QRCODE') as TOTALAMOUNT,
            (Select Count(id) 
                        From tb_analytics 
                        Where STRFTIME('%m-%Y',created_at)=STRFTIME('%m-%Y', date) AND type = 'QRCODE') as COUNT
            FROM dates''');

      m.forEach((element) {
        total += double.tryParse(element['TOTALAMOUNT'].toString()) ?? 0.0;
        totalQR += int.tryParse(element['COUNT'].toString()) ?? 0;
      });

      return [
        m,
        totalQR,
        total,
      ];
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List<Map>> getPayableAmount(DateTime start, DateTime end) async {
    final _db = await db;
    try {
      List<Map> data = (await _db.rawQuery(
          "SELECT NAME, (SELECT SUM(AMOUNT) FROM TRANSACTION_TABLE WHERE DATE(DATE) BETWEEN '${start.toIso8601String().substring(0, 10)}' AND '${end.toIso8601String().substring(0, 10)}' AND TRANSACTIONTYPE = 'PAY' AND BUSINESSID = BUSSINESS) as PAYABLE from BUSINESS_TABLE ORDER BY BUSINESSID DESC"));
      return data;
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List<Map>> getReceivableAmount(DateTime start, DateTime end) async {
    final _db = await db;
    try {
      List<Map> data = (await _db.rawQuery(
          "SELECT NAME, (SELECT SUM(AMOUNT) FROM TRANSACTION_TABLE WHERE DATE(DATE) BETWEEN '${start.toIso8601String().substring(0, 10)}' AND '${end.toIso8601String().substring(0, 10)}' AND TRANSACTIONTYPE = 'RECEIVE' AND BUSINESSID = BUSSINESS) as RECEIVABLE FROM BUSINESS_TABLE ORDER BY BUSINESSID DESC"));
      return data;
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List> getBusinessSummaryData(
      DateTime start, DateTime end, String businessId) async {
    final _db = await db;
    try {
      List<Map> m = await _db.rawQuery(
          '''SELECT  c.ID, SUM(CASE  WHEN t.TRANSACTIONTYPE = 'PAY' THEN CAST(t.AMOUNT AS Decimal)  ELSE 0 END) as PAY ,
             SUM(CASE  WHEN t.TRANSACTIONTYPE = 'RECEIVE' THEN t.AMOUNT ELSE 0 END)  AS RECEIVE
             FROM CUSTOMER c
             INNER JOIN  TRANSACTION_TABLE t
             ON c.ID = t.CUSTOMERID WHERE c.BUSINESSID = ? AND t.DATE>= ? AND t.DATE <= ? AND c.ISDELETED = ? AND t.ISDELETED = ? GROUP BY c.ID''',
          [businessId, start.toIso8601String(), end.toIso8601String(), 0, 0]);
      double pay = 0;
      double receive = 0;
      double totalPay = 0;
      double totalReceive = 0;
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
      return [m.length, totalPay, totalReceive, m];
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  // Future<Map<String, dynamic>> getBusinessAmountPay(
  //     DateTime start, DateTime end) async {
  //   final _db = await db;
  //   try {
  //     var data = (await _db.rawQuery(
  //         "SELECT SUM(AMOUNT) as PAYABLE_AMOUNT From TRANSACTION_TABLE Where CREATEDDATE >= '2021-09-12T00:00:00.000' AND CREATEDDATE <= '2021-09-17T23:59:59.000' AND TRANSACTIONTYPE = 'PAY' AND ISDELETED = 0 "));
  //     // Get first result
  //     var dbItem = data.first;
  //     Map<String, dynamic> mapRead = {'PAYABLE_AMOUNT': dbItem['PAYABLE_AMOUNT']};
  //     print('qwertyuiop: ' + mapRead.toString());
  //     return mapRead;
  //   } catch (e) {
  //     recordError(e, StackTrace.current);
  //     return {};
  //   }
  // }

  Future<double> getBusinessAmountPay(DateTime start, DateTime end) async {
    final _db = await db;
    try {
      final totalPay = await _db.rawQuery(
          'SELECT SUM(AMOUNT) as PAYABLE_AMOUNT From TRANSACTION_TABLE Where DATE >= ? AND DATE <= ? AND TRANSACTIONTYPE = ? AND ISDELETED = ?',
          [start.toIso8601String(), end.toIso8601String(), 'PAY', 0]);
      return (totalPay.length) != 0
          ? double.tryParse(totalPay.first['PAYABLE_AMOUNT'].toString()) ?? 0
          : 0;
    } catch (e) {
      recordError(e, StackTrace.current);
      return 0;
    }
  }

  Future<double> getBusinessAmountReceive(DateTime start, DateTime end) async {
    final _db = await db;
    try {
      final totalPay = await _db.rawQuery(
          'SELECT SUM(AMOUNT) as RECEIVABLE_AMOUNT From TRANSACTION_TABLE Where DATE >= ? AND DATE <= ? AND TRANSACTIONTYPE = ? AND ISDELETED = ?',
          [start.toIso8601String(), end.toIso8601String(), 'RECEIVE', 0]);
      return (totalPay.length) != 0
          ? double.tryParse(totalPay.first['RECEIVABLE_AMOUNT'].toString()) ?? 0
          : 0;
    } catch (e) {
      recordError(e, StackTrace.current);
      return 0;
    }
  }

  Future<List<double>> getTotalPayReceiveForBusiness(
      DateTime start, DateTime end) async {
    try {
      return await Future.wait([
        getBusinessAmountPay(start, end),
        getBusinessAmountReceive(start, end)
      ]);
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List> getCashbookData(DateTime start, DateTime end) async {
    final _db = await db;
    double totalIN = 0.0;
    double totalOUT = 0;

    try {
      List<Map> m = await _db.rawQuery('''WITH RECURSIVE dates(date) AS (
              VALUES('${start.toIso8601String()}')
              UNION ALL
              SELECT date(date, '+1 day')
              FROM dates
              WHERE date < date('${end.toIso8601String()}')
            )
            SELECT DISTINCT
            STRFTIME('%d-%m-%Y', date) as DAY,
            (Select Sum(amount) 
                      From CASHBOOK_ENTRY_TABLE 
                      Where STRFTIME('%d-%m-%Y',CREATEDDATE)=STRFTIME('%d-%m-%Y', date) AND ENTRYTYPE = 'IN') as INAMOUNT,
            (Select Sum(amount) 
                                  From CASHBOOK_ENTRY_TABLE 
                                  Where STRFTIME('%d-%m-%Y',CREATEDDATE)=STRFTIME('%d-%m-%Y', date) AND ENTRYTYPE = 'OUT') as OUTAMOUNT
            FROM dates;''');

      m.forEach((element) {
        totalIN += double.tryParse(element['INAMOUNT'].toString()) ?? 0;
        totalOUT += int.tryParse(element['OUTAMOUNT'].toString()) ?? 0;
      });

      return [
        m,
        totalOUT,
        totalIN,
      ];
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List> getCashbookDataForYears(DateTime start, DateTime end) async {
    final _db = await db;
    double totalIN = 0;
    double totalOUT = 0;
    try {
      List<Map> m = await _db.rawQuery('''WITH RECURSIVE dates(date) AS (
              VALUES('${start.toIso8601String()}')
              UNION ALL
              SELECT date(date, '+1 day')
              FROM dates
              WHERE date <=date('${end.toIso8601String()}', '-1 days')
            )
            SELECT DISTINCT
            STRFTIME('%m-%Y', date) as DAY,
            (Select Sum(amount) 
                      From CASHBOOK_ENTRY_TABLE 
                      Where STRFTIME('%m-%Y',CREATEDDATE)=STRFTIME('%m-%Y', date) AND ENTRYTYPE = 'IN') as INAMOUNT,
            (Select Sum(amount) 
                                  From CASHBOOK_ENTRY_TABLE 
                                  Where STRFTIME('%m-%Y',CREATEDDATE)=STRFTIME('%m-%Y', date) AND ENTRYTYPE = 'OUT') as OUTAMOUNT
            FROM dates;''');

      m.forEach((element) {
        totalIN += double.tryParse(element['INAMOUNT'].toString()) ?? 0;
        totalOUT += double.tryParse(element['OUTAMOUNT'].toString()) ?? 0;
      });

      return [
        m,
        totalOUT,
        totalIN,
      ];
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List> getCashbookDataForMoreYears(DateTime start, DateTime end) async {
    final _db = await db;
    double totalIN = 0;
    double totalOUT = 0;
    try {
      List<Map> m = await _db.rawQuery('''WITH RECURSIVE dates(date) AS (
              VALUES('${start.toIso8601String()}')
              UNION ALL
              SELECT date(date, '+1 day')
              FROM dates
              WHERE date <=date('${end.toIso8601String()}', '-1 days')
            )
            SELECT DISTINCT
            STRFTIME('%Y', date) as DAY,
            (Select Sum(amount) 
                      From CASHBOOK_ENTRY_TABLE 
                      Where STRFTIME('%Y',CREATEDDATE)=STRFTIME('%Y', date) AND ENTRYTYPE = 'IN') as INAMOUNT,
            (Select Sum(amount) 
                                  From CASHBOOK_ENTRY_TABLE 
                                  Where STRFTIME('%Y',CREATEDDATE)=STRFTIME('%Y', date) AND ENTRYTYPE = 'OUT') as OUTAMOUNT
            FROM dates;''');

      m.forEach((element) {
        totalIN += double.tryParse(element['INAMOUNT'].toString()) ?? 0;
        totalOUT += double.tryParse(element['OUTAMOUNT'].toString()) ?? 0;
      });

      return [
        m,
        totalOUT,
        totalIN,
      ];
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<double> getTotalCashInHandFilterDate(
      DateTime start, DateTime end, String businessId) async {
    final _db = await db;
    try {
      final totalCash = await _db.rawQuery(
          'SELECT (IFNULL(SUM(amount),0) - (SELECT IFNULL(SUM(amount),0) FROM CASHBOOK_ENTRY_TABLE WHERE ENTRYTYPE = ? AND CREATEDDATEONLY <= ? AND BUSINESSID = ? AND ISDELETED = ?) ) as TOTALCASH FROM CASHBOOK_ENTRY_TABLE WHERE BUSINESSID = ? AND ENTRYTYPE = ? AND CREATEDDATEONLY <= ? AND ISDELETED = ?',
          [
            'OUT',
            // start.toIso8601String().substring(0, 10),
            end.toIso8601String().substring(0, 10),
            businessId,
            0,
            businessId,
            'IN',
            // start.toIso8601String().substring(0, 10),
            end.toIso8601String().substring(0, 10),
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

  Future<List<Map>> getTransactionCount() async {
    final _db = await db;
    try {
      List<Map> transactionCount = await _db.rawQuery(
          "SELECT (SELECT SUM(AMOUNT) FROM tb_analytics WHERE type = 'DIRECT') as APP, (SELECT SUM(AMOUNT) FROM tb_analytics WHERE type = 'QRCODE') as QRCODE, (SELECT SUM(AMOUNT) FROM tb_analytics WHERE type = 'LINK') as LINK");
      return transactionCount;
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }

  Future<List<Datum>> getTransactionHistory() async {
    final _db = await db;
    try {
      return (await _db.rawQuery(
              "select from_cust, mobile_no, amount, type, created_at from ${Datum.tableName}"))
          .map((element) {
        //debugPrint('check11' + element.toString());
        return Datum().fromDb(element);
      }).toList();
    } catch (e) {
      recordError(e, StackTrace.current);
      return [];
    }
  }
}

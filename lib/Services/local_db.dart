import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:urbanledger/Models/SuspenseAccountModel.dart';
import 'package:urbanledger/Models/analytics_model.dart';
import 'package:urbanledger/Models/business_model.dart';
import 'package:urbanledger/Models/cashbook_entry_model.dart';
import 'package:urbanledger/Models/customer_model.dart';
import 'package:urbanledger/Models/customer_ranking_model.dart';
import 'package:urbanledger/Models/import_contact_model.dart';
import 'package:urbanledger/Models/login_model.dart';
import 'package:urbanledger/Models/settlement_history_model.dart';
import 'package:urbanledger/Models/transaction_model.dart';
// import 'package:urbanledger/Models/user_profile_model.dart';

class LocalDb {
  LocalDb._();

  Database? _database;

  static LocalDb db = LocalDb._();

  static const int version = 1;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await init();
      return _database!;
    }
  }

  Future<Database> init() async {
    // await Sqflite.setDebugModeOn(kDebugMode ? true : false);
    await Sqflite.setDebugModeOn(false);
    final appDocDir = await getApplicationDocumentsDirectory();
    final path = join(appDocDir.path, "urbanledger.db");
    return openDatabase(path, version: version,
        onConfigure: (Database database) async {
      await database.execute('PRAGMA foreign_keys = ON');
    }, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future<void> _onCreate(Database _database, int version) async {
    final batch = _database.batch();

    batch.execute('''
          CREATE TABLE ${CustomerModel.customerTableName} (
            ${CustomerModel.columnId} STRING PRIMARY KEY NOT NULL,
            ${CustomerModel.columnMobileNo} TEXT,
            ${CustomerModel.columnChatId} TEXT,
            ${CustomerModel.columnName} TEXT NOT NULL,
            ${CustomerModel.columnAvatar} BLOB,
            ${CustomerModel.columnTransactionAmount} TEXT,
            ${CustomerModel.columnTransactionType} TEXT,
            ${CustomerModel.columnUpdatedDate} TEXT,
            ${CustomerModel.columnCreatedDate} TEXT,
            ${CustomerModel.columnCollectionDate} TEXT,
            ${CustomerModel.columnIsChanged} INTEGER NOT NULL,
            ${CustomerModel.columnIsDeleted} INTEGER NOT NULL,
            ${CustomerModel.columnBusinessId} STRING NOT NULL,
             FOREIGN KEY (${CustomerModel.columnBusinessId})
                REFERENCES ${BusinessModel.tableName} (${BusinessModel.columnBusinessId}) ON DELETE CASCADE
          )
          ''');
    batch.execute('''
          CREATE TABLE ${TransactionModel.tableName} (
            ${TransactionModel.columnTransactionId} STRING PRIMARY KEY NOT NULL,
            ${TransactionModel.columnAmount} TEXT NOT NULL,
            ${TransactionModel.columnBalanceAmount} TEXT NOT NULL,
            ${TransactionModel.columnDate} TEXT NOT NULL,
            ${TransactionModel.columnTransactionDetails} TEXT,
            ${TransactionModel.columnAttachment1} TEXT,
            ${TransactionModel.columnAttachment2} TEXT,
            ${TransactionModel.columnAttachment3} TEXT,
            ${TransactionModel.columnAttachment4} TEXT,
            ${TransactionModel.columnAttachment5} TEXT,
            ${TransactionModel.columnTransactionType} TEXT NOT NULL,
            ${TransactionModel.columnIsPayment} INTEGER NOT NULL,
            ${TransactionModel.columnPaymentTransactionId} TEXT NOT NULL,
            ${TransactionModel.columnCreatedDate} TEXT NOT NULL,
            ${TransactionModel.columnIsReadOnly} INTEGER NOT NULL,
            ${TransactionModel.columnIsChanged} INTEGER NOT NULL,
            ${TransactionModel.columnIsDeleted} INTEGER NOT NULL,
            ${TransactionModel.columnCustomerId} STRING NOT NULL,
            ${TransactionModel.columnBusiness} STRING NOT NULL,
            FOREIGN KEY (${TransactionModel.columnCustomerId})
                REFERENCES CUSTOMER (${CustomerModel.columnId}) ON DELETE CASCADE
          )
          ''');
    batch.execute('''
          CREATE TABLE ${CashbookEntryModel.tableName} (
            ${CashbookEntryModel.columnEntryId} STRING PRIMARY KEY NOT NULL,
            ${CashbookEntryModel.columnAmount} TEXT NOT NULL,
            ${CashbookEntryModel.columnEntryDetails} TEXT,
            ${CashbookEntryModel.columnAttachment1} TEXT,
            ${CashbookEntryModel.columnAttachment2} TEXT,
            ${CashbookEntryModel.columnAttachment3} TEXT,
            ${CashbookEntryModel.columnAttachment4} TEXT,
            ${CashbookEntryModel.columnAttachment5} TEXT,
            ${CashbookEntryModel.columnCreatedDate} TEXT NOT NULL,
            ${CashbookEntryModel.columnCreatedDateOnly} TEXT NOT NULL,
            ${CashbookEntryModel.columnEntryType} TEXT NOT NULL,
            ${CashbookEntryModel.columnPaymentMode} TEXT NOT NULL,
            ${CashbookEntryModel.columnIsChanged} INTEGER NOT NULL,
            ${CashbookEntryModel.columnIsDeleted} INTEGER NOT NULL,
            ${CashbookEntryModel.columnBusinessId} STRING NOT NULL,
             FOREIGN KEY (${CashbookEntryModel.columnBusinessId})
                REFERENCES ${BusinessModel.tableName} (${BusinessModel.columnBusinessId}) ON DELETE CASCADE
          )
          ''');
    batch.execute('''
          CREATE TABLE ${ImportContactModel.tableName} (
           ${ImportContactModel.columnId} TEXT PRIMARY KEY NOT NULL,
            ${ImportContactModel.columnMobileNo} TEXT NOT NULL,
            ${ImportContactModel.columnName} TEXT NOT NULL,
             ${ImportContactModel.columnCustomerId} TEXT,
            ${ImportContactModel.columnAvatar} BLOB
          )
          ''');
    batch.execute('''
          CREATE TABLE ${BusinessModel.tableName} (
           ${BusinessModel.columnBusinessId} TEXT PRIMARY KEY NOT NULL,   
           ${BusinessModel.columnName} TEXT NOT NULL,
           ${BusinessModel.columnDeleteAction} INTEGER NOT NULL,
           ${BusinessModel.columnIsChanged} INTEGER NOT NULL,
            ${BusinessModel.columnIsDeleted} INTEGER NOT NULL
          )
          ''');
    batch.execute('''
          CREATE TABLE ${Datum.tableName} (
            ${Datum.columnid} integer primary key autoincrement, 
            ${Datum.columnul_id} text unique,
            ${Datum.columntransaction_id} text unique,
            ${Datum.columnamount} integer not null,
            ${Datum.columncurrency} text not null,
            ${Datum.columnmobile_no} text not null,
            ${Datum.columnfrom} text not null,
            ${Datum.columnthrough} text not null,
            ${Datum.columntype} text not null,
            ${Datum.columnsuspense} integer default 0,
            ${Datum.columncreated_at} text not null, 
            ${Datum.columnupdated_at} text not null,
            ${Datum.columnstatus} integer default 0
          )
          ''');
    // ${SuspenseData.columnid} primary key autoincrement,

    batch.execute('''
          CREATE TABLE ${SuspenseData.tableName} ( 
          ${SuspenseData.columnid} integer primary key autoincrement,
          ${SuspenseData.columntransactionId} text unique , 
            ${SuspenseData.columnsuspense} integer default 0,
            ${SuspenseData.columnamount} integer not null, 
            ${SuspenseData.columncurrency} text not null, 
            ${SuspenseData.columnurbanledgerId} text not null,  
            ${SuspenseData.columnfrom} text not null, 
            ${SuspenseData.columnto}  text not null, 
            ${SuspenseData.columntoCustId}  text  not null, 
            ${SuspenseData.columnfromCustId}  text  not null,
            ${SuspenseData.columnchatId}  text  not null,
            ${SuspenseData.columntype}  text  not null,
            ${SuspenseData.columncardImage} text not null,
            ${SuspenseData.columnfromEmail} text not null,
            ${SuspenseData.columntoEmail} text not null,
            ${SuspenseData.columnpaymentMethod} text not null,   
            ${SuspenseData.columnbusinessIds} text not null,
         
            ${SuspenseData.columncreatedAt} text not null,
            ${SuspenseData.columnupdatedAt} text not null,
            ${SuspenseData.columncompleted} text not null,
            
            
            ${SuspenseData.columnfromMobileNumber}  integer not null,
            ${SuspenseData.columnIsMoved}   integer default 0
          )
          ''');

    batch.execute('''
          CREATE TABLE ${CustomerRankingData.tableName} ( 
          ${CustomerRankingData.columnId} integer primary key autoincrement,
          ${CustomerRankingData.columnCustomerId} text , 
           ${CustomerRankingData.columnMobileNo} text, 
            ${CustomerRankingData.columnChatId} text, 
            ${CustomerRankingData.columnEmailId} text, 
            ${CustomerRankingData.columnFirstName} text,  
            ${CustomerRankingData.columnLastName} text, 
            ${CustomerRankingData.columnRegisteredOn}  text, 
            ${CustomerRankingData.columnProfilePic}  text, 
            ${CustomerRankingData.columnUpdatedAt}  text,
            ${CustomerRankingData.columnReferralCode}  text,
            ${CustomerRankingData.columnReferralLink}  text,
             ${CustomerRankingData.columnType}  text,
             ${CustomerRankingData.columnContactData}  text  not null     
          )
          ''');

    batch.execute('''
    CREATE TABLE ${SettlementHistoryData.tableName} ( 
     ${SettlementHistoryData.column_id} integer primary key autoincrement,
  ${SettlementHistoryData.column_shId} text unique,
  ${SettlementHistoryData.column_transactionIds} text not null,
  ${SettlementHistoryData.column_status} text not null,
  ${SettlementHistoryData.column_isdeleted} integer default 0,
  ${SettlementHistoryData.column_settlementId} text not null,
  ${SettlementHistoryData.column_customerId} text not null,
  ${SettlementHistoryData.column_bankName} text not null,
  ${SettlementHistoryData.column_ibannNumber} text not null,
  ${SettlementHistoryData.column_fromDate} text not null,
  ${SettlementHistoryData.column_toDate} text not null,
  ${SettlementHistoryData.column_currency} text not null,
  ${SettlementHistoryData.column_totalSettlementAmount} text not null,
  ${SettlementHistoryData.column_totalFixedFeesAmount} text not null,
  ${SettlementHistoryData.column_totalMarginAmount} text not null,
  ${SettlementHistoryData.column_totalActualAmount} text not null,
  ${SettlementHistoryData.column_totalSettlementCommissionAmount} text not null,
  ${SettlementHistoryData.column_fileUrl} text not null,
  ${SettlementHistoryData.column_createdAt} text not null,
  ${SettlementHistoryData.column_updatedAt} text not null
          )
          ''');

    batch.execute('''
    CREATE TABLE ${LoginModel.tableName} ( 
      ${LoginModel.column_id} integer primary key autoincrement,
      ${LoginModel.column_user_id} text unique,
      ${LoginModel.column_user_name} text not null,
      ${LoginModel.column_pin} integer not null,
      ${LoginModel.column_login_date} text not null,
      ${LoginModel.column_updated_date} text not null,
      ${LoginModel.column_status} integer default 1,
    )''');

    await batch.commit(noResult: true);
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) {
    /// if(newVersion>oldVersion)
    ///execute operations
  }
}

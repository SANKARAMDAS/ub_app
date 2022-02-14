import 'package:sqflite/sqflite.dart';

class MessageTable {
  static Future<void> createTable(Database db) async {
    //messageType 0: normal message, 1: you pay, 2: you received, 3: reminder
    await db.execute('''
          create table tb_message (
            id_message integer primary key autoincrement, 
            _id text unique,
            chat_id text not null,
            request_id text,
            attachment_count integer,
            message text,
            details text,
            amount double,
            date_time text,
            contact_name text,
            contact_no text,
            transaction_id text unique,
            urbanledger_id text unique,
            type text,
            file_name text,
            file_size text,
            duration text,
            through text,
            suspense integer,
            messageType integer not null, 
            from_user text not null,
            to_user text not null,
            payment_status integer,
            send_at int not null,
            unread_by_me bool default 0,
            payment_cancel bool default 0,
            constraint tb_message_chat_id_fk foreign key (chat_id) references tb_chat (_id),
            constraint tb_message_from_user_fk foreign key (from_user) references tb_user (_id),
            constraint tb_message_to_user_fk foreign key (to_user) references tb_chat (_id)
          )
          ''');
    await db.execute('''
      CREATE INDEX idx_id_message
      ON tb_message (_id)
    ''');
  }

  static Future<void> recreateTable(Database db) async {
    await db.execute('''
          drop table if exists tb_message
          ''');
    await MessageTable.createTable(db);
  }

  static Future<void> dropTable(Database db) async {
    await db.execute('''
           drop table if exists tb_message
        ''');
  }
}

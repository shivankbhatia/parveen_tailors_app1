import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart'; // for date formatting
import 'package:parveen_tailors/screens/edit_customer_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CustomersDB {
  // singleton
  CustomersDB._(); // private constructor

  static final CustomersDB getInstance = CustomersDB._();
  static final String TABLE_NOTE = "note";
  static final String COLUMN_NOTE_SNO = "s_no";
  static final String COLUMN_NOTE_TITLE = "title";
  static final String COLUMN_NOTE_DESC = "desc";
  static final String COLUMN_MEAS_SHIRTL = "shirtLen";
  static final String COLUMN_MEAS_SHIRTC = "shirtChe";
  static final String COLUMN_MEAS_SHIRTT = "shirtTee";
  static final String COLUMN_MEAS_SHIRTB = "shirtBaa";
  static final String COLUMN_MEAS_SHIRTG = "shirtGal";
  static final String COLUMN_MEAS_SHIRTS = "shirtSle";
  static final String COLUMN_MEAS_SHIRTSTMCH = "shirtStmch";
  static final String COLUMN_MEAS_SHIRTHIP = "shirtHip";
  static final String COLUMN_MEAS_SHIRTHB = "shirtHb";

  static final String COLUMN_MEAS_KURTAL = "kurtaLen";
  static final String COLUMN_MEAS_KURTAH = "kurtaHus";
  static final String COLUMN_MEAS_KURTAM = "kurtaMam";
  static final String COLUMN_MEAS_PANTL = "pantLen";
  static final String COLUMN_MEAS_PANTK = "pantKya";
  static final String COLUMN_MEAS_PANTH = "pantHai";
  static final String COLUMN_MEAS_PANTP = "pantPai";
  static final String COLUMN_MEAS_PANTA = "pantAia";
  static final String COLUMN_MEAS_PANTM = "pantMai";
  static final String COLUMN_MEAS_PANTBP = "pantBPIS";
  static final String COLUMN_NOTE_ADDITIONAL = "additionalnote";

  static final String COLUMN_NOTE_DATE1 = "submitdate";
  static final String COLUMN_NOTE_DATE2 = "deliverdate";
  static final String COLUMN_NOTE_AMOUNT1 = "totalamount";
  static final String COLUMN_NOTE_AMOUNT2 = "balance";
  static final String COLUMN_NOTE_RECEIPT = "receipt";
  //static final String COLUMN_NOTE_IMAGE = "image";

  Database? myDB;
  // db open
  // path check, if exist then open, else create...
  Future<Database> getDB() async {
    if (myDB != null) {
      return myDB!;
    } else {
      myDB = await openDB();
      return myDB!;
    }
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String DBpath = join(appDir.path, "customersDB3.db");

    return await openDatabase(DBpath, onCreate: (db, version) {
      // create all tables here
      // 1.
      print('Creating table...');
      db.execute(
          "create table $TABLE_NOTE ( $COLUMN_NOTE_SNO integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text, $COLUMN_MEAS_SHIRTL text, $COLUMN_MEAS_SHIRTC text, $COLUMN_MEAS_SHIRTT text, $COLUMN_MEAS_SHIRTB text, $COLUMN_MEAS_SHIRTG text, $COLUMN_MEAS_SHIRTS text, $COLUMN_MEAS_SHIRTSTMCH text, $COLUMN_MEAS_SHIRTHIP text, $COLUMN_MEAS_SHIRTHB text, $COLUMN_MEAS_KURTAL text, $COLUMN_MEAS_KURTAH text, $COLUMN_MEAS_KURTAM text, $COLUMN_MEAS_PANTL text,  $COLUMN_MEAS_PANTK text, $COLUMN_MEAS_PANTH text, $COLUMN_MEAS_PANTP text,  $COLUMN_MEAS_PANTA text, $COLUMN_MEAS_PANTM text, $COLUMN_MEAS_PANTBP text, $COLUMN_NOTE_ADDITIONAL text, $COLUMN_NOTE_DATE1 text, $COLUMN_NOTE_DATE2 text, $COLUMN_NOTE_AMOUNT1 text, $COLUMN_NOTE_AMOUNT2 text, $COLUMN_NOTE_RECEIPT text)");
      // n...
    }, version: 1);
  }

  // all queries...
  // 1.insertion
  Future<bool> addContact({required String ttl, required String dsc}) async {
    var db = await getDB();
    int rowsAffected = await db.insert(TABLE_NOTE, {
      COLUMN_NOTE_TITLE: ttl,
      COLUMN_NOTE_DESC: dsc,
    });
    return rowsAffected > 0;
  }

  Future<bool> addNote({
    required String ttl,
    required String dsc,
    required String shirtL,
    required String shirtC,
    required String shirtT,
    required String shirtB,
    required String shirtG,
    required String shirtS,
    required String shirtST,
    required String shirtHP,
    required String shirtHB,
    required String kurtaL,
    required String kurtaH,
    required String kurtaM,
    required String pantL,
    required String pantK,
    required String pantH,
    required String pantP,
    required String pantA,
    required String pantM,
    required String pantBP,
    required String additionalnote,
    required String date1,
    required String date2,
    required String amount1,
    required String amount2,
    required String receipt,
    // required Uint8List imageBytes,
  }) async {
    var db = await getDB();
    int rowsAffected = await db.insert(TABLE_NOTE, {
      COLUMN_NOTE_TITLE: ttl,
      COLUMN_NOTE_DESC: dsc,
      COLUMN_MEAS_SHIRTL: shirtL,
      COLUMN_MEAS_SHIRTC: shirtC,
      COLUMN_MEAS_SHIRTT: shirtT,
      COLUMN_MEAS_SHIRTB: shirtB,
      COLUMN_MEAS_SHIRTG: shirtG,
      COLUMN_MEAS_SHIRTS: shirtS,
      COLUMN_MEAS_SHIRTSTMCH: shirtST,
      COLUMN_MEAS_SHIRTHIP: shirtHP,
      COLUMN_MEAS_SHIRTHB: shirtHB,
      COLUMN_MEAS_KURTAL: kurtaL,
      COLUMN_MEAS_KURTAH: kurtaH,
      COLUMN_MEAS_KURTAM: kurtaM,
      COLUMN_MEAS_PANTL: pantL,
      COLUMN_MEAS_PANTK: pantK,
      COLUMN_MEAS_PANTH: pantH,
      COLUMN_MEAS_PANTP: pantP,
      COLUMN_MEAS_PANTA: pantA,
      COLUMN_MEAS_PANTM: pantM,
      COLUMN_MEAS_PANTBP: pantBP,
      COLUMN_NOTE_ADDITIONAL: additionalnote,
      COLUMN_NOTE_DATE1: date1,
      COLUMN_NOTE_DATE2: date2,
      COLUMN_NOTE_AMOUNT1: amount1,
      COLUMN_NOTE_AMOUNT2: amount2,
      COLUMN_NOTE_RECEIPT: receipt,
      // COLUMN_NOTE_IMAGE: imageBytes,
    });
    print('Rows affected by addNote: $rowsAffected');
    return rowsAffected > 0;
  }

  // 2.reading all data
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();
    List<Map<String, dynamic>> data = await db.query(TABLE_NOTE);
    print('Fetched notes: $data');
    return data;
  }

  // Future<List<Map<String, dynamic>>> getRecentNotes() async {
  //   var db = await getDB(); // Getting the database
  //   List<Map<String, dynamic>> data =
  //       await db.query(TABLE_NOTE); // Querying the notes

  //   // Define the date format as 'dd-MM-yy'
  //   DateFormat dateFormat = DateFormat('dd-MM-yy');

  //   // Sort the data by the 'date' field, assuming it's stored in 'dd-MM-yy' format
  //   data.sort((a, b) {
  //     DateTime dateA =
  //         dateFormat.parse(a['date']); // Parse the string to DateTime
  //     DateTime dateB = dateFormat.parse(b['date']);
  //     return dateA.compareTo(dateB); // Sorting from earliest to latest
  //   });

  //   print('Sorted notes: $data');
  //   return data;
  // }

  // 3.Update data
  Future<bool> updateContact({
    required String ttl,
    required String dsc,
    required int sno,
  }) async {
    var db = await getDB();
    int rowsAffected = await db.update(
        TABLE_NOTE, {COLUMN_NOTE_TITLE: ttl, COLUMN_NOTE_DESC: dsc},
        where: "$COLUMN_NOTE_SNO = $sno");
    return rowsAffected > 0;
  }

  Future<bool> updateNotes({
    required String ttl,
    required String dsc,
    required int sno,
    required String shirtL,
    required String shirtC,
    required String shirtT,
    required String shirtB,
    required String shirtG,
    required String shirtS,
    required String shirtST,
    required String shirtHP,
    required String shirtHB,
    required String kurtaL,
    required String kurtaH,
    required String kurtaM,
    required String pantL,
    required String pantK,
    required String pantH,
    required String pantP,
    required String pantA,
    required String pantM,
    required String pantBP,
    required String additionalnote,
    required String date1,
    required String date2,
    required String amount1,
    required String amount2,
    required String receipt,
    // required Uint8List imageBytes,
  }) async {
    var db = await getDB();

    int rowsAffected = await db.update(
        TABLE_NOTE,
        {
          COLUMN_NOTE_TITLE: ttl,
          COLUMN_NOTE_DESC: dsc,
          COLUMN_MEAS_SHIRTL: shirtL,
          COLUMN_MEAS_SHIRTC: shirtC,
          COLUMN_MEAS_SHIRTT: shirtT,
          COLUMN_MEAS_SHIRTB: shirtB,
          COLUMN_MEAS_SHIRTG: shirtG,
          COLUMN_MEAS_SHIRTS: shirtS,
          COLUMN_MEAS_SHIRTSTMCH: shirtST,
          COLUMN_MEAS_SHIRTHIP: shirtHP,
          COLUMN_MEAS_SHIRTHB: shirtHB,
          COLUMN_MEAS_KURTAL: kurtaL,
          COLUMN_MEAS_KURTAH: kurtaH,
          COLUMN_MEAS_KURTAM: kurtaM,
          COLUMN_MEAS_PANTL: pantL,
          COLUMN_MEAS_PANTK: pantK,
          COLUMN_MEAS_PANTH: pantH,
          COLUMN_MEAS_PANTP: pantP,
          COLUMN_MEAS_PANTA: pantA,
          COLUMN_MEAS_PANTM: pantM,
          COLUMN_MEAS_PANTBP: pantBP,
          COLUMN_NOTE_ADDITIONAL: additionalnote,
          COLUMN_NOTE_DATE1: date1,
          COLUMN_NOTE_DATE2: date2,
          COLUMN_NOTE_AMOUNT1: amount1,
          COLUMN_NOTE_AMOUNT2: amount2,
          COLUMN_NOTE_RECEIPT: receipt,
          // COLUMN_NOTE_IMAGE: imageBytes,
        },
        //find that particular row for the updation...
        where: "$COLUMN_NOTE_SNO = $sno");
    return rowsAffected > 0;
  }

  // 4.Delete note
  Future<bool> deleteNote({required int sno}) async {
    var db = await getDB();
    int rowsAffected = await db.delete(
      TABLE_NOTE,
      //better readable and proffessional way.
      where: "$COLUMN_NOTE_SNO = ?",
      whereArgs: ['$sno'],
    );
    return rowsAffected > 0;
  }

  Future<Map<String, dynamic>?> getData({required int sno}) async {
    try {
      var db = await getDB();
      // Query the database to fetch the specific row
      List<Map<String, dynamic>> result = await db.query(
        TABLE_NOTE,
        where: '$COLUMN_NOTE_SNO = ?',
        whereArgs: [sno],
      );

      if (result.isNotEmpty) {
        return result.first; // Return the first matching row
      } else {
        print('No data found for sno: $sno');
        return null; // No matching row found
      }
    } catch (e) {
      print('Error in getData: $e');
      return null;
    }
  }
}

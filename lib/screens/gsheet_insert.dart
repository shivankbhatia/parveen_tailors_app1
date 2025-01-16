import 'gsheet_setup.dart';

Future<void> insertDataIntoSheet(
    List<Map<String, dynamic>> userDetailsList) async {
  // Validate if gsheetCrudUserDetails is initialized
  if (gsheetCrudUserDetails == null) {
    throw Exception(
        'Google Sheets instance is not initialized. Please check your setup.');
  }

  // Validate if userDetailsList is not empty
  if (userDetailsList.isEmpty) {
    throw Exception('No data to insert. The userDetailsList is empty.');
  }

  try {
    for (var userDetails in userDetailsList) {
      // Extract values as a list of strings
      final row = [
        userDetails['sno'] ?? '',
        userDetails['name']?.toString() ?? '',
        userDetails['contact']?.toString() ?? '',
        userDetails['shirtl']?.toString() ?? '',
        userDetails['shirtc']?.toString() ?? '',
        userDetails['shirtt']?.toString() ?? '',
        userDetails['shirtb']?.toString() ?? '',
        userDetails['shirtg']?.toString() ?? '',
        userDetails['shirts']?.toString() ?? '',
        userDetails['kurtal']?.toString() ?? '',
        userDetails['kurtah']?.toString() ?? '',
        userDetails['kurtam']?.toString() ?? '',
        userDetails['pantl']?.toString() ?? '',
        userDetails['pantk']?.toString() ?? '',
        userDetails['panth']?.toString() ?? '',
        userDetails['pantp']?.toString() ?? '',
        userDetails['panta']?.toString() ?? '',
        userDetails['pantm']?.toString() ?? '',
        userDetails['pantbp']?.toString() ?? '',
        userDetails['additionalnote']?.toString() ?? '',
      ];

      // Append row to Google Sheets
      await gsheetCrudUserDetails!.values.appendRow(row);
    }
    print('Data Stored Successfully');
  } catch (e) {
    // Handle API or other errors
    print('Failed to store data: $e');
    rethrow; // Rethrow for higher-level handling if needed
  }
}

Future<void> updateDataIntoSheet(
    List<Map<String, dynamic>> userDetailsList) async {
  // Validate if gsheetCrudUserDetails is initialized
  if (gsheetCrudUserDetails == null) {
    throw Exception(
        'Google Sheets instance is not initialized. Please check your setup.');
  }

  // Validate if userDetailsList is not empty
  if (userDetailsList.isEmpty) {
    throw Exception('No data to insert. The userDetailsList is empty.');
  }

  try {
    for (var userDetails in userDetailsList) {
      // Extract values as a list of strings
      final row = [
        //userDetails['sno']?.toString() ?? '',
        userDetails['name']?.toString() ?? '',
        userDetails['contact']?.toString() ?? '',
        userDetails['shirtl']?.toString() ?? '',
        userDetails['shirtc']?.toString() ?? '',
        userDetails['shirtt']?.toString() ?? '',
        userDetails['shirtb']?.toString() ?? '',
        userDetails['shirtg']?.toString() ?? '',
        userDetails['shirts']?.toString() ?? '',
        userDetails['kurtal']?.toString() ?? '',
        userDetails['kurtah']?.toString() ?? '',
        userDetails['kurtam']?.toString() ?? '',
        userDetails['pantl']?.toString() ?? '',
        userDetails['pantk']?.toString() ?? '',
        userDetails['panth']?.toString() ?? '',
        userDetails['pantp']?.toString() ?? '',
        userDetails['panta']?.toString() ?? '',
        userDetails['pantm']?.toString() ?? '',
        userDetails['pantbp']?.toString() ?? '',
        userDetails['additionalnote']?.toString() ?? '',
      ];

      // Append row to Google Sheets
      await gsheetCrudUserDetails!.values
          .insertRowByKey(userDetails['sno'], row);
    }
    print('Data Stored Successfully');
  } catch (e) {
    // Handle API or other errors
    print('Failed to store data: $e');
    rethrow; // Rethrow for higher-level handling if needed
  }
}

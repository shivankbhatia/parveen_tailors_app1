import 'package:flutter/material.dart';
import 'package:parveen_tailors/database/customers_db.dart';
import '../constants/colors.dart';

class DetailPage extends StatefulWidget {
  final CustomersDB DBRef; // Ensure this is non-nullable
  final int sno;

  DetailPage({super.key, required this.DBRef, required this.sno});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? data;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data asynchronously
  }

  Future<void> fetchData() async {
    try {
      var result = await widget.DBRef.getData(sno: widget.sno);
      setState(() {
        data = result;
        isLoading = false; // Data loaded
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false; // Handle error state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xfff5f7fa), Color(0xffc3cfe2)],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 1.0))),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      //Text('Customer ID: ${widget.sno}'),
                      if (data != null) ...[
                        //const SizedBox(height: 7),
                        ListTile(
                          title: Text(
                              '${data![CustomersDB.COLUMN_NOTE_TITLE] ?? 'N/A'}',
                              style: const TextStyle(fontFamily: 'Lato')),
                          titleTextStyle: const TextStyle(
                            fontSize: 36,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                          subtitle: Text(
                              'Customer ID: ${data![CustomersDB.COLUMN_NOTE_SNO]}',
                              style: const TextStyle(fontFamily: 'Lato')),
                          trailing: Text(
                            '${data![CustomersDB.COLUMN_NOTE_DESC]}',
                            style: const TextStyle(
                                fontSize: 16, fontFamily: 'Lato'),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  width:
                                      MediaQuery.of(context).size.width * 0.47,
                                  height:
                                      MediaQuery.of(context).size.height * 0.76,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        105, 161, 167, 236),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Shirt',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Lato'),
                                      ),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              34, 45, 56, 78),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'L: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Lato'),
                                            ),
                                            Expanded(
                                              // Ensure TextField has bounded width
                                              child: Text(
                                                '${data![CustomersDB.COLUMN_MEAS_SHIRTL]}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Lato'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              34, 45, 56, 78),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'C: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Lato'),
                                            ),
                                            Expanded(
                                              // Ensure TextField has bounded width
                                              child: Text(
                                                '${data![CustomersDB.COLUMN_MEAS_SHIRTC]}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Lato'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              34, 45, 56, 78),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'T: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Lato'),
                                            ),
                                            Expanded(
                                              // Ensure TextField has bounded width
                                              child: Text(
                                                '${data![CustomersDB.COLUMN_MEAS_SHIRTT]}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Lato'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              34, 45, 56, 78),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'B: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Lato'),
                                            ),
                                            Expanded(
                                              // Ensure TextField has bounded width
                                              child: Text(
                                                '${data![CustomersDB.COLUMN_MEAS_SHIRTB]}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Lato'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              34, 45, 56, 78),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'G: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Lato'),
                                            ),
                                            Expanded(
                                              // Ensure TextField has bounded width
                                              child: Text(
                                                '${data![CustomersDB.COLUMN_MEAS_SHIRTG]}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Lato'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              34, 45, 56, 78),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Side: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Lato'),
                                            ),
                                            Expanded(
                                              // Ensure TextField has bounded width
                                              child: Text(
                                                '${data![CustomersDB.COLUMN_MEAS_SHIRTS]}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Lato'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Pyjama',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Lato'),
                                      ),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              34, 45, 56, 78),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'L: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                              // Ensure TextField has bounded width
                                              child: Text(
                                                '${data![CustomersDB.COLUMN_MEAS_KURTAL]}',
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              34, 45, 56, 78),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'H: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Lato'),
                                            ),
                                            Expanded(
                                              // Ensure TextField has bounded width
                                              child: Text(
                                                '${data![CustomersDB.COLUMN_MEAS_KURTAH]}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Lato'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              34, 45, 56, 78),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'M: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Lato'),
                                            ),
                                            Expanded(
                                              // Ensure TextField has bounded width
                                              child: Text(
                                                '${data![CustomersDB.COLUMN_MEAS_KURTAM]}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Lato'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  width:
                                      MediaQuery.of(context).size.width * 0.47,
                                  height:
                                      MediaQuery.of(context).size.height * 0.76,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        105, 161, 167, 236),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Pant',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Lato'),
                                      ),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              34, 45, 56, 78),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'L: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Lato'),
                                            ),
                                            Expanded(
                                              // Ensure TextField has bounded width
                                              child: Text(
                                                '${data![CustomersDB.COLUMN_MEAS_PANTL]}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Lato'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              34, 45, 56, 78),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'K: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Lato'),
                                            ),
                                            Expanded(
                                              // Ensure TextField has bounded width
                                              child: Text(
                                                '${data![CustomersDB.COLUMN_MEAS_PANTK]}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Lato'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              34, 45, 56, 78),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'H: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Lato'),
                                            ),
                                            Expanded(
                                              // Ensure TextField has bounded width
                                              child: Text(
                                                '${data![CustomersDB.COLUMN_MEAS_PANTH]}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Lato'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              34, 45, 56, 78),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'P: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Lato'),
                                            ),
                                            Expanded(
                                              // Ensure TextField has bounded width
                                              child: Text(
                                                '${data![CustomersDB.COLUMN_MEAS_PANTP]}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Lato'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              34, 45, 56, 78),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'A: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Lato'),
                                            ),
                                            Expanded(
                                              // Ensure TextField has bounded width
                                              child: Text(
                                                '${data![CustomersDB.COLUMN_MEAS_PANTA]}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Lato'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              34, 45, 56, 78),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'M: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Lato'),
                                            ),
                                            Expanded(
                                              // Ensure TextField has bounded width
                                              child: Text(
                                                '${data![CustomersDB.COLUMN_MEAS_PANTM]}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Lato'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              34, 45, 56, 78),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'BP: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Lato'),
                                            ),
                                            Expanded(
                                              // Ensure TextField has bounded width
                                              child: Text(
                                                '${data![CustomersDB.COLUMN_MEAS_PANTBP]}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Lato'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 17),
                                      Container(
                                        height: 128,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              34, 45, 56, 78),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              // Wrap the Column in Expanded to give it bounded width
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start, // Align text and input properly
                                                children: [
                                                  const Text(
                                                    'Note: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Lato'),
                                                  ),
                                                  Text(
                                                    '${data![CustomersDB.COLUMN_NOTE_ADDITIONAL]}',
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontFamily: 'Lato'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ] else
                        const Text('No data found'),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: const Color(0xfff5f7fa),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 50,
          width: 105,
          child: ClipRRect(
            child: Image.asset('assets/images/PT2copy.png'),
          ),
        ),
      ],
    ),
  );
}

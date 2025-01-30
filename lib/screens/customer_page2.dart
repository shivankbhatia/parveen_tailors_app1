import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this to control the status bar color
import 'package:parveen_tailors/database/customers_db.dart';
import 'package:parveen_tailors/screens/edit_customer_page2.dart';

class DetailPage2 extends StatefulWidget {
  final CustomersDB DBRef; // Ensure this is non-nullable
  final int sno;

  DetailPage2({super.key, required this.DBRef, required this.sno});

  @override
  State<DetailPage2> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage2>
    with TickerProviderStateMixin {
  Map<String, dynamic>? data;
  bool isLoading = true;
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data asynchronously
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnimation = Tween<double>(begin: -200.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Initialize fade animation controller
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
  }

  Future<void> fetchData() async {
    try {
      var result = await widget.DBRef.getData(sno: widget.sno);
      setState(() {
        data = result;
        isLoading = false; // Data loaded
      });

      // Start the sliding animation
      _controller.forward();

      // Change the status bar color based on the container color
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Color.fromARGB(255, 174, 212, 247), // Container color
        ),
      );

      // Start the fade-in animation after the slide-in animation completes
      Future.delayed(const Duration(milliseconds: 300), () {
        _fadeController.forward();
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false; // Handle error state
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: PageView(children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      if (data != null) ...[
                        AnimatedBuilder(
                          animation: _slideAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: child,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                  255, 174, 212, 247), // Container color
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(60),
                                bottomRight: Radius.circular(60),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.5), // Shadow color
                                  spreadRadius: 3, // Spread radius
                                  blurRadius: 5, // Blur radius
                                  offset: const Offset(
                                      0, 3), // Offset in X and Y directions
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 30),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: ListTile(
                                title: Text(
                                  '${data![CustomersDB.COLUMN_NOTE_TITLE] ?? 'N/A'}',
                                  style: const TextStyle(fontFamily: 'Lato'),
                                ),
                                titleTextStyle: const TextStyle(
                                  fontSize: 36,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                ),
                                subtitle: Text(
                                  '${data![CustomersDB.COLUMN_NOTE_DESC]}',
                                  style: const TextStyle(
                                      fontFamily: 'Lato', fontSize: 15),
                                ),
                                // trailing: IconButton(
                                //     onPressed: () {
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) => EditPage2(
                                //                   DBRef: widget.DBRef,
                                //                   sno: widget.sno,
                                //                   name:
                                //                       '${data![CustomersDB.COLUMN_NOTE_TITLE]}',
                                //                   contact:
                                //                       '${data![CustomersDB.COLUMN_NOTE_DESC]}',
                                //                   isUpdate: true)));
                                //     },
                                //     icon: const Icon(Icons.edit_note_rounded))
                                trailing: Text(
                                  '${data![CustomersDB.COLUMN_NOTE_RECEIPT]}',
                                  style: const TextStyle(
                                      fontSize: 12, fontFamily: 'Lato'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            width: 340,
                            height: 335,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(125, 174, 212, 247),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      height: 50,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Length:  ',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 18),
                                          ),
                                          Text(
                                            '${data![CustomersDB.COLUMN_MEAS_SHIRTL]}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      height: 50,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Chest:  ',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 18),
                                          ),
                                          Text(
                                            '${data![CustomersDB.COLUMN_MEAS_SHIRTC]}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Stomach:  ',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16),
                                          ),
                                          Text(
                                            '${data![CustomersDB.COLUMN_MEAS_SHIRTSTMCH]}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Container(
                                      height: 50,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Hip:  ',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16),
                                          ),
                                          Text(
                                            '${data![CustomersDB.COLUMN_MEAS_SHIRTHIP]}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Teera:  ',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16),
                                          ),
                                          Text(
                                            '${data![CustomersDB.COLUMN_MEAS_SHIRTT]}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    SizedBox(
                                      height: 50,
                                      child: ClipRRect(
                                        child: Image.asset(
                                          'assets/images/shirt.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      height: 50,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Arm:  ',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16),
                                          ),
                                          Text(
                                            '${data![CustomersDB.COLUMN_MEAS_SHIRTB]}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Neck:  ',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 18),
                                          ),
                                          Text(
                                            '${data![CustomersDB.COLUMN_MEAS_SHIRTG]}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Container(
                                      height: 50,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Side:  ',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 18),
                                          ),
                                          Text(
                                            '${data![CustomersDB.COLUMN_MEAS_SHIRTS]}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'HB:  ',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16),
                                          ),
                                          Text(
                                            '${data![CustomersDB.COLUMN_MEAS_SHIRTHB]}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Container(
                                      height: 50,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Palla:  ',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 16),
                                          ),
                                          Text(
                                            '${data![CustomersDB.COLUMN_MEAS_KURTAL]}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            width: 340,
                            height: 275,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(125, 174, 212, 247),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      height: 50,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Length:  ',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 18),
                                          ),
                                          Text(
                                            '${data![CustomersDB.COLUMN_MEAS_PANTL]}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      height: 50,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Waist:  ',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 18),
                                          ),
                                          Text(
                                            '${data![CustomersDB.COLUMN_MEAS_PANTK]}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Hip:  ',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 18),
                                          ),
                                          Text(
                                            '${data![CustomersDB.COLUMN_MEAS_PANTH]}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      height: 60,
                                      child: ClipRRect(
                                        child: Image.asset(
                                          'assets/images/pant.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      height: 50,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'P:  ',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 18),
                                          ),
                                          Text(
                                            '${data![CustomersDB.COLUMN_MEAS_PANTP]}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Aasan:  ',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 18),
                                          ),
                                          Text(
                                            '${data![CustomersDB.COLUMN_MEAS_PANTA]}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Container(
                                      height: 50,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Bottom:  ',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 18),
                                          ),
                                          Text(
                                            '${data![CustomersDB.COLUMN_MEAS_PANTM]}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Back Pocket:  ',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 18),
                                          ),
                                          Text(
                                            '${data![CustomersDB.COLUMN_MEAS_PANTBP]}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            width: 340,
                            //height: 55,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(125, 174, 212, 247),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Note:  ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(
                                    '${data![CustomersDB.COLUMN_NOTE_ADDITIONAL]}',
                                    style: const TextStyle(
                                        fontSize: 14, fontFamily: 'Lato'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            width: 340,
                            height: 155,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(125, 174, 212, 247),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${data![CustomersDB.COLUMN_MEAS_KURTAH]}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      height: 50,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Order:',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 14),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${data![CustomersDB.COLUMN_NOTE_DATE1]}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Lato',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      height: 50,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Delivery:',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 12),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${data![CustomersDB.COLUMN_NOTE_DATE2]}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Lato',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      height: 50,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Amount:',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 15),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${data![CustomersDB.COLUMN_NOTE_AMOUNT1]}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Lato',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      height: 50,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(
                                            255, 146, 194, 239),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Balance:',
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 15),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${data![CustomersDB.COLUMN_NOTE_AMOUNT2]}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Lato',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else
                        const Text('No data found'),
                    ],
                  ),
                ),
                Container(
                  height: 320,
                  width: 420,
                  child: Image.memory(data![CustomersDB.COLUMN_NOTE_IMAGE]),
                )
              ]),
            ),
    );
  }
}

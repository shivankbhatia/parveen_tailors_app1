import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this to control the status bar color
import 'package:image_picker/image_picker.dart';
import 'package:parveen_tailors/database/customers_db.dart';
import '../constants/colors.dart';
import 'gsheet_setup.dart';
import 'gsheet_insert.dart';

bool saved = false;
bool isLoading = false;

//controllers...
//shirt
TextEditingController shirtL = TextEditingController();
TextEditingController shirtC = TextEditingController();
TextEditingController shirtT = TextEditingController();
TextEditingController shirtB = TextEditingController();
TextEditingController shirtG = TextEditingController();
TextEditingController shirtS = TextEditingController();
TextEditingController shirtST = TextEditingController();
TextEditingController shirtHP = TextEditingController();
TextEditingController shirtHB = TextEditingController();

//kurta
TextEditingController kurtaL = TextEditingController();
TextEditingController kurtaH = TextEditingController();
TextEditingController kurtaM = TextEditingController();

//pant
TextEditingController pantL = TextEditingController();
TextEditingController pantK = TextEditingController();
TextEditingController pantH = TextEditingController();
TextEditingController pantP = TextEditingController();
TextEditingController pantA = TextEditingController();
TextEditingController pantM = TextEditingController();
TextEditingController pantBP = TextEditingController();
TextEditingController additional = TextEditingController();

TextEditingController date1 = TextEditingController();
TextEditingController date2 = TextEditingController();
TextEditingController amount1 = TextEditingController();
TextEditingController amount2 = TextEditingController();

class EditPage2 extends StatefulWidget {
  final CustomersDB DBRef; // Ensure this is non-nullable
  final int sno;
  final String name;
  final String contact;
  final String receipt;
  bool isUpdate;

  EditPage2(
      {super.key,
      required this.DBRef,
      required this.sno,
      required this.name,
      required this.contact,
      required this.isUpdate,
      required this.receipt});

  @override
  State<EditPage2> createState() => _DetailPageState();
}

class _DetailPageState extends State<EditPage2> with TickerProviderStateMixin {
  Map<String, dynamic>? data;
  bool isLoading = true;
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late CustomersDB dbRef;
  List<Map<String, dynamic>> allNotes = [];
  bool isSaved = false;
  //File? selectedImage;

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
    if (widget.isUpdate) {
      initialiseFields();
    } else {
      shirtL.clear();
      shirtC.clear();
      shirtT.clear();
      shirtB.clear();
      shirtG.clear();
      shirtS.clear();
      kurtaL.clear();
      kurtaH.clear();
      kurtaM.clear();
      pantL.clear();
      pantK.clear();
      pantH.clear();
      pantP.clear();
      pantA.clear();
      pantM.clear();
      pantBP.clear();
      additional.clear();
    }
    // Initialize fade animation controller
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
  }

  Future<void> initialiseFields() async {
    try {
      print('Initializing Google Sheets...');
      await GSheetInit(); // Ensure GSheetInit is awaited
      print('Google Sheets initialization complete.');

      // Fetch customer data
      Map<String, dynamic>? customerData =
          await widget.DBRef.getData(sno: widget.sno);
      print('Fetched Data of Customer ID : ${widget.sno}');
      print('The Data is : $customerData');

      if (customerData != null) {
        setState(() {
          // Populate fields
          shirtL.text = customerData['shirtLen']?.toString() ?? '';
          shirtC.text = customerData['shirtChe']?.toString() ?? '';
          shirtT.text = customerData['shirtTee']?.toString() ?? '';
          shirtB.text = customerData['shirtBaa']?.toString() ?? '';
          shirtG.text = customerData['shirtGal']?.toString() ?? '';
          shirtS.text = customerData['shirtSle']?.toString() ?? '';
          shirtST.text = customerData['shirtStmch']?.toString() ?? '';
          shirtHP.text = customerData['shirtHip']?.toString() ?? '';
          shirtHB.text = customerData['shirtHb']?.toString() ?? '';
          kurtaL.text = customerData['kurtaLen']?.toString() ?? '';
          kurtaH.text = customerData['kurtaHus']?.toString() ?? '';
          kurtaM.text = customerData['kurtaMam']?.toString() ?? '';
          pantL.text = customerData['pantLen']?.toString() ?? '';
          pantK.text = customerData['pantKya']?.toString() ?? '';
          pantH.text = customerData['pantHai']?.toString() ?? '';
          pantP.text = customerData['pantPai']?.toString() ?? '';
          pantA.text = customerData['pantAia']?.toString() ?? '';
          pantM.text = customerData['pantMai']?.toString() ?? '';
          pantBP.text = customerData['pantBPIS']?.toString() ?? '';
          additional.text = customerData['additionalnote']?.toString() ?? '';
        });
      }
    } catch (e) {
      print('Error initializing fields: $e');
    }
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
                  child: Column(children: [
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
                              color:
                                  Colors.grey.withOpacity(0.5), // Shadow color
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
                                widget.name,
                                style: const TextStyle(fontFamily: 'Lato'),
                              ),
                              titleTextStyle: const TextStyle(
                                fontSize: 36,
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                              subtitle: Text(
                                widget.contact,
                                style: const TextStyle(
                                    fontFamily: 'Lato', fontSize: 15),
                              ),
                              trailing: IconButton.filledTonal(
                                  onPressed: () async {
                                    var msno = widget.sno;
                                    var mtitle = widget.name;
                                    var mreceipt = widget.receipt;
                                    var mdesc = widget.contact;
                                    var mshirtL = shirtL.text;
                                    var mshirtC = shirtC.text;
                                    var mshirtT = shirtT.text;
                                    var mshirtB = shirtB.text;
                                    var mshirtG = shirtG.text;
                                    var mshirtS = shirtS.text;
                                    var mshirtST = shirtST.text;
                                    var mshirtHP = shirtHP.text;
                                    var mshirtHB = shirtHB.text;

                                    var mkurtaL = kurtaL.text;
                                    var mkurtaH = kurtaH.text;
                                    var mkurtaM = kurtaM.text;

                                    var mpantL = pantL.text;
                                    var mpantK = pantK.text;
                                    var mpantH = pantH.text;
                                    var mpantP = pantP.text;
                                    var mpantA = pantA.text;
                                    var mpantM = pantM.text;
                                    var mpantBP = pantBP.text;
                                    var mnote = additional.text;

                                    var mdate1 = date1.text;
                                    var mdate2 = date2.text;
                                    var mamount1 = amount1.text;
                                    var mamount2 = amount2.text;
                                    //var image;
                                    // if (selectedImage != null) {
                                    //   image =
                                    //       await selectedImage!.readAsBytes();
                                    // } else {
                                    //   image = null;
                                    // }

                                    if (mtitle.isNotEmpty && mdesc.isNotEmpty) {
                                      if (widget.DBRef != null) {
                                        bool check = widget.isUpdate
                                            ? await widget.DBRef.updateNotes(
                                                ttl: mtitle,
                                                dsc: mdesc,
                                                sno: msno,
                                                shirtL: mshirtL,
                                                shirtC: mshirtC,
                                                shirtT: mshirtT,
                                                shirtB: mshirtB,
                                                shirtG: mshirtG,
                                                shirtS: mshirtS,
                                                shirtST: mshirtST,
                                                shirtHP: mshirtHP,
                                                shirtHB: mshirtHB,
                                                kurtaL: mkurtaL,
                                                kurtaH: mkurtaH,
                                                kurtaM: mkurtaM,
                                                pantL: mpantL,
                                                pantK: mpantK,
                                                pantH: mpantH,
                                                pantP: mpantP,
                                                pantA: mpantA,
                                                pantM: mpantM,
                                                pantBP: mpantBP,
                                                additionalnote: mnote,
                                                date1: mdate1,
                                                date2: mdate2,
                                                amount1: mamount1,
                                                amount2: mamount2,
                                                receipt: mreceipt,
                                                //imageBytes: image,
                                              )
                                            : await widget.DBRef.addNote(
                                                ttl: mtitle,
                                                dsc: mdesc,
                                                shirtL: mshirtL,
                                                shirtC: mshirtC,
                                                shirtT: mshirtT,
                                                shirtB: mshirtB,
                                                shirtG: mshirtG,
                                                shirtS: mshirtS,
                                                shirtST: mshirtST,
                                                shirtHP: mshirtHP,
                                                shirtHB: mshirtHB,
                                                kurtaL: mkurtaL,
                                                kurtaH: mkurtaH,
                                                kurtaM: mkurtaM,
                                                pantL: mpantL,
                                                pantK: mpantK,
                                                pantH: mpantH,
                                                pantP: mpantP,
                                                pantA: mpantA,
                                                pantM: mpantM,
                                                pantBP: mpantBP,
                                                additionalnote: mnote,
                                                date1: mdate1,
                                                date2: mdate2,
                                                amount1: mamount1,
                                                amount2: mamount2,
                                                receipt: mreceipt,
                                                //imageBytes: image,
                                              );
                                        if (check) {
                                          isSaved = true;
                                          //Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 250),
                                              content: Text(
                                                'Data saved successfully',
                                                style: TextStyle(
                                                    fontFamily: 'Lato'),
                                              ),
                                            ),
                                          );
                                          setState(() {});
                                        }
                                      } else {
                                        // Handle the case where DBRef is null
                                        print('DBRef is null!');
                                      }
                                    } else {
                                      //close bottom sheet...
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          duration: Durations.extralong1,
                                          content: Text(
                                              'Please fill complete fields',
                                              style: TextStyle(
                                                  fontFamily: 'Lato')),
                                        ),
                                      );
                                    }

                                    List<Map<String, dynamic>> userDetailsList =
                                        [
                                      {
                                        'sno': msno,
                                        'name': mtitle,
                                        'contact': mdesc,
                                        'shirtl': mshirtL,
                                        'shirtc': mshirtC,
                                        'shirtt': mshirtT,
                                        'shirtb': mshirtB,
                                        'shirtg': mshirtG,
                                        'shirts': mshirtS,
                                        'shirtst': mshirtST,
                                        'shirthp': mshirtHP,
                                        'shirthb': mshirtHB,
                                        'kurtal': mkurtaL,
                                        'kurtah': mkurtaH,
                                        'kurtam': mamount2,
                                        'pantl': mpantL,
                                        'pantk': mpantK,
                                        'panth': mpantH,
                                        'pantp': mpantP,
                                        'panta': mpantA,
                                        'pantm': mpantM,
                                        'pantbp': mpantBP,
                                      }
                                    ];

                                    // Attempt to insert data
                                    try {
                                      if (!widget.isUpdate) {
                                        await insertDataIntoSheet(
                                            userDetailsList);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 250),
                                              content: Text(
                                                  'Cloud: Data Saved.',
                                                  style: TextStyle(
                                                      fontFamily: 'Lato'))),
                                        );
                                      } else {
                                        await updateDataIntoSheet(
                                            userDetailsList);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 250),
                                              content: Text(
                                                  'Cloud: Data Updated.',
                                                  style: TextStyle(
                                                      fontFamily: 'Lato'))),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to save data: $e')),
                                      );
                                    }

                                    // shirtL.clear();
                                    // shirtC.clear();
                                    // shirtT.clear();
                                    // shirtB.clear();
                                    // shirtG.clear();
                                    // shirtS.clear();
                                    // kurtaL.clear();
                                    // kurtaH.clear();
                                    // kurtaM.clear();
                                    // pantL.clear();
                                    // pantK.clear();
                                    // pantH.clear();
                                    // pantP.clear();
                                    // pantA.clear();
                                    // pantM.clear();
                                    // pantBP.clear();
                                    // additional.clear();
                                    widget.isUpdate = !widget.isUpdate;
                                  },
                                  icon: !isSaved
                                      ? const Icon(Icons.done)
                                      : const Icon(Icons.done_all_rounded))
                              // Text(
                              //   '${data![CustomersDB.COLUMN_NOTE_SNO]}',
                              //   style: const TextStyle(
                              //       fontSize: 12, fontFamily: 'Lato'),
                              // ),
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
                          borderRadius: BorderRadius.all(Radius.circular(30)),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Length:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 15),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'L',
                                            contentPadding: EdgeInsets.all(9),
                                            hintStyle: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Lato'),
                                          ),
                                          controller: shirtL,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Chest:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 15),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'C',
                                            contentPadding: EdgeInsets.all(9),
                                            hintStyle: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Lato'),
                                          ),
                                          controller: shirtC,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Stomach:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 14),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'ST',
                                              contentPadding: EdgeInsets.all(9),
                                              hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Lato')),
                                          controller: shirtST,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Hip:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 16),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'H',
                                              contentPadding: EdgeInsets.all(9),
                                              hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Lato')),
                                          controller: shirtHP,
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
                                  padding: const EdgeInsets.all(8),
                                  height: 50,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromARGB(
                                        255, 146, 194, 239),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Teera:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 14),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'T',
                                            contentPadding: EdgeInsets.all(9),
                                            hintStyle: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Lato'),
                                          ),
                                          controller: shirtT,
                                        ),
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
                                  padding: const EdgeInsets.all(8),
                                  height: 50,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromARGB(
                                        255, 146, 194, 239),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Arm:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 13),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'B',
                                              contentPadding: EdgeInsets.all(9),
                                              hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Lato')),
                                          controller: shirtB,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Neck:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 15),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'G',
                                              contentPadding: EdgeInsets.all(9),
                                              hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Lato')),
                                          controller: shirtG,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Side:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 16),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'S',
                                              contentPadding: EdgeInsets.all(9),
                                              hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Lato')),
                                          controller: shirtS,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'HB:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 15),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Half Back',
                                              contentPadding: EdgeInsets.all(9),
                                              hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Lato')),
                                          controller: shirtHB,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Palla:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 15),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'P',
                                              contentPadding: EdgeInsets.all(9),
                                              hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Lato')),
                                          controller: kurtaL,
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
                    const SizedBox(height: 10),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: 340,
                        height: 275,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(125, 174, 212, 247),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Length:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 17),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'L',
                                              contentPadding: EdgeInsets.all(8),
                                              hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Lato')),
                                          controller: pantL,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Waist:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 16),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'K',
                                              contentPadding:
                                                  EdgeInsets.all(8.5),
                                              hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Lato')),
                                          controller: pantK,
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
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromARGB(
                                        255, 146, 194, 239),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Hip:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 16),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'H',
                                              contentPadding: EdgeInsets.all(8),
                                              hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Lato')),
                                          controller: pantH,
                                        ),
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
                                  padding: const EdgeInsets.all(10),
                                  height: 50,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromARGB(
                                        255, 146, 194, 239),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'P:  ',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 18),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'P',
                                              contentPadding:
                                                  EdgeInsets.all(8.5),
                                              hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Lato')),
                                          controller: pantP,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Aasan:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 18),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'A',
                                              contentPadding:
                                                  EdgeInsets.all(8.5),
                                              hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Lato')),
                                          controller: pantA,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Bottom:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 15),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'M',
                                              contentPadding: EdgeInsets.all(8),
                                              hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Lato')),
                                          controller: pantM,
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
                                  height: 45,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromARGB(
                                        255, 146, 194, 239),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Back Pocket:  ',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 18),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'B',
                                              contentPadding:
                                                  EdgeInsets.all(7.5),
                                              hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Lato')),
                                          controller: pantBP,
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
                    const SizedBox(height: 10),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        width: 340,
                        //height: 55,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(125, 174, 212, 247),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
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
                              child: TextField(
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 15,
                                ),
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Additional Note',
                                    contentPadding: EdgeInsets.all(9),
                                    hintStyle: TextStyle(
                                        fontSize: 15, fontFamily: 'Lato')),
                                controller: additional,
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
                          borderRadius: BorderRadius.all(Radius.circular(30)),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Order:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 14),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Date',
                                              contentPadding: EdgeInsets.all(8),
                                              hintStyle: TextStyle(
                                                  fontSize: 14.5,
                                                  fontFamily: 'Lato')),
                                          controller: date1,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Delivery:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 12),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Date',
                                              contentPadding:
                                                  EdgeInsets.all(7.5),
                                              hintStyle: TextStyle(
                                                  fontSize: 14.5,
                                                  fontFamily: 'Lato')),
                                          controller: date2,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Amount:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 15),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '₹',
                                              contentPadding:
                                                  EdgeInsets.all(8.5),
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Lato')),
                                          controller: amount1,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Balance:',
                                        style: TextStyle(
                                            fontFamily: 'Lato', fontSize: 15),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          style: const TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '₹',
                                              contentPadding: EdgeInsets.all(8),
                                              hintStyle: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Lato')),
                                          controller: amount2,
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
                  ]),
                ),
                // Column(
                //   mainAxisAlignment:
                //       MainAxisAlignment.center, // Center content vertically
                //   crossAxisAlignment:
                //       CrossAxisAlignment.center, // Center content horizontally
                //   children: [
                //     if (selectedImage == null)
                //       Center(
                //         child: InkWell(
                //           child: Container(
                //               decoration: BoxDecoration(
                //                 color: Color.fromARGB(122, 183, 219, 252),
                //                 borderRadius: BorderRadius.circular(20),
                //               ),
                //               height: 50,
                //               width: 220,
                //               child: Row(
                //                 children: [
                //                   Image.asset(
                //                     'assets/images/gallery.png',
                //                   ),
                //                   const Padding(
                //                     padding: const EdgeInsets.all(8.0),
                //                     child: Text('Upload from Gallery',
                //                         style: TextStyle(fontFamily: 'Lato')),
                //                   )
                //                 ],
                //               )),
                //           onTap: () {
                //             _pickImageFromGallery();
                //           },
                //         ),
                //       ),
                //     const SizedBox(
                //       height: 20,
                //     ),
                //     if (selectedImage == null)
                //       Center(
                //         child: InkWell(
                //           child: Container(
                //               decoration: BoxDecoration(
                //                 color: Color.fromARGB(122, 183, 219, 252),
                //                 borderRadius: BorderRadius.circular(20),
                //               ),
                //               height: 50,
                //               width: 220,
                //               child: Row(
                //                 children: [
                //                   Image.asset(
                //                     'assets/images/camera2.png',
                //                   ),
                //                   const Padding(
                //                     padding: const EdgeInsets.all(8.0),
                //                     child: Text('Click from Camera',
                //                         style: TextStyle(fontFamily: 'Lato')),
                //                   )
                //                 ],
                //               )),
                //           onTap: () {
                //             _pickImageFromCamera();
                //           },
                //         ),
                //       ),
                //     const SizedBox(
                //       height: 20,
                //     ),
                //     if (selectedImage != null)
                //       SizedBox(
                //         height: 470,
                //         width: double.infinity,
                //         child: selectedImage != null
                //             ? Image.file(selectedImage!)
                //             : null,
                //       ),
                //     if (selectedImage != null)
                //       IconButton(
                //         icon: const Icon(
                //           Icons.delete,
                //           color: Colors.red,
                //         ),
                //         onPressed: () async {
                //           bool check = await alert(context: context);
                //           if (check) {
                //             selectedImage = null;
                //           }
                //           selectedImage = null;
                //           setState(() {});
                //         },
                //       )
                //   ],
                //)
              ]),
            ),
    );
  }

  // Future _pickImageFromGallery() async {
  //   final returnedImage =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (returnedImage == null) return;
  //   setState(() {
  //     selectedImage = File(returnedImage!.path);
  //   });
  // }

  // Future _pickImageFromCamera() async {
  //   final returnedImage =
  //       await ImagePicker().pickImage(source: ImageSource.camera);
  //   if (returnedImage == null) return;
  //   setState(() {
  //     selectedImage = File(returnedImage!.path);
  //   });
  // }

  Future<bool> alert({required BuildContext context}) async {
    bool check = false;
    await showCupertinoDialog(
      context: context,
      builder: (BuildContext context2) => CupertinoAlertDialog(
        title: const Text(
          'Are you sure you want to delete the image?',
          style: const TextStyle(fontFamily: 'Lato'),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text(
              'No',
              style: const TextStyle(fontFamily: 'Lato'),
            ),
            onPressed: () {
              check = false; // User chose not to delete
              Navigator.pop(context2);
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              check = true; // User confirmed deletion
              Navigator.pop(context2);
            },
            child: const Text(
              'Yes',
              style: const TextStyle(fontFamily: 'Lato'),
            ),
          ),
        ],
      ),
    );
    return check;
  }
}

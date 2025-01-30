// import 'package:flutter/material.dart';
// import 'package:parveen_tailors/database/customers_db.dart';
// import '../constants/colors.dart';
// import 'gsheet_setup.dart';
// import 'gsheet_insert.dart';

// bool saved = false;
// bool isLoading = false;
// //controllers...
// //shirt
// TextEditingController shirtL = TextEditingController();
// TextEditingController shirtC = TextEditingController();
// TextEditingController shirtT = TextEditingController();
// TextEditingController shirtB = TextEditingController();
// TextEditingController shirtG = TextEditingController();
// TextEditingController shirtS = TextEditingController();

// //kurta
// TextEditingController kurtaL = TextEditingController();
// TextEditingController kurtaH = TextEditingController();
// TextEditingController kurtaM = TextEditingController();

// //pant
// TextEditingController pantL = TextEditingController();
// TextEditingController pantK = TextEditingController();
// TextEditingController pantH = TextEditingController();
// TextEditingController pantP = TextEditingController();
// TextEditingController pantA = TextEditingController();
// TextEditingController pantM = TextEditingController();
// TextEditingController pantBP = TextEditingController();
// TextEditingController additional = TextEditingController();

// class CustomerPage extends StatefulWidget {
//   final String name;
//   final String contact;
//   bool isUpdate;
//   final int sno;
//   final CustomersDB DBRef;

//   CustomerPage(
//       {super.key,
//       required this.DBRef,
//       required this.name,
//       required this.contact,
//       required this.isUpdate,
//       required this.sno});

//   @override
//   State<CustomerPage> createState() => _CustomerPageState();
// }

// class _CustomerPageState extends State<CustomerPage> {
//   // CustomersDB? DBRef;
//   // List<Map<String, dynamic>> allNotes = [];

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   if(widget.isUpdate)
//   //   {
//   //     shirtL = DBRef.COLUMN_MEAS_SHIRTL;
//   //   }
//   // }

//   late CustomersDB dbRef;
//   List<Map<String, dynamic>> allNotes = [];

//   @override
//   void initState() {
//     super.initState();
//     if (widget.isUpdate) {
//       // Perform any necessary initialization if it's an update
//       initialiseFields();
//     }
//   }

//   Future<void> initialiseFields() async {
//     try {
//       print('Initializing Google Sheets...');
//       await GSheetInit(); // Ensure GSheetInit is awaited
//       print('Google Sheets initialization complete.');

//       // Fetch customer data
//       Map<String, dynamic>? customerData =
//           await widget.DBRef.getData(sno: widget.sno);
//       print('Fetched Data of Customer ID : ${widget.sno}');
//       print('The Data is : $customerData');

//       if (customerData != null) {
//         setState(() {
//           // Populate fields
//           shirtL.text = customerData['shirtLen']?.toString() ?? '';
//           shirtC.text = customerData['shirtChe']?.toString() ?? '';
//           shirtT.text = customerData['shirtTee']?.toString() ?? '';
//           shirtB.text = customerData['shirtBaa']?.toString() ?? '';
//           shirtG.text = customerData['shirtGal']?.toString() ?? '';
//           shirtS.text = customerData['shirtSle']?.toString() ?? '';
//           kurtaL.text = customerData['kurtaLen']?.toString() ?? '';
//           kurtaH.text = customerData['kurtaHus']?.toString() ?? '';
//           kurtaM.text = customerData['kurtaMam']?.toString() ?? '';
//           pantL.text = customerData['pantLen']?.toString() ?? '';
//           pantK.text = customerData['pantKya']?.toString() ?? '';
//           pantH.text = customerData['pantHai']?.toString() ?? '';
//           pantP.text = customerData['pantPai']?.toString() ?? '';
//           pantA.text = customerData['pantAia']?.toString() ?? '';
//           pantM.text = customerData['pantMai']?.toString() ?? '';
//           pantBP.text = customerData['pantBPIS']?.toString() ?? '';
//           additional.text = customerData['additionalnote']?.toString() ?? '';
//         });
//       }
//     } catch (e) {
//       print('Error initializing fields: $e');
//     }
//   }

//   // Future<void> fetchNotes() async {
//   //   var result = await dbRef.getAllNotes();
//   //   setState(() {
//   //     allNotes = result;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(context),
//       body: Container(
//         decoration: const BoxDecoration(
//             gradient: LinearGradient(
//                 colors: [Color(0xfff5f7fa), Color(0xffc3cfe2)],
//                 begin: FractionalOffset(0.0, 0.0),
//                 end: FractionalOffset(1.0, 1.0))),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               //const SizedBox(height: 5),

//               ListTile(
//                 title: Text(widget.name),
//                 titleTextStyle: const TextStyle(
//                   fontSize: 36,
//                   color: Colors.black,
//                   fontWeight: FontWeight.w800,
//                   fontFamily: 'Lato',
//                 ),
//                 subtitle: Text(
//                   widget.contact,
//                   style: const TextStyle(fontFamily: 'Lato'),
//                 ),
//                 trailing: OutlinedButton(
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: tdBlack,
//                     backgroundColor: tdBGColor,
//                     minimumSize: const Size(50, 40),
//                     shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                       side: BorderSide(
//                         width: 4,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   onPressed: () async {
//                     //save in database
//                     var msno = widget.sno;
//                     var mtitle = widget.name;
//                     var mdesc = widget.contact;
//                     var mshirtL = shirtL.text;
//                     var mshirtC = shirtC.text;
//                     var mshirtT = shirtT.text;
//                     var mshirtB = shirtB.text;
//                     var mshirtG = shirtG.text;
//                     var mshirtS = shirtS.text;

//                     var mkurtaL = kurtaL.text;
//                     var mkurtaH = kurtaH.text;
//                     var mkurtaM = kurtaM.text;

//                     var mpantL = pantL.text;
//                     var mpantK = pantK.text;
//                     var mpantH = pantH.text;
//                     var mpantP = pantP.text;
//                     var mpantA = pantA.text;
//                     var mpantM = pantM.text;
//                     var mpantBP = pantBP.text;
//                     var mnote = additional.text;

//                     if (mtitle.isNotEmpty && mdesc.isNotEmpty) {
//                       if (widget.DBRef != null) {
//                         bool check = widget.isUpdate
//                             ? await widget.DBRef.updateNotes(
//                                 ttl: mtitle,
//                                 dsc: mdesc,
//                                 sno: msno,
//                                 shirtL: mshirtL,
//                                 shirtC: mshirtC,
//                                 shirtT: mshirtT,
//                                 shirtB: mshirtB,
//                                 shirtG: mshirtG,
//                                 shirtS: mshirtS,
//                                 kurtaL: mkurtaL,
//                                 kurtaH: mkurtaH,
//                                 kurtaM: mkurtaM,
//                                 pantL: mpantL,
//                                 pantK: mpantK,
//                                 pantH: mpantH,
//                                 pantP: mpantP,
//                                 pantA: mpantA,
//                                 pantM: mpantM,
//                                 pantBP: mpantBP,
//                                 additionalnote: mnote,
//                               )
//                             : await widget.DBRef.addNote(
//                                 ttl: mtitle,
//                                 dsc: mdesc,
//                                 shirtL: mshirtL,
//                                 shirtC: mshirtC,
//                                 shirtT: mshirtT,
//                                 shirtB: mshirtB,
//                                 shirtG: mshirtG,
//                                 shirtS: mshirtS,
//                                 kurtaL: mkurtaL,
//                                 kurtaH: mkurtaH,
//                                 kurtaM: mkurtaM,
//                                 pantL: mpantL,
//                                 pantK: mpantK,
//                                 pantH: mpantH,
//                                 pantP: mpantP,
//                                 pantA: mpantA,
//                                 pantM: mpantM,
//                                 pantBP: mpantBP,
//                                 additionalnote: mnote,
//                               );
//                         if (check) {
//                           //Navigator.pop(context);
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text('Data saved successfully',
//                                     style: TextStyle(fontFamily: 'Lato'))),
//                           );
//                         }
//                       } else {
//                         // Handle the case where DBRef is null
//                         print('DBRef is null!');
//                       }
//                     } else {
//                       //close bottom sheet...
//                       Navigator.pop(context);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           duration: Durations.extralong1,
//                           content: Text('Please fill complete fields',
//                               style: TextStyle(fontFamily: 'Lato')),
//                         ),
//                       );
//                     }

//                     // List<Map<String, dynamic>> userDetailsList = [
//                     //   {
//                     //     'sno': msno,
//                     //     'name': mtitle,
//                     //     'contact': mdesc,
//                     //     'shirtl': mshirtL,
//                     //     'shirtc': mshirtC,
//                     //     'shirtt': mshirtT,
//                     //     'shirtb': mshirtB,
//                     //     'shirtg': mshirtG,
//                     //     'shirts': mshirtS,
//                     //     'kurtal': mkurtaL,
//                     //     'kurtah': mkurtaH,
//                     //     'kurtam': mkurtaM,
//                     //     'pantl': mpantL,
//                     //     'pantk': mpantK,
//                     //     'panth': mpantH,
//                     //     'pantp': mpantP,
//                     //     'panta': mpantA,
//                     //     'pantm': mpantM,
//                     //     'pantbp': mpantBP,
//                     //   }
//                     // ];

//                     // // Attempt to insert data
//                     // try {
//                     //   if (!widget.isUpdate) {
//                     //     await insertDataIntoSheet(userDetailsList);
//                     //     ScaffoldMessenger.of(context).showSnackBar(
//                     //       const SnackBar(
//                     //           content: Text('Data saved successfully',
//                     //               style: TextStyle(fontFamily: 'Lato'))),
//                     //     );
//                     //   } else {
//                     //     await updateDataIntoSheet(userDetailsList);
//                     //     ScaffoldMessenger.of(context).showSnackBar(
//                     //       const SnackBar(
//                     //           content: Text('Data saved successfully',
//                     //               style: TextStyle(fontFamily: 'Lato'))),
//                     //     );
//                     //   }
//                     // } catch (e) {
//                     //   ScaffoldMessenger.of(context).showSnackBar(
//                     //     SnackBar(content: Text('Failed to save data: $e')),
//                     //   );
//                     // }

//                     shirtL.clear();
//                     shirtC.clear();
//                     shirtT.clear();
//                     shirtB.clear();
//                     shirtG.clear();
//                     shirtS.clear();
//                     kurtaL.clear();
//                     kurtaH.clear();
//                     kurtaM.clear();
//                     pantL.clear();
//                     pantK.clear();
//                     pantH.clear();
//                     pantP.clear();
//                     pantA.clear();
//                     pantM.clear();
//                     pantBP.clear();
//                     additional.clear();
//                     widget.isUpdate = false;
//                   },
//                   child: const Text('Save',
//                       style: TextStyle(
//                           fontFamily: 'Lato', fontWeight: FontWeight.w700)),
//                 ),
//               ),
//               //const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Column(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(7),
//                         width: MediaQuery.of(context).size.width * 0.47,
//                         height: MediaQuery.of(context).size.height * 0.76,
//                         decoration: BoxDecoration(
//                           color: const Color.fromARGB(105, 161, 167, 236),
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Column(
//                           //crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Shirt',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: 'Lato',
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(34, 45, 56, 78),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Text('L: ',
//                                       style: TextStyle(fontFamily: 'Lato')),
//                                   Expanded(
//                                     // Ensure TextField has bounded width
//                                     child: TextField(
//                                       keyboardType: TextInputType.number,
//                                       decoration: const InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: 'Length',
//                                           contentPadding: EdgeInsets.all(8),
//                                           hintStyle: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: 'Lato')),
//                                       controller: shirtL,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(34, 45, 56, 78),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Text('C: ',
//                                       style: TextStyle(fontFamily: 'Lato')),
//                                   Expanded(
//                                     // Ensure TextField has bounded width
//                                     child: TextField(
//                                       keyboardType: TextInputType.number,
//                                       decoration: const InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: 'Chest',
//                                           contentPadding: EdgeInsets.all(8),
//                                           hintStyle: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: 'Lato')),
//                                       controller: shirtC,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(34, 45, 56, 78),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Text('T: ',
//                                       style: TextStyle(fontFamily: 'Lato')),
//                                   Expanded(
//                                     // Ensure TextField has bounded width
//                                     child: TextField(
//                                       keyboardType: TextInputType.number,
//                                       decoration: const InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: 'Teera',
//                                           contentPadding: EdgeInsets.all(8),
//                                           hintStyle: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: 'Lato')),
//                                       controller: shirtT,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(34, 45, 56, 78),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Text('B: ',
//                                       style: TextStyle(fontFamily: 'Lato')),
//                                   Expanded(
//                                     // Ensure TextField has bounded width
//                                     child: TextField(
//                                       keyboardType: TextInputType.number,
//                                       decoration: const InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: 'Baaju',
//                                           contentPadding: EdgeInsets.all(8),
//                                           hintStyle: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: 'Lato')),
//                                       controller: shirtB,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(34, 45, 56, 78),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Text('G: ',
//                                       style: TextStyle(fontFamily: 'Lato')),
//                                   Expanded(
//                                     // Ensure TextField has bounded width
//                                     child: TextField(
//                                       keyboardType: TextInputType.number,
//                                       decoration: const InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: 'Gala',
//                                           contentPadding: EdgeInsets.all(8),
//                                           hintStyle: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: 'Lato')),
//                                       controller: shirtG,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(34, 45, 56, 78),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Text('S: ',
//                                       style: TextStyle(fontFamily: 'Lato')),
//                                   Expanded(
//                                     // Ensure TextField has bounded width
//                                     child: TextField(
//                                       decoration: const InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: 'Side',
//                                           contentPadding: EdgeInsets.all(8),
//                                           hintStyle: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: 'Lato')),
//                                       controller: shirtS,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             const Text(
//                               'Pyjama',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: 'Lato',
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(34, 45, 56, 78),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Text('L: ',
//                                       style: TextStyle(fontFamily: 'Lato')),
//                                   Expanded(
//                                     // Ensure TextField has bounded width
//                                     child: TextField(
//                                       keyboardType: TextInputType.number,
//                                       decoration: const InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: 'Length',
//                                           contentPadding: EdgeInsets.all(8),
//                                           hintStyle: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: 'Lato')),
//                                       controller: kurtaL,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(34, 45, 56, 78),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Text('H: ',
//                                       style: TextStyle(fontFamily: 'Lato')),
//                                   Expanded(
//                                     // Ensure TextField has bounded width
//                                     child: TextField(
//                                       keyboardType: TextInputType.number,
//                                       decoration: const InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: 'Hip',
//                                           contentPadding: EdgeInsets.all(8),
//                                           hintStyle: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: 'Lato')),
//                                       controller: kurtaH,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(34, 45, 56, 78),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Text('M: ',
//                                       style: TextStyle(fontFamily: 'Lato')),
//                                   Expanded(
//                                     // Ensure TextField has bounded width
//                                     child: TextField(
//                                       keyboardType: TextInputType.number,
//                                       decoration: const InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: 'Mori',
//                                           contentPadding: EdgeInsets.all(8),
//                                           hintStyle: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: 'Lato')),
//                                       controller: kurtaM,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(7),
//                         width: MediaQuery.of(context).size.width * 0.47,
//                         height: MediaQuery.of(context).size.height * 0.76,
//                         decoration: BoxDecoration(
//                           color: const Color.fromARGB(105, 161, 167, 236),
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Column(
//                           children: [
//                             const Text(
//                               'Pant',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: 'Lato',
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(34, 45, 56, 78),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Text('L: ',
//                                       style: TextStyle(fontFamily: 'Lato')),
//                                   Expanded(
//                                     // Ensure TextField has bounded width
//                                     child: TextField(
//                                       keyboardType: TextInputType.number,
//                                       decoration: const InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: 'Length',
//                                           contentPadding: EdgeInsets.all(8),
//                                           hintStyle: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: 'Lato')),
//                                       controller: pantL,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(34, 45, 56, 78),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Text('K: ',
//                                       style: TextStyle(fontFamily: 'Lato')),
//                                   Expanded(
//                                     // Ensure TextField has bounded width
//                                     child: TextField(
//                                       keyboardType: TextInputType.number,
//                                       decoration: const InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: 'Waist',
//                                           contentPadding: EdgeInsets.all(8),
//                                           hintStyle: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: 'Lato')),
//                                       controller: pantK,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(34, 45, 56, 78),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Text('H: ',
//                                       style: TextStyle(fontFamily: 'Lato')),
//                                   Expanded(
//                                     // Ensure TextField has bounded width
//                                     child: TextField(
//                                       keyboardType: TextInputType.number,
//                                       decoration: const InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: 'Hip',
//                                           contentPadding: EdgeInsets.all(8),
//                                           hintStyle: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: 'Lato')),
//                                       controller: pantH,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(34, 45, 56, 78),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Text('P: ',
//                                       style: TextStyle(fontFamily: 'Lato')),
//                                   Expanded(
//                                     // Ensure TextField has bounded width
//                                     child: TextField(
//                                       keyboardType: TextInputType.number,
//                                       decoration: const InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: 'P',
//                                           contentPadding: EdgeInsets.all(8),
//                                           hintStyle: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: 'Lato')),
//                                       controller: pantP,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(34, 45, 56, 78),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Text('A: ',
//                                       style: TextStyle(fontFamily: 'Lato')),
//                                   Expanded(
//                                     // Ensure TextField has bounded width
//                                     child: TextField(
//                                       keyboardType: TextInputType.number,
//                                       decoration: const InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: 'Aasan',
//                                           contentPadding: EdgeInsets.all(8),
//                                           hintStyle: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: 'Lato')),
//                                       controller: pantA,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(34, 45, 56, 78),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Text('M: ',
//                                       style: TextStyle(fontFamily: 'Lato')),
//                                   Expanded(
//                                     // Ensure TextField has bounded width
//                                     child: TextField(
//                                       keyboardType: TextInputType.number,
//                                       decoration: const InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: 'Mori',
//                                           contentPadding: EdgeInsets.all(8),
//                                           hintStyle: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: 'Lato')),
//                                       controller: pantM,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 7),
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(34, 45, 56, 78),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Text('BP: ',
//                                       style: TextStyle(fontFamily: 'Lato')),
//                                   Expanded(
//                                     // Ensure TextField has bounded width
//                                     child: TextField(
//                                       decoration: const InputDecoration(
//                                           border: InputBorder.none,
//                                           hintText: 'BP',
//                                           contentPadding: EdgeInsets.all(8),
//                                           hintStyle: TextStyle(
//                                               fontSize: 14,
//                                               fontFamily: 'Lato')),
//                                       controller: pantBP,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 17),
//                             Container(
//                               height: 130,
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 8, vertical: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color.fromARGB(34, 45, 56, 78),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     // Wrap the Column in Expanded to give it bounded width
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment
//                                           .start, // Align text and input properly
//                                       children: [
//                                         const Text(
//                                           'Note: ',
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontFamily: 'Lato'),
//                                         ),
//                                         TextField(
//                                           decoration: const InputDecoration(
//                                             border: InputBorder.none,
//                                             hintText: 'Additional Note',
//                                             contentPadding: EdgeInsets.all(8),
//                                             hintStyle: TextStyle(
//                                                 fontSize: 14,
//                                                 fontFamily: 'Lato'),
//                                           ),
//                                           controller: additional,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// AppBar _buildAppBar(BuildContext contextDo) {
//   return AppBar(
//     backgroundColor: const Color(0xfff5f7fa),
//     title: Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         if (saved) const Icon(Icons.done),
//         SizedBox(
//           height: 50,
//           width: 105,
//           child: ClipRRect(
//             //borderRadius: BorderRadius.circular(20),
//             child: Image.asset('assets/images/PT2copy.png'),
//           ),
//         ),
//       ],
//     ),
//   );
// }

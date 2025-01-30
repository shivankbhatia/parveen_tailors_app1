import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parveen_tailors/constants/colors.dart';
import 'package:parveen_tailors/database/customers_db.dart';
import 'package:parveen_tailors/screens/custome_page.dart';
import 'package:parveen_tailors/screens/customer_page2.dart';
import 'package:parveen_tailors/screens/edit_customer_page.dart';
import 'gsheet_setup.dart';
import 'package:parveen_tailors/screens/edit_customer_page2.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final toDoList = ToDo.todoList();
  // List<ToDo> _foundToDo = [];
  // final _toDoController = TextEditingController();

  List<Map<String, dynamic>> allNotes = [];
  List<Map<String, dynamic>> filteredNotes = [];
  CustomersDB? DBRef;
  bool recentBool = true;

  @override
  void initState() {
    super.initState();
    // _foundToDo = toDoList;
    DBRef = CustomersDB.getInstance;
    allNotes = [];
    filteredNotes = [];
    WidgetsFlutterBinding.ensureInitialized();
    GSheetInit();
    getNotes();
  }

  Future<void> getNotes() async {
    if (DBRef != null) {
      var result = await DBRef!.getAllNotes();
      setState(() {
        allNotes = result;
        filteredNotes = result;
      });
    }
  }

  Future<void> fetchForUpdate(int serialno) async {
    if (DBRef != null) {
      var result = await DBRef!.getData(sno: serialno);
      setState(() {});
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = List.from(allNotes);
    } else {
      results = allNotes
          .where((item) =>
              (item[CustomersDB.COLUMN_NOTE_TITLE] != null &&
                  item[CustomersDB.COLUMN_NOTE_TITLE]!
                      .toLowerCase()
                      .contains(enteredKeyword.toLowerCase())) ||
              (item[CustomersDB.COLUMN_NOTE_DESC] != null &&
                  item[CustomersDB.COLUMN_NOTE_DESC]!
                      .toLowerCase()
                      .contains(enteredKeyword.toLowerCase())))
          .toList();
    }

    setState(() {
      filteredNotes = results;
    });
  }

  bool showOptions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdfcfb),
      appBar: AppBar(
        backgroundColor: const Color(0xfff5f7fa),
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
            height: 50,
            width: 130,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: InkWell(
                child: Image.asset('assets/images/PT2copy.png'),
                onTap: () {
                  setState(() {
                    recentBool = !recentBool;
                  });
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          )
        ]),
      ),
      body: allNotes.isNotEmpty
          ? Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xfff5f7fa), Color(0xffc3cfe2)],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 1.0))),
              child: Column(
                children: [
                  Container(
                    width: 330,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 1, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: const Offset(
                              0, 3), // Offset in X and Y directions
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      style: const TextStyle(fontFamily: 'Lato'),
                      onChanged: (value) => _runFilter(value),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        prefixIcon:
                            Icon(Icons.search, color: tdBlack, size: 20),
                        prefixIconConstraints:
                            BoxConstraints(maxHeight: 20, minWidth: 25),
                        border: InputBorder.none,
                        hintText: ' Search',
                        hintStyle: TextStyle(
                          color: tdgrey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Customers',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          fontFamily:
                              'Lato', // Match the family name from pubspec.yaml
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      displacement: 35,
                      onRefresh: () {
                        return getNotes();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(4),
                        itemCount: filteredNotes.length,
                        itemBuilder: (_, index) {
                          // Reversed list
                          int reversedIndex = filteredNotes.length - 1 - index;

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10), // Optional spacing
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 181, 212,
                                  239), // Apply background color here
                              borderRadius: BorderRadius.circular(
                                  50), // Match the rounded corners
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15), // Rounded corners for the ListTile
                              ),
                              leading: Text('${index + 1}'),
                              title: Text(
                                filteredNotes[reversedIndex]
                                    [CustomersDB.COLUMN_NOTE_TITLE],
                                style: const TextStyle(fontFamily: 'Lato'),
                              ),
                              subtitle: Text(
                                filteredNotes[reversedIndex]
                                    [CustomersDB.COLUMN_NOTE_DESC],
                                style: const TextStyle(fontFamily: 'Lato'),
                              ),
                              trailing: SizedBox(
                                width: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (!showOptions)
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return BottomSheetView(
                                                DBRef: DBRef!,
                                                getNote: getNotes,
                                                isUpdate: true,
                                                sno:
                                                    filteredNotes[reversedIndex]
                                                        [CustomersDB
                                                            .COLUMN_NOTE_SNO],
                                              );
                                            },
                                          );
                                        },
                                        child: const Icon(
                                            Icons.edit_note_rounded,
                                            size: 30),
                                      ),
                                    if (showOptions)
                                      InkWell(
                                        onTap: () async {
                                          bool check =
                                              await alert(context: context);
                                          if (check) {
                                            bool deletionSuccess =
                                                await DBRef!.deleteNote(
                                              sno: filteredNotes[reversedIndex]
                                                  [CustomersDB.COLUMN_NOTE_SNO],
                                            );
                                            if (deletionSuccess) {
                                              getNotes(); // Refresh the list after deletion
                                            }
                                          } else {
                                            print('Deletion canceled');
                                          }
                                        },
                                        child: const Icon(Icons.delete,
                                            color: Colors.red),
                                      ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage2(
                                      DBRef: DBRef!,
                                      sno: filteredNotes[reversedIndex]
                                          [CustomersDB.COLUMN_NOTE_SNO],
                                    ),
                                  ),
                                );
                              },
                              onLongPress: () {
                                showOptions = !showOptions;
                                setState(() {});
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          titleController.clear();
          descController.clear();
          receiptController.clear();
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              final defaultSno = allNotes.isNotEmpty
                  ? allNotes.last[CustomersDB.COLUMN_NOTE_SNO] + 1
                  : 1;
              return BottomSheetView(
                DBRef: DBRef!,
                getNote: getNotes,
                isUpdate: false,
                sno: defaultSno,
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<bool> alert({required BuildContext context}) async {
  bool check = false;
  await showCupertinoDialog(
    context: context,
    builder: (BuildContext context2) => CupertinoAlertDialog(
      title: const Text(
        'Are you sure you want to delete the contact?',
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

class BottomSheetView extends StatefulWidget {
  final CustomersDB DBRef;
  final Future<void> Function() getNote;
  final bool isUpdate;
  final int sno;

  BottomSheetView(
      {required this.DBRef,
      required this.getNote,
      required this.isUpdate,
      required this.sno});

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetViewState();
  }
}

TextEditingController titleController = TextEditingController();
TextEditingController descController = TextEditingController();
TextEditingController receiptController = TextEditingController();

class _BottomSheetViewState extends State<BottomSheetView> {
  //controller...

  // void getNotes() async {
  //   allNotes = await DBRef!.getAllNotes();
  //   print('Fetched Notes: $allNotes');
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      // Perform any necessary initialization if it's an update
      getnamecont();
    }
  }

  Future<void> getnamecont() async {
    Map<String, dynamic>? customerData =
        await widget.DBRef.getData(sno: widget.sno);
    if (customerData != null) {
      setState(() {
        titleController.text = customerData['title']?.toString() ?? '';
        descController.text = customerData['desc']?.toString() ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5 +
          MediaQuery.of(context).viewInsets.bottom,
      padding: EdgeInsets.only(
          top: 11,
          left: 11,
          right: 11,
          bottom: 11 + MediaQuery.of(context).viewInsets.bottom),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.isUpdate ? 'Update Contact' : 'New Contact',
            style: const TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'Lato'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: "Enter Name here",
              label: const Text('Name', style: TextStyle(fontFamily: 'Lato')),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: descController,
            decoration: InputDecoration(
              hintText: "Enter Contact here",
              label:
                  const Text('Contact', style: TextStyle(fontFamily: 'Lato')),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: receiptController,
            decoration: InputDecoration(
              hintText: "Enter Receipt No. here",
              label: const Text('Receipt No.',
                  style: TextStyle(fontFamily: 'Lato')),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 21),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 229, 236, 248),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        side: BorderSide(
                          width: 4,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      //await widget.getNote();
                    },
                    child: const Text('Cancel',
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
              ),
              const SizedBox(
                width: 11,
              ),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 229, 236, 248),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      side: BorderSide(
                        width: 4,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    //save in database
                    var mtitle = titleController.text;
                    var mdesc = descController.text;
                    var mreceipt = receiptController.text;

                    if (mtitle.isNotEmpty && mdesc.isNotEmpty) {
                      if (widget.DBRef != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPage2(
                              DBRef: widget.DBRef,
                              name: mtitle,
                              contact: mdesc,
                              receipt: mreceipt,
                              isUpdate: widget.isUpdate ? true : false,
                              sno: widget.sno,
                            ),
                          ),
                        );
                        //Navigator.pop(context);
                        // Call getNotes from parent class to refresh the list
                        //await widget.getNote();
                      } else {
                        // Handle the case where DBRef is null
                        print('DBRef is null!');
                      }
                    } else {
                      //close bottom sheet...
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Durations.extralong1,
                          content: Text('Please fill complete fields',
                              style: TextStyle(fontFamily: 'Lato')),
                        ),
                      );
                    }
                    titleController.clear();
                    descController.clear();
                    receiptController.clear();
                  },
                  child: Text(
                      widget.isUpdate ? 'Update Contact' : 'Add Contact',
                      style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

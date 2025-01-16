import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parveen_tailors/constants/colors.dart';
import 'package:parveen_tailors/database/customers_db.dart';
import 'package:parveen_tailors/screens/custome_page.dart';
import 'package:parveen_tailors/screens/edit_customer_page.dart';
import 'gsheet_setup.dart';

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

  // void _handleToDoChange(ToDo todo) {
  //   setState(() {
  //     todo.isDone = !todo.isDone;
  //   });
  // }

  // void _deleteToDoItem(String id) {
  //   setState(() {
  //     toDoList.removeWhere((item) => item.id == id);
  //   });
  // }

  // void _addToDoItem(String todo) {
  //   setState(() {
  //     toDoList.add(ToDo(
  //       id: DateTime.now().millisecondsSinceEpoch.toString(),
  //       toDoText: todo,
  //     ));
  //   });
  //   _toDoController.clear();
  // }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = List.from(allNotes);
    } else {
      results = allNotes
          .where((item) =>
              item[CustomersDB.COLUMN_NOTE_TITLE] != null &&
              item[CustomersDB.COLUMN_NOTE_TITLE]!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredNotes = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdfcfb),
      appBar: AppBar(
        backgroundColor: const Color(0xfff5f7fa),
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IconButton(
            onPressed: () {
              getNotes();
            },
            icon: const Icon(Icons.refresh_rounded, color: tdBlack, size: 25),
          ),
          SizedBox(
            height: 50,
            width: 110,
            child: ClipRRect(
              // borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Image.asset('assets/images/PT2copy.png'),
            ),
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
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          fontFamily:
                              'Lato', // Match the family name from pubspec.yaml
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredNotes.length,
                      itemBuilder: (_, index) {
                        // Reversed list
                        int reversedIndex = filteredNotes.length - 1 - index;

                        return ListTile(
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
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                          sno: filteredNotes[reversedIndex]
                                              [CustomersDB.COLUMN_NOTE_SNO],
                                        );
                                      },
                                    );
                                  },
                                  child: const Icon(Icons.edit, size: 26),
                                ),
                                const SizedBox(width: 20),
                                InkWell(
                                  onTap: () async {
                                    bool check = await alert(context: context);
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
                                builder: (context) => DetailPage(
                                  DBRef: DBRef!,
                                  sno: filteredNotes[reversedIndex]
                                      [CustomersDB.COLUMN_NOTE_SNO],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              //child: Text('No notes to show !!'),
              child: Text('Nothing to Show!!'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          titleController.clear();
          descController.clear();
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
      height: MediaQuery.of(context).size.height * 0.4 +
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
                borderRadius: BorderRadius.circular(11),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
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
                borderRadius: BorderRadius.circular(11),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
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
                      await widget.getNote();
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

                    if (mtitle.isNotEmpty && mdesc.isNotEmpty) {
                      if (widget.DBRef != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerPage(
                              DBRef: widget.DBRef,
                              name: mtitle,
                              contact: mdesc,
                              isUpdate: widget.isUpdate ? true : false,
                              sno: widget.sno,
                            ),
                          ),
                        );
                        //Navigator.pop(context);
                        // Call getNotes from parent class to refresh the list
                        await widget.getNote();
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

// Widget searchBox() {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 15),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(20),
//     ),
//     child: TextField(
//       onChanged: (value) => _runFilter(value),
//       decoration: const InputDecoration(
//           contentPadding: EdgeInsets.all(0),
//           prefixIcon: Icon(Icons.search, color: tdBlack, size: 20),
//           prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
//           border: InputBorder.none,
//           hintText: ' Search',
//           hintStyle: TextStyle(
//             color: tdgrey,
//           )),
//     ),
//   );
// }

// AppBar _buildAppBar(BuildContext context) {
//   return AppBar(
//     backgroundColor: tdBGColor,
//     title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//       IconButton(
//         onPressed: () {},
//         icon: const Icon(Icons.menu, color: tdBlack, size: 30),
//       ),
//       SizedBox(
//         height: 50,
//         width: 110,
//         child: ClipRRect(
//           //borderRadius: BorderRadius.circular(10),
//           child: Image.asset('assets/images/PT2copy.png'),
//         ),
//       )
//     ]),
//   );
// }

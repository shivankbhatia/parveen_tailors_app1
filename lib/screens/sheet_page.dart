import 'package:flutter/material.dart';
import 'gsheet_insert.dart';

class SheetPage extends StatefulWidget {
  const SheetPage({super.key});

  @override
  State<SheetPage> createState() => _SheetPageState();
}

class _SheetPageState extends State<SheetPage> {
  final inputText = TextEditingController();

  @override
  void dispose() {
    inputText.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GSheet'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: inputText,
              decoration: const InputDecoration(
                labelText: 'Enter Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                final enteredName = inputText.text.trim();
                if (enteredName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a name')),
                  );
                  return;
                }

                // Prepare data
                List<Map<String, dynamic>> userDetailsList = [
                  {
                    'name': enteredName,
                    'contact': '9896055901',
                  }
                ];

                // Attempt to insert data
                try {
                  await insertDataIntoSheet(userDetailsList);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data saved successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to save data: $e')),
                  );
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

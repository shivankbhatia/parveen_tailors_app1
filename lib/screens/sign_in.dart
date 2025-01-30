// import 'dart:convert';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
// import 'package:mime/mime.dart';
// import 'package:path/path.dart' as p;

// class DriveStorageScreen extends StatefulWidget {
//   const DriveStorageScreen({super.key});

//   @override
//   State<DriveStorageScreen> createState() => _DriveStorageScreenState();
// }

// class _DriveStorageScreenState extends State<DriveStorageScreen> {
//   final _googleSignIn = GoogleSignIn(
//     scopes: [
//       'https://www.googleapis.com/auth/drive.file', // Important scope
//     ],
//   );
//   GoogleSignInAccount? _currentUser;
//   String? _uploadedFileId;

//   @override
//   void initState() {
//     super.initState();
//     _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
//       setState(() {
//         _currentUser = account;
//       });
//     });
//     _googleSignIn.signInSilently();
//   }

//   Future<void> _handleSignIn() async {
//     try {
//       await _googleSignIn.signIn();
//     } catch (error) {
//       print(error);
//     }
//   }

//   Future<void> _handleSignOut() => _googleSignIn.signOut();

//   Future<void> _uploadFile() async {
//     if (_currentUser == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please sign in first.')),
//       );
//       return;
//     }

//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['csv'],
//       );

//       if (result != null) {
//         File file = File(result.files.single.path!);
//         final mimeType = lookupMimeType(file.path);

//         final authHeaders = await _currentUser!.authHeaders;
//         final accessToken = authHeaders['Authorization']!.substring(7);

//         final url = Uri.parse(
//             'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart');

//         final request = http.MultipartRequest('POST', url);
//         request.headers.addAll({
//           'Authorization': 'Bearer $accessToken',
//         });

//         request.files.add(await http.MultipartFile.fromPath(
//           'file',
//           file.path,
//           contentType: mimeType != null ? MediaType.parse(mimeType) : null,
//         ));

//         request.fields['metadata'] = jsonEncode({
//           'name': p.basename(file.path),
//         });

//         final streamedResponse = await request.send();
//         final response = await http.Response.fromStream(streamedResponse);

//         if (response.statusCode == 200) {
//           final jsonResponse = jsonDecode(response.body);
//           setState(() {
//             _uploadedFileId = jsonResponse['id'];
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('File uploaded successfully!')),
//           );
//         } else {
//           print('Upload failed with status: ${response.statusCode}');
//           print('Response body: ${response.body}');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Upload failed: ${response.body}')),
//           );
//         }
//       }
//     } catch (e) {
//       print('Upload error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Upload error: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Google Drive Upload'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             if (_currentUser != null) ...[
//               ListTile(
//                 leading: GoogleUserCircleAvatar(identity: _currentUser!),
//                 title: Text(_currentUser!.displayName ?? ''),
//                 subtitle: Text(_currentUser!.email),
//               ),
//               const Text("Signed in successfully."),
//               ElevatedButton(
//                 onPressed: _handleSignOut,
//                 child: const Text('Sign Out'),
//               ),
//               ElevatedButton(
//                 onPressed: _uploadFile,
//                 child: const Text('Upload CSV File'),
//               ),
//               if (_uploadedFileId != null)
//                 Text('Uploaded File ID: $_uploadedFileId'),
//             ] else ...[
//               const Text("You are not currently signed in."),
//               ElevatedButton(
//                 onPressed: _handleSignIn,
//                 child: const Text('Sign in with Google'),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

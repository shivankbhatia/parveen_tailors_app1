import 'package:flutter/material.dart';
import 'package:parveen_tailors/screens/home.dart';
import 'package:parveen_tailors/screens/splash_screen.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parveen Tailors App_1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 148, 181, 234)),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

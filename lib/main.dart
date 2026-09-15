import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:karum_manger/interfaces/app_shell.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl, // Forces Right-To-Left for Arabic UI
        child: AppShell(),
      ),
    );
  }
}
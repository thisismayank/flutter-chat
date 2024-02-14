import 'package:casper/chat_page.dart';
import 'package:casper/login_page.dart';
import 'package:flutter/material.dart';

// import 'chat_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EmailScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RPL To-Do List',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

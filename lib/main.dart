import 'package:Jedwali/app.dart';
import 'package:Jedwali/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "Jedwali",
    initialRoute: '/login',
    routes: {
      '/login': (BuildContext context) => Login(),
      '/': (BuildContext context) => const Jedwali()
    },
    debugShowCheckedModeBanner: false,
  ));
}

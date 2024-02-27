import 'package:Jedwali/app.dart';
import 'package:Jedwali/login.dart';
import 'package:Jedwali/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    title: "Jedwali",
    initialRoute: '/login',
    getPages: Routes.routes,
    debugShowCheckedModeBanner: false,
  ));
}

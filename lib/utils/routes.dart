import 'package:Jedwali/app.dart';
import 'package:Jedwali/login.dart';
import 'package:Jedwali/views/classes_page.dart';
import 'package:Jedwali/views/registration_page.dart';
import 'package:get/get.dart';

class Routes {
  static var routes = [
    GetPage(name: "/login", page: () => Login()),
    GetPage(name: "/", page: () => const Jedwali()),
    GetPage(name: "/add_class", page: () => const AddClassPage()),
    GetPage(name: "/registration", page: () => RegistrationPage()),
  ];
}

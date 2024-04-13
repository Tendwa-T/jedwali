import 'package:jedwali/app.dart';
import 'package:jedwali/login.dart';
import 'package:jedwali/views/classes_page.dart';
import 'package:jedwali/views/registration_page.dart';
import 'package:get/get.dart';

class Routes {
  static var routes = [
    GetPage(name: "/login", page: () => Login()),
    GetPage(name: "/", page: () => const Jedwali()),
    GetPage(name: "/add_class", page: () => const AddClassPage()),
    GetPage(name: "/registration", page: () => RegistrationPage()),
  ];
}

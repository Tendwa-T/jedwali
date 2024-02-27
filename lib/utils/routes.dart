import 'package:Jedwali/app.dart';
import 'package:Jedwali/login.dart';
import 'package:Jedwali/views/classes_page.dart';
import 'package:get/get.dart';

class Routes {
  static var routes = [
    GetPage(name: "/login", page: () => const Login()),
    GetPage(name: "/", page: () => const Jedwali()),
    GetPage(name: "/add_class", page: () => const AddClassPage())
  ];
}

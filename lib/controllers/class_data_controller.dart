import 'dart:convert';

import 'package:Jedwali/models/class_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ClassesController extends GetxController {
  var lessons = <Classes>[].obs;
  Future<void> fetchClasses() async {
    try {
      final response = await http
          .get(Uri.parse('https://jedwali-backend.vercel.app/api/v1/lessons/'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        lessons.value =
            jsonResponse.map((data) => Classes.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load classes");
      }
    } catch (e) {
      Get.snackbar("Error", "Could not fetch classes");
    }
  }
}

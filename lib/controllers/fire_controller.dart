import 'package:get/get.dart';

class FireController extends GetxController {
  var token = "".obs;

  updateToken(tkn) => token.value = tkn;
}

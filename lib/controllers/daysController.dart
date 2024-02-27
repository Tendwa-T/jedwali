import 'package:get/get.dart';

class DaysController extends GetxController {
  RxInt selectedDay = RxInt(DateTime.now().weekday);

  void selectDay(int index) {
    selectedDay.value = index;
  }

  int returnIntDay(var selectedIndex) {
    return selectedDay.value.toInt();
  }
}

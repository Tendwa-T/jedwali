import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeDatePickerController extends GetxController {
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  var selectedDate = DateTime.now().obs;

  void updateTime(TimeOfDay newTime) {
    selectedTime.value = newTime;
  }

  void changeDate(DateTime newDate) {
    selectedDate.value = newDate;
  }

  Future<void> showTimerDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Obx(() =>
              Text("Selected Time: ${selectedTime.value.format(context)}")),
          content: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime.value,
                    );
                    if (pickedTime != null) {
                      updateTime(pickedTime);
                    }
                  },
                  child: const Text("Choose time"),
                ),
                OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Ok"))
              ],
            ),
          ),
        );
      },
    );
  }
}

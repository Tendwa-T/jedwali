import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimePickerController extends GetxController {
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;

  void updateTime(TimeOfDay newTime) {
    selectedTime.value = newTime;
  }

  Future<void> showTimerDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Obx(() =>
              Text("Selected Time: ${selectedTime.value.format(context)}")),
          content: SingleChildScrollView(
            child: Container(
              child: Column(
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
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

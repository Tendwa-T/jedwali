import 'package:Jedwali/configs/constants.dart';
import 'package:Jedwali/controllers/class_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

ClassesController _controller = Get.put(ClassesController());

class TimerWidget extends StatelessWidget {
  const TimerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 379,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color.fromRGBO(108, 99, 255, 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Next class in: ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Obx(
              () => TimerCountdown(
                format: CountDownTimerFormat.daysHoursMinutesSeconds,
                timeTextStyle: const TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                ),
                descriptionTextStyle: const TextStyle(
                  color: appWhite,
                ),
                colonsTextStyle: const TextStyle(
                  color: Colors.white70,
                  fontSize: 40,
                ),
                endTime: DateTime.now().add(_controller.toNext.value),
                onEnd: () {
                  toastification.show(
                    context: context,
                    type: ToastificationType.success,
                    title: const Text("Success!!"),
                    autoCloseDuration: const Duration(seconds: 2),
                    style: ToastificationStyle.flatColored,
                    description: const Text("Timer complete"),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

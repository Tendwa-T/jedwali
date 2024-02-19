import 'package:Jedwali/configs/constants.dart';
import 'package:Jedwali/controllers/class_data_controller.dart';
import 'package:Jedwali/models/demo_data.dart';
import 'package:Jedwali/widgets/custom_text.dart';
import 'package:Jedwali/widgets/timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class ClassesPage extends StatelessWidget {
  ClassesPage({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  final ClassesController _controller = Get.put(ClassesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.refresh_outlined,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          /* toastification.show(
            context: context,
            type: ToastificationType.info,
            style: ToastificationStyle.flatColored,
            title: const Text("Test action button"),
            description: const Text("Floating Action button pressed"),
            autoCloseDuration: const Duration(
              seconds: 2,
            ),
          ); */
          _controller.fetchClasses();
        },
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenHeight - 80,
            maxWidth: screenWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
              left: 16.0,
              top: 10.0,
              bottom: 16.0,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Row(
                  children: [
                    CustomText(
                      label: "Classes 🏫",
                      fontSize: 40,
                      labelColor: primaryColor,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Row(
                  children: [TimerWidget()],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "All Classes",
                  style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.underline,
                      fontSize: 30),
                ),
                Expanded(
                  child: Obx(() {
                    if (_controller.lessons.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.separated(
                        itemCount: _controller.lessons.length,
                        itemBuilder: (context, index) {
                          final lesson = _controller.lessons[index];
                          return ListTile(
                            title: Text(lesson.course_title),
                            subtitle: Text(
                                '${lesson.course_code}  |  ${lesson.day}  |  ${lesson.time}  |  ${lesson.location}  |'),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      );
                    }
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

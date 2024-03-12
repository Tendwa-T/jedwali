import 'package:Jedwali/configs/constants.dart';
import 'package:Jedwali/controllers/class_data_controller.dart';
import 'package:Jedwali/controllers/daysController.dart';
import 'package:Jedwali/controllers/time_picker_controller.dart';
import 'package:Jedwali/models/class_model.dart';
import 'package:Jedwali/utils/imageProvider.dart';
import 'package:Jedwali/views/dashboard_page.dart';
import 'package:Jedwali/widgets/custom_text.dart';
import 'package:Jedwali/widgets/custom_text_field.dart';
import 'package:Jedwali/widgets/timer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

TextEditingController courseCodeController = TextEditingController();
TextEditingController courseTitle = TextEditingController();
TextEditingController courseTime = TextEditingController();
TextEditingController courseDay = TextEditingController();

final DaysController daysController = Get.put(DaysController());

class ClassesPage extends StatelessWidget {
  ClassesPage({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  final ClassesController classController = Get.put(ClassesController());
  final TimePickerController timePickerController =
      Get.put(TimePickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          classController.fetchClasses();
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
                Row(
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
                    if (classController.lessons.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.separated(
                        itemCount: classController.lessons.length,
                        itemBuilder: (context, index) {
                          final lesson = classController.lessons[index];
                          return ListTile(
                            onTap: () {
                              showEditModal(context, lesson);
                            },
                            enabled: true,
                            style: ListTileStyle.list,
                            title: Text(
                              lesson.course_title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                              ),
                            ),
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

void showEditModal(BuildContext context, Classes lesson) {
  TextEditingController courseTitleController =
      TextEditingController(text: lesson.course_title);
  TextEditingController courseCodeController =
      TextEditingController(text: lesson.course_code);
  TextEditingController dayController = TextEditingController(text: lesson.day);
  TextEditingController timeController =
      TextEditingController(text: lesson.time);
  TextEditingController locationController =
      TextEditingController(text: lesson.location);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Text('Edit Lesson'),
        content: Column(
          children: [
            TextField(
              controller: courseTitleController,
              decoration: const InputDecoration(labelText: 'Course Title'),
            ),
            TextField(
              controller: courseCodeController,
              decoration: const InputDecoration(labelText: 'Course Code'),
            ),
            TextField(
              controller: dayController,
              decoration: const InputDecoration(labelText: 'Day'),
            ),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'Time'),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Save the edited data
              lesson.course_title = courseTitleController.text;
              lesson.course_code = courseCodeController.text;
              lesson.day = dayController.text;
              lesson.time = timeController.text;
              lesson.location = locationController.text;
              Classes updatedClass = Classes(
                course_code: lesson.course_code,
                course_title: lesson.course_title,
                time: lesson.time,
                day: lesson.day,
                location: lesson.location,
                id: lesson.id,
              );
              await classesController.updateCLass(updatedClass);
              // Perform any other necessary actions

              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

void showAddClassDialog(BuildContext context) {
  TextEditingController courseTitleController = TextEditingController();
  TextEditingController courseCodeController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Text('Add Class'),
        content: Column(
          children: [
            TextField(
              controller: courseTitleController,
              decoration: const InputDecoration(labelText: 'Course Title'),
            ),
            TextField(
              controller: courseCodeController,
              decoration: const InputDecoration(labelText: 'Course Code'),
            ),
            TextField(
              controller: dayController,
              decoration: const InputDecoration(labelText: 'Day'),
            ),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'Time'),
              onTap: () async {
                showTimePicker(
                    context: context,
                    initialTime: timePickerController.selectedTime.value);
                timeController.text =
                    timePickerController.selectedTime.value.format(context);
              },
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Save the entered data
              String courseTitle = courseTitleController.text;
              String courseCode = courseCodeController.text;
              String day = dayController.text;
              String time = timeController.text;
              String location = locationController.text;

              Classes newClass = Classes(
                course_code: courseCode,
                course_title: courseTitle,
                time: time,
                day: day,
                location: location,
              );

              classesController.createClass(newClass);
              // Perform any necessary actions with the entered data
              // For example, create a new class object and save it

              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

class AddClassPage extends StatelessWidget {
  const AddClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Add Class"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: Column(
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: appGrey,
                image: DecorationImage(
                  image: getSVGImage('/assests/images/loginPage.svg'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    icon: Icons.numbers,
                    controller: courseCodeController,
                    label: "Course Code",
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CustomTextField(
                    icon: Icons.abc,
                    controller: courseDay,
                    label: "Course Title",
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              icon: Icons.numbers,
              controller: courseCodeController,
              label: "Course Code",
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: /* CustomTextField(
                    icon: Icons.calendar_today,
                    controller: courseDay,
                    label: "Day",
                  ), */
                      Column(
                    children: [
                      Obx(
                        () => Text(
                            "Day: ${DateFormat('EEEE').format(DateTime.now().add(Duration(days: daysController.returnIntDay(daysController.selectedDay.value))))}"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Select Day"),
                                content: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: List.generate(7, (index) {
                                        return Obx(
                                          () => RadioListTile<int>(
                                            title: Text(
                                              DateFormat('EEEE').format(
                                                  DateTime.now().add(
                                                      Duration(days: index))),
                                            ),
                                            value: index,
                                            groupValue: daysController
                                                .selectedDay.value,
                                            onChanged: (int? value) {
                                              daysController.selectDay(value!);
                                            },
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Select day"),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        child: const Text("Select Day"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Obx(
                        () => Text(
                            "Selected time: ${timePickerController.selectedTime.value.format(context)}"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await timePickerController.showTimerDialog(context);
                          courseTime.text = timePickerController
                              .selectedTime.value
                              .format(context)
                              .toString();
                        },
                        child: const Text("Pick time"),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

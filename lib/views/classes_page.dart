import 'package:jedwali/configs/constants.dart';
import 'package:jedwali/controllers/class_data_controller.dart';
import 'package:jedwali/controllers/daysController.dart';
import 'package:jedwali/controllers/time_picker_controller.dart';

import 'package:jedwali/models/class_model.dart';
import 'package:jedwali/utils/imageProvider.dart';
import 'package:jedwali/views/dashboard_page.dart';
import 'package:jedwali/widgets/custom_text.dart';
import 'package:jedwali/widgets/custom_text_field.dart';
import 'package:jedwali/widgets/timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

TextEditingController courseCodeController = TextEditingController();
TextEditingController courseTitle = TextEditingController();
TextEditingController courseTime = TextEditingController();
TextEditingController courseDay = TextEditingController();

final DaysController daysController = Get.put(DaysController());

class ClassesPage extends StatelessWidget {
  ClassesPage({
    super.key,
  });

  final ClassesController classController = Get.put(ClassesController());
  final TimeDatePickerController timePickerController =
      Get.put(TimeDatePickerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton.extended(
        label: Row(
          children: [
            Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
            const Text("Add a class")
          ],
        ),
        onPressed: () {
          showAddClassDialog(context);
        },
      ),
      body: LiquidPullToRefresh(
        onRefresh: () async {
          await classController.fetchClasses();
        },
        child: ListView(
          padding: const EdgeInsets.only(top: 8),
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
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
                  Obx(() {
                    if (classController.isLoadingClasses.isTrue) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (classController.lessons.isEmpty) {
                      return Center(
                        child: Text(
                          "No classes to Show",
                          style: const TextStyle().copyWith(fontSize: 20),
                        ),
                      );
                    } else {
                      return Obx(
                        () => ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
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
                                lesson.courseTitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22,
                                ),
                              ),
                              subtitle: Text(
                                  '${lesson.courseCode}  |  ${lesson.day}  |  ${lesson.time}  |  ${lesson.location}  |'),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                        ),
                      );
                    }
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showEditModal(BuildContext context, Classes lesson) {
  TextEditingController courseTitleController =
      TextEditingController(text: lesson.courseTitle);
  TextEditingController courseCodeController =
      TextEditingController(text: lesson.courseCode);
  TextEditingController dayController = TextEditingController(text: lesson.day);
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
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: courseCodeController,
              decoration: const InputDecoration(labelText: 'Course Code'),
            ),
            TextField(
              controller: dayController,
              decoration: const InputDecoration(labelText: 'Day'),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: () async {
                    await timePickerController.showTimerDialog(context);
                  },
                  child: Text(
                      timePickerController.selectedTime.value.format(context)),
                ),
              ),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await classesController.deleteClass(lesson.id);
                // Perform any other necessary actions

                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.delete)),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Save the edited data

              lesson.courseTitle = courseTitleController.text;
              lesson.courseCode = courseCodeController.text;
              lesson.day = dayController.text;
              lesson.time = timePickerController.selectedTime.value
                  .format(context)
                  .toString();
              lesson.location = locationController.text;
              Classes updatedClass = Classes(
                courseCode: lesson.courseCode,
                courseTitle: lesson.courseTitle,
                time: lesson.time,
                day: lesson.day,
                location: lesson.location,
                studentID: await prefs.getValue("student_id"),
                id: lesson.id,
              );
              await classesController.updateClass(updatedClass);
              classesController.fetchClasses();

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
  TextEditingController locationController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Text('Add Class'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Select Class Time"),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        await timePickerController.showTimerDialog(context);
                      },
                      child: Obx(
                        () => Text(
                          timePickerController.selectedTime.value
                              .format(context)
                              .toString(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
              String day = dayController.text.trim();
              String time = timePickerController.selectedTime.value
                  .format(context)
                  .toString();
              String location = locationController.text;

              var newClass = await prefs.getValue('student_id').then((value) {
                Classes newClass = Classes(
                  courseCode: courseCode,
                  courseTitle: courseTitle,
                  time: time,
                  day: day,
                  location: location,
                  studentID: value,
                );
                return newClass;
              });

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
                        () => Text("Day: ${DateFormat('EEEE').format(
                          DateTime.now().add(
                            Duration(
                              days: daysController.returnIntDay(
                                  daysController.selectedDay.value),
                            ),
                          ),
                        )}"),
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

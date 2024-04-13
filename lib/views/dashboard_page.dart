import 'package:jedwali/configs/constants.dart';
import 'package:jedwali/controllers/assignment_controller.dart';
import 'package:jedwali/controllers/class_data_controller.dart';
import 'package:jedwali/controllers/time_picker_controller.dart';

import 'package:jedwali/utils/preferences.dart';
import 'package:jedwali/views/classes_page.dart';
import 'package:jedwali/widgets/custom_text.dart';
import 'package:jedwali/widgets/timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

TimeDatePickerController timePickerController =
    Get.put(TimeDatePickerController());
ClassesController classesController = Get.find<ClassesController>();
PrefsController prefsController = Get.put(PrefsController());
AssignmentController _assignmentController = Get.put(AssignmentController());
PageController pageController = Get.find<PageController>();
Preferences prefs = Preferences();
TextEditingController dispName = TextEditingController();
final DateFormat dateFormat = DateFormat.yMMMMEEEEd();

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({
    super.key,
  });

  bool hasAssignments() {
    if (_assignmentController.assignments.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (classesController.lessons.isEmpty) classesController.fetchClasses();
    if (_assignmentController.assignments.isEmpty) {
      _assignmentController.fetchAssignments();
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 16.0,
            left: 16.0,
            top: 10.0,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Obx(
                    () => CustomText(
                      label: "Welcome ${prefsController.name.value}! 👋",
                      fontSize: 38,
                      labelColor: primaryColor,
                    ),
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
              const Row(
                children: [
                  Text(
                    "CLASSES",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.school,
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => ExpandableCarousel(
                        options: CarouselOptions(
                          showIndicator: true,
                          slideIndicator: const CircularSlideIndicator(),
                          height: 200,
                          viewportFraction: 1.0,
                          autoPlay: true,
                          autoPlayAnimationDuration: const Duration(seconds: 1),
                          autoPlayInterval: const Duration(seconds: 4),
                          autoPlayCurve: Curves.easeInOut,
                        ),
                        items: classesController.isLoadingClasses.value
                            ? [const LinearProgressIndicator()]
                            : classesController.lessons.isEmpty
                                ? [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "No classes to show",
                                          style: const TextStyle()
                                              .copyWith(fontSize: 20),
                                          textAlign: TextAlign.center,
                                        )),
                                      ],
                                    )
                                  ]
                                : classesController.lessons.map((e) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Card(
                                          color: const Color(0xFFBDBFFF),
                                          child: SizedBox(
                                            height: 180,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16.0,
                                                right: 16.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            e.courseCode,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                            ),
                                                            //softWrap: true,
                                                          ),
                                                        ),
                                                        Text(
                                                          e.location,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                        child: Text(
                                                          e.courseTitle,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            e.day,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 17,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          e.time,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 17,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Row(
                children: [
                  Text(
                    "ASSIGNMENTS",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.assignment,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() {
                if (_assignmentController.isLoadingAssignments.isTrue) {
                  return const LinearProgressIndicator();
                } else if (_assignmentController.upcomingAssignments.isEmpty) {
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          "No Assignments to show",
                          style: const TextStyle().copyWith(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                } else {
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    itemCount: _assignmentController.upcomingAssignments.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final upAssignment =
                          _assignmentController.upcomingAssignments[index];
                      return Row(
                        children: [
                          CustomText(
                            label: '${index + 1}.',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            labelColor: Colors.black,
                          ),
                          Expanded(
                            flex: 10,
                            child: ListTile(
                              visualDensity: VisualDensity.compact,
                              onTap: () async {
                                await pageController.animateToPage(
                                  2,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              title: CustomText(
                                label: upAssignment.title,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                labelColor: Colors.black,
                              ),
                              subtitle: CustomText(
                                label: upAssignment.note ??
                                    "No note For this assignment",
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addModalButton(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Action"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showAddClassDialog(context);
                      },
                      child: const Text("Add Class"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Add Assignment"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:Jedwali/configs/constants.dart';
import 'package:Jedwali/controllers/class_data_controller.dart';
import 'package:Jedwali/controllers/time_picker_controller.dart';
import 'package:Jedwali/models/demo_data.dart';
import 'package:Jedwali/utils/preferences.dart';
import 'package:Jedwali/views/classes_page.dart';
import 'package:Jedwali/widgets/custom_text.dart';
import 'package:Jedwali/widgets/timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

TimePickerController timePickerController = Get.put(TimePickerController());
ClassesController classesController = Get.find<ClassesController>();
PrefsController prefsController = Get.put(PrefsController());
Preferences prefs = Preferences();
TextEditingController dispName = TextEditingController();

class DashBoardPage extends StatelessWidget {
  DashBoardPage({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;
  bool hasAssignments() {
    if (assignments.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () async {
          addModalButton(context);
        },
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenHeight * 1,
            maxWidth: screenWidth ,
          ),
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
                            autoPlayAnimationDuration:
                                const Duration(seconds: 1),
                            autoPlayInterval: const Duration(seconds: 4),
                            autoPlayCurve: Curves.easeInOut,
                          ),
                          items: classesController.lessons.isEmpty
                              ? [const LinearProgressIndicator()]
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
                                                          e.course_code,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                          //softWrap: true,
                                                        ),
                                                      ),
                                                      Text(
                                                        e.location,
                                                        style: const TextStyle(
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
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 20,
                                                      child: Text(
                                                        e.course_title,
                                                        style: const TextStyle(
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
                                                        style: const TextStyle(
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
                Row(
                  children: [
                    Expanded(
                      child: ExpandableCarousel(
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
                        items: hasAssignments()
                            ? assignments.map((e) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Card(
                                      elevation: 5,
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
                                                      child: CustomText(
                                                        label: e['course_code'],
                                                        labelColor:
                                                            Colors.black,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                    CustomText(
                                                      label: e['location'],
                                                      labelColor: Colors.black,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                    child: CustomText(
                                                      label: e['course_title'],
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: CustomText(
                                                        label: e['day'],
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    CustomText(
                                                      label: e['time'],
                                                      fontSize: 20,
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
                              }).toList()
                            : [0].map((e) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return const Card(
                                      elevation: 4,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      child: SizedBox(
                                        height: 180,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 16.0,
                                            right: 16.0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: CustomText(
                                                  label: "No Assignments ",
                                                  fontSize: 17,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                      ),
                    )
                  ],
                ),
              ],
            ),
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
            child: Container(
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
          ),
        );
      },
    );
  }
}

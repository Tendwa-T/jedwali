import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jedwali/configs/constants.dart';
import 'package:jedwali/controllers/assignment_controller.dart';
import 'package:jedwali/controllers/class_data_controller.dart';
import 'package:jedwali/controllers/time_picker_controller.dart';
import 'package:jedwali/models/assignment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jedwali/utils/preferences.dart';
import 'package:jedwali/views/dashboard_page.dart';
import 'package:jedwali/widgets/custom_text.dart';
import 'package:jedwali/widgets/custom_text_field.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class AssignmentsPage extends StatelessWidget {
  const AssignmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat.yMMMMEEEEd();
    AssignmentController controller = Get.put(AssignmentController());

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showAddModal(context);
            },
            label: const Row(
              children: [
                Icon(Icons.add),
                SizedBox(
                  width: 2,
                ),
                Text("Add Assignment"),
              ],
            )),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Assignments",
            style: const TextStyle().copyWith(fontSize: 32),
          ),
          bottom: const TabBar(
            tabs: [
              SizedBox(height: 30, child: Center(child: Text("Upcoming"))),
              SizedBox(height: 30, child: Center(child: Text("Submitted"))),
              SizedBox(height: 30, child: Center(child: Text("Overdue"))),
            ],
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        body: Builder(builder: (context) {
          return TabBarView(
            controller: DefaultTabController.of(context),
            children: [
              //const OverViewScreen(),
              LiquidPullToRefresh(
                onRefresh: () async {
                  await controller.fetchAssignments();
                },
                child: ListView(children: [
                  Obx(() {
                    if (controller.isLoadingAssignments.isTrue) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      if (controller.upcomingAssignments.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(8),
                          child: Center(
                            child: Text("No Upcoming Assignments"),
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        itemCount: controller.upcomingAssignments.length,
                        itemBuilder: (context, index) {
                          final assignment =
                              controller.upcomingAssignments[index];
                          final formattedDate = dateFormat
                              .format(DateTime.parse(assignment.dueDate))
                              .toString();
                          return ListTile(
                            onTap: () {
                              showEditModal(context, assignment);
                            },
                            enabled: true,
                            style: ListTileStyle.list,
                            title: Text(
                              assignment.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                              ),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Due:',
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle().copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Submitted: ',
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    if (assignment.submitted)
                                      const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    else
                                      const Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      );
                    }
                  }),
                ]),
              ),
              LiquidPullToRefresh(
                onRefresh: () async {
                  await controller.fetchAssignments();
                },
                child: ListView(children: [
                  Obx(() {
                    if (controller.isLoadingAssignments.isTrue) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      if (controller.submittedAssignments.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(8),
                          child: Center(
                            child: Text("No Submitted Assignments"),
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        itemCount: controller.submittedAssignments.length,
                        itemBuilder: (context, index) {
                          final assignment =
                              controller.submittedAssignments[index];
                          final formattedDate = dateFormat
                              .format(DateTime.parse(assignment.dueDate))
                              .toString();
                          return ListTile(
                            onTap: () {
                              showEditModal(context, assignment);
                            },
                            enabled: true,
                            style: ListTileStyle.list,
                            title: Text(
                              assignment.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Due:',
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle().copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Submitted: ',
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    if (assignment.submitted)
                                      const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    else
                                      const Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      );
                    }
                  }),
                ]),
              ),
              LiquidPullToRefresh(
                onRefresh: () async {
                  await controller.fetchAssignments();
                },
                child: ListView(children: [
                  Obx(() {
                    if (controller.isLoadingAssignments.isTrue) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      if (controller.overdueAssignments.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(8),
                          child: Center(
                            child: Text("No Overdue Assignments"),
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        itemCount: controller.overdueAssignments.length,
                        itemBuilder: (context, index) {
                          final assignment =
                              controller.overdueAssignments[index];
                          final formattedDate = dateFormat
                              .format(DateTime.parse(assignment.dueDate))
                              .toString();
                          return ListTile(
                            onTap: () {
                              showEditModal(context, assignment);
                            },
                            enabled: true,
                            style: ListTileStyle.list,
                            title: Text(
                              assignment.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                              ),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Due:',
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle().copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                  ],
                                ),
                                Text(
                                  "Overdue",
                                  style: const TextStyle().copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      );
                    }
                  }),
                ]),
              ),
            ],
          );
        }),
      ),
    );
  }
}

void showEditModal(BuildContext context, Assignment assignment) {
  TextEditingController titleController =
      TextEditingController(text: assignment.title);
  TextEditingController dueDateController = TextEditingController(
      text: DateTime.parse(assignment.dueDate).toLocal().toString());
  TextEditingController noteController =
      TextEditingController(text: assignment.note);
  AssignmentController assignmentController = Get.put(AssignmentController());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      var submittedLocal = assignment.submitted.obs;
      var selectedDate = assignment.dueDate.obs;

      DateFormat format = DateFormat("EEEE, MMMM d, y");
      return AlertDialog(
        scrollable: true,
        title: const Text("Edit Assignment"),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Assignment Title"),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(selectedDate.value),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    selectedDate.value = pickedDate.toString();
                  }
                },
                child: Obx(
                  () => Text(
                    format
                        .format(DateTime.parse(selectedDate.value))
                        .toString(),
                  ),
                ),
              ),
            ),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: "Notes"),
            ),
            Row(
              children: [
                Obx(
                  () => Checkbox(
                      value: submittedLocal.value,
                      onChanged: (value) {
                        submittedLocal.value = !submittedLocal.value;
                      }),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text("Submitted?"),
              ],
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () async {
                    // Send data to delete function
                    assignmentController.deleteAssignment(assignment.id);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.delete)),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Assignment updatedAssignment = Assignment(
                    id: assignment.id,
                    title: titleController.text,
                    courseCode: assignment.courseCode,
                    studentID: assignment.studentID,
                    dueDate: selectedDate.value,
                    submitted: submittedLocal.value,
                    note: noteController.text,
                  );

                  assignmentController.updateAssignment(updatedAssignment);
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          )
        ],
      );
    },
  );
}

void showAddModal(BuildContext context) {
  TextEditingController titleTEC = TextEditingController();
  TextEditingController notesTEC = TextEditingController();
  final TimeDatePickerController datePickerController =
      Get.put(TimeDatePickerController());

  final DateFormat format = DateFormat("EEEE, MMMM d, y");
  PrefsController prefsController = Get.put(PrefsController());
  AssignmentController assignmentController = Get.put(AssignmentController());

  var selectedateLocal = DateTime.now().obs;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const CustomText(
            label: "Add Assignment",
            fontSize: 25,
            labelColor: appBlack,
          ),
          content: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => DropdownButton<String>(
                        value: classesController.selectedCourseCode.value,
                        padding: const EdgeInsets.all(8),
                        elevation: 16,
                        borderRadius: BorderRadius.circular(20),
                        onChanged: (String? value) {
                          classesController.updateSelectedCourse(value!);
                        },
                        items: classesController.classData.entries
                            .map<DropdownMenuItem<String>>((MapEntry entry) {
                          return DropdownMenuItem<String>(
                            value: entry.value,
                            child: Text(entry.key),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedateLocal.value,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2030),
                        );
                        if (pickedDate != null) {
                          selectedateLocal.value = pickedDate;
                        }
                      },
                      child: Obx(
                        () => Text(
                          format.format(selectedateLocal.value).toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextField(controller: titleTEC, label: "Title"),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(controller: notesTEC, label: "Notes"),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Assignment assignment = Assignment(
                        title: titleTEC.text.capitalizeFirst ?? titleTEC.text,
                        courseCode: classesController.selectedCourseCode.value,
                        studentID: prefsController.studentID.value,
                        note: notesTEC.text.capitalizeFirst,
                        dueDate: selectedateLocal.string,
                        submitted: false,
                      );
                      assignmentController.createAssignment(assignment);
                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  ),
                ],
              )
            ],
          ),
        );
      });
}

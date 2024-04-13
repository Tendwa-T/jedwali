import 'package:jedwali/controllers/assignment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverViewScreen extends StatelessWidget {
  const OverViewScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    AssignmentController controller = Get.find<AssignmentController>();
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: const Row(
            children: [
              Icon(Icons.add),
              Text("Add Assignment"),
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Up-coming deadlines",
                    style: const TextStyle().copyWith(fontSize: 24),
                  ),
                  TextButton(
                    onPressed: () {
                      DefaultTabController.of(context).animateTo(1);
                    },
                    child: Text(
                      "View All",
                      style: const TextStyle().copyWith(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: screenWidth,
                height: 180,
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("Hello World"),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (controller.submittedAssignments.isNotEmpty)
                      ? Text(
                          "Submitted Assignments - ${controller.submittedAssignments.length}",
                          style: const TextStyle().copyWith(fontSize: 24),
                        )
                      : Text(
                          "Submitted Assignments",
                          style: const TextStyle().copyWith(fontSize: 24),
                        ),
                  TextButton(
                    onPressed: () {
                      DefaultTabController.of(context).animateTo(2);
                    },
                    child: Text(
                      "View All",
                      style: const TextStyle().copyWith(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: screenWidth,
                height: 180,
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("Hello World"),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Overdue Assignments",
                    style: const TextStyle().copyWith(fontSize: 24),
                  ),
                  TextButton(
                    onPressed: () {
                      DefaultTabController.of(context).animateTo(3);
                    },
                    child: Text(
                      "View All",
                      style: const TextStyle().copyWith(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: screenWidth,
                height: 180,
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("Hello World"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

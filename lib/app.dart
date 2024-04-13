import 'package:jedwali/controllers/assignment_controller.dart';
import 'package:jedwali/controllers/class_data_controller.dart';
import 'package:jedwali/views/pages/assignments/assignments_page.dart';
import 'package:jedwali/views/classes_page.dart';
import 'package:jedwali/views/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jedwali/views/pages/profiles/profile.dart';

class Jedwali extends StatefulWidget {
  const Jedwali({super.key});

  @override
  State<Jedwali> createState() => _JedwaliState();
}

class _JedwaliState extends State<Jedwali> {
  int currentPageIndex = 0;
  final PageController pageController = Get.put(PageController());
  final ClassesController _controller = Get.put(ClassesController());
  final AssignmentController _assignmentController =
      Get.put(AssignmentController());

  @override
  void initState() {
    super.initState();
    _controller.fetchClasses().then((value) {
      _assignmentController.fetchAssignments();
    });

    pageController.addListener(() {
      setState(() {
        currentPageIndex = pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        indicatorColor: const Color.fromRGBO(108, 99, 255, 1),
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            selectedIcon: Icon(
              Icons.dashboard,
              color: Colors.white,
            ),
            label: "DASHBOARD",
          ),
          NavigationDestination(
            icon: Icon(Icons.class_),
            selectedIcon: Icon(
              Icons.class_,
              color: Colors.white,
            ),
            label: "CLASSES",
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment),
            selectedIcon: Icon(
              Icons.assignment,
              color: Colors.white,
            ),
            label: "ASSIGNMENT",
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            selectedIcon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: "PROFILE",
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        children: [
          const DashBoardPage(),
          ClassesPage(),
          const AssignmentsPage(),
          const ProfilePage(),
        ],
      ),
    );
  }
}

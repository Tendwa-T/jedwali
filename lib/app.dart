import 'package:Jedwali/controllers/class_data_controller.dart';
import 'package:Jedwali/views/classes_page.dart';
import 'package:Jedwali/views/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Jedwali extends StatefulWidget {
  const Jedwali({super.key});

  @override
  State<Jedwali> createState() => _JedwaliState();
}

class _JedwaliState extends State<Jedwali> {
  int currentPageIndex = 0;
  late final PageController _pageController = PageController();
  final ClassesController _controller = Get.put(ClassesController());

  @override
  void initState() {
    super.initState();
    _controller.fetchClasses();
    _pageController.addListener(() {
      setState(() {
        currentPageIndex = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            _pageController.animateToPage(
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
            icon: Icon(Icons.quiz),
            selectedIcon: Icon(
              Icons.quiz,
              color: Colors.white,
            ),
            label: "EXAMS",
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: [
          DashBoardPage(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          ),
          ClassesPage(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          ),
          const Center(child: Text("Welcome to Assignments")),
        ],
      ),
    );
  }
}

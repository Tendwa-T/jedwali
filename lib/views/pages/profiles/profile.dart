import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jedwali/controllers/login/login_controller.dart';
import 'package:jedwali/utils/preferences.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    PrefsController prefsController = Get.put(PrefsController());
    LoginController loginController = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage("assets/images/male_student.png"),
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            prefsController.name.value,
                            style: const TextStyle(
                              fontSize: 32,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Divider(),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Student ID: ",
                        style: const TextStyle().copyWith(fontSize: 20),
                      )),
                      Obx(
                        () => Text(
                          prefsController.studentID.value,
                          style: const TextStyle()
                              .copyWith(fontSize: 20, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      loginController.userLogout();
                    },
                    child: const Text("Logout")),
              )
            ],
          ),
        ),
      ),
    );
  }
}

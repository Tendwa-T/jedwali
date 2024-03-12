// ignore_for_file: prefer_const_constructors

import 'package:Jedwali/configs/constants.dart';
import 'package:Jedwali/controllers/login/login_controller.dart';
import 'package:Jedwali/utils/imageProvider.dart';
import 'package:Jedwali/views/login_page.dart';
import 'package:Jedwali/views/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class Login extends StatelessWidget {
  late LoginController loginController;

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    loginController = Get.put(LoginController());
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: appGrey,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 1020,
              maxWidth: 500,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: appGrey,
                    image: DecorationImage(
                      image: getSVGImage('assets/images/loginPage.svg'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: appWhite,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    child: Builder(
                      builder: (context) => Column(
                        children: [
                          TabBar(
                            controller: DefaultTabController.of(context),
                            tabs: const [
                              Tab(
                                text: "Login",
                              ),
                              Tab(
                                text: "Sign up",
                              ),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: DefaultTabController.of(context),
                              children: [
                                LoginPage(),
                                RegistrationPage(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

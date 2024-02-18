// ignore_for_file: prefer_const_constructors

import 'package:Jedwali/configs/constants.dart';
import 'package:Jedwali/controllers/login/login_controller.dart';
import 'package:Jedwali/views/login_page.dart';
import 'package:Jedwali/views/registration_page.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// TODO: Implement BottomSheet widget for Login container
// TODO: Convert to Stateless widget

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  //For login

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginController loginController = Get.put(LoginController());

  //For signup
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _confPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    image: _getSVGImage('assets/images/loginPage.svg'),
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
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
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
                          controller: _tabController,
                          children: [
                            LoginPage(
                              usernameController: _usernameController,
                              passwordController: _passwordController,
                              loginController: loginController,
                            ),
                            RegistrationPage(
                              firstNameController: _firstNameController,
                              lastNameController: _lastNameController,
                              emailController: _emailController,
                              phoneNumberController: _phoneNumberController,
                              passwordController: _passwordController,
                              confPassword: _confPassword,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

ImageProvider _getSVGImage(String assetName) {
  return Svg(assetName);
}

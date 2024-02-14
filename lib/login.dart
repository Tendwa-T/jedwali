// ignore_for_file: prefer_const_constructors

import 'package:Jedwali/configs/constants.dart';
import 'package:Jedwali/views/custom_text.dart';
import 'package:Jedwali/views/custom_text_field.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  //For login

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                
                            Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Column(
                                  children: [
                                    CustomTextField(
                                      controller: _usernameController,
                                      label: "Username",
                                      hint: "Enter username",
                                      icon: Icons.person,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextField(
                                      controller: _passwordController,
                                      label: "Password",
                                      hint: "Enter your password",
                                      icon: Icons.lock,
                                      isPassword: true,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomText(label: "Forgot Password?"),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print("Resetting password...");
                                          },
                                          child: CustomText(
                                            label: "Reset password",
                                            labelColor: Colors.blue,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            print("Cancel");
                                            _passwordController.clear();
                                            _usernameController.clear();
                                          },
                                          style: TextButton.styleFrom(
                                              padding: EdgeInsets.all(8),
                                              elevation: 2,
                                              fixedSize: Size(100, 30),
                                              side: BorderSide()),
                                          child: Center(
                                            child: const Text("Cancel"),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            print("Sign IN");
                                            if (_usernameController.text ==
                                                "Admin") {
                                              if (_passwordController.text ==
                                                  "admin") {
                                                Navigator.of(context)
                                                    .pushNamed("/");
                                              } else {
                                                print(
                                                    "Wrong password: ${_passwordController.text}");
                                              }
                                            } else {
                                              print(
                                                  'Wrong username: ${_usernameController.text}');
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              foregroundColor: appWhite,
                                              elevation: 4,
                                              fixedSize: Size(100, 30)),
                                          child: const Text("Sign in"),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextField(
                                            controller: _firstNameController,
                                            label: "First Name",
                                            hint: "First name",
                                            icon: Icons.person,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: CustomTextField(
                                            controller: _lastNameController,
                                            label: "Last Name",
                                            hint: "Last name",
                                            icon: Icons.person,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextField(
                                      controller: _emailController,
                                      label: "Email",
                                      hint: "Enter your Email Address",
                                      icon: Icons.email,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextField(
                                      controller: _phoneNumberController,
                                      label: "Phone number",
                                      hint: "Enter your phone number",
                                      icon: Icons.call,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextField(
                                      controller: _passwordController,
                                      label: "Password",
                                      hint: "Enter your password",
                                      icon: Icons.lock,
                                      isPassword: true,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextField(
                                      controller: _confPassword,
                                      label: "Confirm Password",
                                      hint: "Re-enter your password",
                                      icon: Icons.lock,
                                      isPassword: true,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomText(
                                            label: "Already have an account?"),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print("Rerouting to login...");
                                          },
                                          child: CustomText(
                                            label: "Log In",
                                            labelColor: Colors.blue,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            print("Cancel");
                                            _firstNameController.clear();
                                            _confPassword.clear();
                                            _emailController.clear();
                                            _lastNameController.clear();
                                            _phoneNumberController.clear();
                                            _passwordController.clear();
                                          },
                                          style: TextButton.styleFrom(
                                              padding: EdgeInsets.all(8),
                                              elevation: 2,
                                              fixedSize: Size(100, 30),
                                              side: BorderSide()),
                                          child: Center(
                                            child: const Text("Cancel"),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            print("Account Created");
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              foregroundColor: appWhite,
                                              elevation: 4,
                                              fixedSize: Size(100, 30)),
                                          child: const Text("Sign Up"),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
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

import 'package:Jedwali/configs/constants.dart';
import 'package:Jedwali/widgets/custom_password_field.dart';
import 'package:Jedwali/widgets/custom_text.dart';
import 'package:Jedwali/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({
    super.key,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController emailController,
    required TextEditingController phoneNumberController,
    required TextEditingController passwordController,
    required TextEditingController confPassword,
  })  : _firstNameController = firstNameController,
        _lastNameController = lastNameController,
        _emailController = emailController,
        _phoneNumberController = phoneNumberController,
        _passwordController = passwordController,
        _confPassword = confPassword;

  final TextEditingController _firstNameController;
  final TextEditingController _lastNameController;
  final TextEditingController _emailController;
  final TextEditingController _phoneNumberController;
  final TextEditingController _passwordController;
  final TextEditingController _confPassword;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
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
            CustomPasswordField(
              controller: _passwordController,
              label: "Password",
              hint: "Enter your password",
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomPasswordField(
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
                const CustomText(label: "Already have an account?"),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    print("Rerouting to login...");
                  },
                  child: const CustomText(
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                      padding: const EdgeInsets.all(8),
                      elevation: 2,
                      fixedSize: const Size(100, 30),
                      side: const BorderSide()),
                  child: const Center(
                    child: Text("Cancel"),
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
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: appWhite,
                      elevation: 4,
                      fixedSize: const Size(100, 30)),
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
    );
  }
}

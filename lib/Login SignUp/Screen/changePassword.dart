import 'package:ckd_mobile/Login%20SignUp/Screen/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ckd_mobile/Widget/buttons.dart';
import 'package:ckd_mobile/Widget/textfield.dart';


class ChangePasswordScreen extends StatefulWidget {
  final String email;

  const ChangePasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  

  // Method to change the password
  Future<void> changePassword(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Get the current user
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Re-authenticate user with old password
          AuthCredential credential = EmailAuthProvider.credential(email: widget.email, password: oldPasswordController.text);
          await user.reauthenticateWithCredential(credential);

          // Update the user's password
          await user.updatePassword(newPasswordController.text);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password has been changed successfully.')),
          );
          // Navigate to the login screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()), // Update with your login screen class
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not found. Please log in again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to change password: $e')),
        );
        print('Failed to change password: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Old password field
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double maxWidth = constraints.maxWidth * 0.6;
                        return ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: TextfieldInpute(
                            textEditingController: oldPasswordController,
                            hintText: "Enter old password",
                            icon: Icons.lock,
                            isPass: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your old password';
                              }
                              return null;
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    // New password field
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double maxWidth = constraints.maxWidth * 0.6;
                        return ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: TextfieldInpute(
                            textEditingController: newPasswordController,
                            hintText: "Enter new password",
                            icon: Icons.lock,
                            isPass: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a new password';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              if (!RegExp(r'^[a-zA-Z]').hasMatch(value)) {
                                return 'Password must start with an alphabet';
                              }
                              if (!RegExp(r'[0-9]').hasMatch(value)) {
                                return 'Password must contain at least one number';
                              }
                              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                return 'Password must contain at least one uppercase letter';
                              }
                              if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                                return 'Password must contain at least one special character';
                              }
                              return null;
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    // Confirm new password field
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double maxWidth = constraints.maxWidth * 0.6;
                        return ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: TextfieldInpute(
                            textEditingController: confirmPasswordController,
                            hintText: "Confirm new password",
                            icon: Icons.lock,
                            isPass: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your new password';
                              }
                              if (value != newPasswordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                   LayoutBuilder(
                          builder: (context, constraints) {
                            double maxWidth = constraints.maxWidth * 0.6;
                            return ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                  child: Text(
                                    "* Password must be at least 8 characters\n"
                                    "* Password must start with an alphabet\n"
                                    "* Password must contain at least one number\n"
                                    "* Password must contain at least one uppercase letter\n"
                                    "* Password must contain at least one special character\n"
                                    "* Password should not be similar to the username",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    const SizedBox(height: 20),
                    // Change password button
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double maxWidth = constraints.maxWidth * 0.5;
                        return ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: MyButton(
                            onTab: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                changePassword(context);
                              }
                            },
                            text: "Change Password",
                          ),
                        );
                      },
                    ),
                    SizedBox(height: height / 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

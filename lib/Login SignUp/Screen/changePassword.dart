import 'package:ckd_mobile/Login%20SignUp/Screen/login.dart';
import 'package:ckd_mobile/Widget/passwordRequirements.dart';
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
  
  bool hasMinLength = false;
  bool startsWithAlphabet = false;
  bool hasNumber = false;
  bool hasUppercase = false;
  bool hasSpecialCharacter = false;
  bool notSimilarToUsername = false;

  void _checkPassword(String password) {
    setState(() {
      hasMinLength = password.length >= 8;
      startsWithAlphabet = RegExp(r'^[a-zA-Z]').hasMatch(password);
      hasNumber = RegExp(r'[0-9]').hasMatch(password);
      hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
      hasSpecialCharacter = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
      // Check if password is not similar to username
      notSimilarToUsername = !password.toLowerCase().contains(widget.email.toLowerCase());
    });
  }

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
                            onChanged: (value) {
                              _checkPassword(value);
                            },
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
                              if (!notSimilarToUsername) {
                                return 'Password cannot be similar to your email';
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
                            onChanged: (value) {
                              _checkPassword(value);
                            },
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
                    
                    // Password requirements
                    Center(
                      child: PasswordRequirements(
                        hasMinLength: hasMinLength,
                        startsWithAlphabet: startsWithAlphabet,
                        hasNumber: hasNumber,
                        hasUppercase: hasUppercase,
                        hasSpecialCharacter: hasSpecialCharacter,
                        notSimilarToUsername: notSimilarToUsername,
                      ),
                    ),
                    const SizedBox(height: 10),
                    
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

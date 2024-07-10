import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ckd_mobile/Login%20SignUp/Screen/home_Screen.dart';
import 'package:ckd_mobile/Login%20SignUp/signup.dart';
import 'package:ckd_mobile/Widget/buttons.dart';
import 'package:ckd_mobile/Widget/textfield.dart';
import 'changePassword.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isAuthenticated = false;

  Future<void> loginUser(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      String userId = userCredential.user!.uid;
      print('Authenticated User UID: $userId');

      DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
      DocumentSnapshot userSnapshot = await userDocRef.get();

      if (userSnapshot.exists) {
        Map<String, dynamic> firestoreData = userSnapshot.data() as Map<String, dynamic>;
        print('User data from Firestore: $firestoreData');

        emailController.clear();
        passwordController.clear();

        setState(() {
          isAuthenticated = true;
        });
        if(isAuthenticated){
          navigateToHomeScreen(context);
        }

        //Navigator.of(context).pop();
      } else {
        await FirebaseAuth.instance.signOut();
        print('User not found in Firestore.');
        throw Exception("User not found in Firestore.");
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        default:
          errorMessage = 'Failed to log in: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      print('FirebaseAuthException: ${e.message}');
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log in: $e')),
      );
      print('Exception: $e');
      Navigator.of(context).pop();
    }
  }

  void navigateToHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  Future<void> resetPassword(BuildContext context) async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email to reset password')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent. Check your email inbox.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send password reset email: $e')),
      );
      print('Failed to send password reset email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: height / 4.5,
                    child: Image.asset("images/login.jpeg"),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            double maxWidth = constraints.maxWidth * 0.6;
                            return ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: TextfieldInpute(
                                textEditingController: emailController,
                                hintText: "Enter your email",
                                icon: Icons.email,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an email';
                                  }
                                  if (RegExp(r'^[0-9]').hasMatch(value)) {
                                    return 'Email cannot start with a number';
                                  }
                                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@(gmail\.com|yahoo\.com|outlook\.com)$').hasMatch(value)) {
                                    return 'Please enter a valid email address (gmail.com, yahoo.com, outlook.com)';
                                  }
                                  return null;
                                },
                                hintStyle: TextStyle(fontSize: 14),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            double maxWidth = constraints.maxWidth * 0.6;
                            return ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: TextfieldInpute(
                                textEditingController: passwordController,
                                hintText: "Enter your password",
                                icon: Icons.lock,
                                isPass: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
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
                                hintStyle: TextStyle(fontSize: 14),
                              ),
                            );
                          },
                        ),
                       /* SizedBox(height: 10),
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
                        ),*/
                        GestureDetector(
                          onTap: () {
                            resetPassword(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 35),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            double maxWidth = constraints.maxWidth * 0.4;
                            return ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: MyButton(
                                onTab: () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    loginUser(context);
                                  }
                                },
                                text: "Log In",
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
            
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      " Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
      ),
    );

  }
}

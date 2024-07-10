import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ckd_mobile/Login%20SignUp/Screen/login.dart';
import '../Widget/buttons.dart';
import '../Widget/textfield.dart';
import '../Widget/passwordRequirements.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
      notSimilarToUsername = !password.contains(usernameController.text);
    });
  }

  Future<void> signUpAndSaveUser(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

   try {
      // Check if username is already in use
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Username is already in use
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The username is already in use. Please use another username.')),
        );
        usernameController.clear(); // Clear the username field if it already exists
        return;
      }

      // Check if email is already in use
      List<String> signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        // Email is already in use
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The email address is already in use. Please use another email address.')),
        );
        emailController.clear(); // Clear the email field if it already exists
        return;
      }

      // Create user with email and password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      // Save user info to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'username': username,
        'email': email,
        'created at': FieldValue.serverTimestamp(),
      });

      // Update user profile
      await userCredential.user?.updateProfile(displayName: username);

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      // Clear text fields after successful operation
      usernameController.clear();
      emailController.clear();
      passwordController.clear();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User registered successfully!')),
      );

      // Navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      String errorMessage;

      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        errorMessage = 'The email address is already in use. Please use another email address.';
        emailController.clear(); // Clear the email field for FirebaseAuthException
      } else {
        errorMessage = 'Failed to sign up: $e';
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < 5) {
      return 'Username must be at least 5 characters';
    }
    if (!RegExp(r'^[a-zA-Z]').hasMatch(value)) {
      return 'Username must start with an alphabet';
    }
    if (RegExp(r'[^\w]').hasMatch(value)) {
      return 'Username should not contain special characters';
    }
    if (!RegExp(r'^[a-zA-Z]{4}').hasMatch(value)) {
      return 'First four characters should be alphabets';
    }
    return null;
  }

  String? emailValidator(String? value) {
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
  }

  String? passwordValidator(String? value) {
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
    if (value.contains(usernameController.text)) {
      return 'Password should not be similar to the username';
    }
    return null;
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
                    child: Image.asset("images/signup.jpeg"),
                  ),
                  const SizedBox(height: 15),
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
                                textEditingController: usernameController,
                                hintText: "Enter your username",
                                icon: Icons.person,
                                validator: usernameValidator,
                                hintStyle: const TextStyle(fontSize: 14),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            double maxWidth = constraints.maxWidth * 0.6;
                            return ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: TextfieldInpute(
                                textEditingController: emailController,
                                hintText: "Enter your email",
                                icon: Icons.email,
                                validator: emailValidator,
                                hintStyle: const TextStyle(fontSize: 14),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
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
                                onChanged: _checkPassword,
                                validator: passwordValidator,
                                hintStyle: const TextStyle(fontSize: 14),
                              ),
                            );
                          },
                        ),
                         const SizedBox(height: 10),
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
                        LayoutBuilder(
                          builder: (context, constraints) {
                            double maxWidth = constraints.maxWidth * 0.4;
                            return ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: MyButton(
                                onTab: () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    signUpAndSaveUser(context);
                                  }
                                },
                                text: "Sign Up",
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height / 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          " Login",
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

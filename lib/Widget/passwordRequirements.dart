import 'package:flutter/material.dart';

class PasswordRequirements extends StatelessWidget {
  final bool hasMinLength;
  final bool startsWithAlphabet;
  final bool hasNumber;
  final bool hasUppercase;
  final bool hasSpecialCharacter;
  final bool notSimilarToUsername;

  const PasswordRequirements({
    Key? key,
    required this.hasMinLength,
    required this.startsWithAlphabet,
    required this.hasNumber,
    required this.hasUppercase,
    required this.hasSpecialCharacter,
    required this.notSimilarToUsername,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        PasswordRequirement(
          text: "Password must be at least 8 characters",
          isValid: hasMinLength,
        ),
        PasswordRequirement(
          text: "Password must start with an alphabet",
          isValid: startsWithAlphabet,
        ),
        PasswordRequirement(
          text: "Password must contain at least one number",
          isValid: hasNumber,
        ),
        PasswordRequirement(
          text: "Password must contain at least one uppercase letter",
          isValid: hasUppercase,
        ),
        PasswordRequirement(
          text: "Password must contain a special character",
          isValid: hasSpecialCharacter,
        ),
        PasswordRequirement(
          text: "Password should not be similar to the username",
          isValid: notSimilarToUsername,
        ),
      ],
    );
  }
}

class PasswordRequirement extends StatelessWidget {
  final String text;
  final bool isValid;

  const PasswordRequirement({
    Key? key,
    required this.text,
    required this.isValid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Add vertical padding for separation
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Center align vertically within each row
        children: [
          Icon(
            isValid ? Icons.check : Icons.close,
            color: isValid ? Colors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: isValid ? Colors.green : Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

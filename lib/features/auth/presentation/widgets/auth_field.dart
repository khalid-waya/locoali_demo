import 'package:flutter/material.dart';

/// A custom form field widget specifically designed for authentication screens.
///
/// This widget provides a standardized text input field with optional password visibility
/// toggle and consistent styling across the authentication flow.
class AuthField extends StatefulWidget {
  /// The placeholder text shown when the field is empty
  final String hintText;

  /// The icon displayed at the start of the text field
  final IconData prefixIcon;

  /// Determines if the field should behave as a password input
  /// If true, the text will be obscured and a visibility toggle button will be shown
  final bool isPassword;

  final TextEditingController controller;

  const AuthField(
      {super.key,
      required this.hintText,
      required this.prefixIcon,
      this.isPassword = false,
      required this.controller});

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  /// Controls the visibility of password text
  /// Only relevant when [isPassword] is true
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // Obscure text if this is a password field and _obscureText is true
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Icon(
          widget.prefixIcon,
          color: Colors.grey,
        ),
        // Show visibility toggle button only for password fields
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      validator: (value) {
        print('Validating field: ${widget.hintText}'); // Add debug print
        if (value == null || value.isEmpty) {
          return '${widget.hintText} is required';
        }
        return null;
      },
    );
  }
}

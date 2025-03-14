import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/device_constraints.dart';

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

  /// Controller for the text field
  final TextEditingController controller;

  /// Optional validator function
  final String? Function(String?)? validator;

  const AuthField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    required this.controller,
    this.validator, // Made optional by removing 'required' and adding '?'
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  /// Controls the visibility of password text
  /// Only relevant when [isPassword] is true
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive icon size - fixed size for large screens
    final iconSize = screenWidth > DeviceBreakpoints.iPadAir
        ? 24.0 // Fixed size for large screens
        : DeviceBreakpoints.getResponsiveDimension(context, 24.0);

    // Calculate responsive padding - fixed size for large screens
    final horizontalPadding = screenWidth > DeviceBreakpoints.iPadAir
        ? 16.0 // Fixed size for large screens
        : DeviceBreakpoints.getResponsiveDimension(context, 16.0);

    final verticalPadding = screenWidth > DeviceBreakpoints.iPadAir
        ? 12.0 // Fixed size for large screens
        : DeviceBreakpoints.getResponsiveDimension(context, 12.0);

    // Calculate field width - use iPhone 16 Pro Max width for large screens
    final fieldWidth = screenWidth > DeviceBreakpoints.iPadAir
        ? DeviceBreakpoints.iphoneProMax * 0.9 // 90% of iPhone 16 Pro Max width
        : screenWidth * 0.9; // 90% of screen width for smaller screens

    return SizedBox(
      width: fieldWidth,
      child: TextFormField(
        // Obscure text if this is a password field and _obscureText is true
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        style: TextStyle(
          fontSize: screenWidth > DeviceBreakpoints.iPadAir
              ? 16.0 // Fixed size for large screens
              : DeviceBreakpoints.getResponsiveDimension(context, 16.0),
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          contentPadding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          prefixIcon: Icon(
            widget.prefixIcon,
            color: Colors.grey,
            size: iconSize,
          ),
          // Show visibility toggle button only for password fields
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                    size: iconSize,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
        validator: widget.validator ??
            (value) {
              // Default validator if none provided
              if (value == null || value.isEmpty) {
                return '${widget.hintText} is required';
              }
              return null;
            },
      ),
    );
  }
}

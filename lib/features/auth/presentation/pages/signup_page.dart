import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.1, // 10% of screen height
          ),
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.7, // This will take 70% of the screen width
              child: AspectRatio(
                aspectRatio: 16 /
                    9, // Adjust this ratio based on your logo's aspect ratio
                child: Image.asset(
                    "assets/img/locoali_logo.png"), // Your existing Image widget goes here
                // Optionally add padding if needed
                // padding: EdgeInsets.symmetric(vertical: 20),
                // Optionally add a background color
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/app_typography.dart';
import 'package:locoali_demo/core/theme/color_pallete.dart';
import 'package:locoali_demo/core/theme/responsive_typography.dart';
import 'package:locoali_demo/features/auth/presentation/widgets/auth_field.dart';
import 'package:locoali_demo/features/auth/presentation/widgets/auth_gradient_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController(); // Add this line

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose(); // Add this line
    super.dispose();
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Form
            (
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.04, // 4% of screen height
                  ),
                  Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Get screen width
                        double screenWidth = MediaQuery.of(context).size.width;
              
                        // Adjust logo size based on screen width
                        double logoWidth;
                        if (screenWidth < 600) {
                          logoWidth = screenWidth * 0.6; // 60% for phones
                        } else if (screenWidth < 1200) {
                          logoWidth = screenWidth * 0.5; // 50% for tablets
                        } else {
                          logoWidth = screenWidth * 0.4; // 40% for desktop
                        }
              
                        return SizedBox(
                          width: logoWidth,
                          child: Image.asset(
                            "assets/img/locoali_logo.png",
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    ),
                  ),
                  Text("Create an Account").responsive(
                    mobileStyle: AppTypography.headlineMedium,
                    tabletStyle: AppTypography.headlineLarge,
                    desktopStyle: AppTypography.displaySmall,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Please fill in details to create an account").responsive(
                    mobileStyle: AppTypography.bodyMedium,
                    tabletStyle: AppTypography.bodyLarge,
                    desktopStyle: AppTypography.displaySmall,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04, // 10% height
                  ),
                  AuthField(
                    hintText: "Name",
                    prefixIcon: Icons.person_2_outlined,
                    controller: nameController,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01, // 10% height
                  ),
                  AuthField(
                    hintText: "Email",
                    prefixIcon: Icons.email_outlined,
                    controller: emailController,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01, // 10% height
                  ),
                  AuthField(
                    hintText: "Password",
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    controller: passwordController,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01, // 10% height
                  ),
                  AuthField(
                    hintText: "Confirm Password",
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    controller: confirmPasswordController ,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01, // 10% height
                  ),
                  AuthGradientButton(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01, // 10% height
                  ),
                  Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Or').responsive(
                          mobileStyle: AppTypography.bodyMedium,
                          tabletStyle: AppTypography.bodyLarge,
                          desktopStyle: AppTypography.bodyLarge,
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01, // 10% height
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: AppTypography.bodyLarge,
                      children: [
                        TextSpan(
                          text: "Sign In",
                          style: AppTypography.bodyLarge.copyWith(
                            color: ColorPalette.tertiary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
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

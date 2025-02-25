import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/app_typography.dart';
import 'package:locoali_demo/core/theme/color_pallete.dart';
import 'package:locoali_demo/core/theme/responsive_typography.dart';
import 'package:locoali_demo/features/auth/presentation/pages/signup_page.dart';
import 'package:locoali_demo/features/auth/presentation/widgets/auth_field.dart';
import 'package:locoali_demo/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:locoali_demo/features/auth/presentation/widgets/signin_google_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static routeName() => MaterialPageRoute(
        builder: (context) => SignupPage(),
      );

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignupPage()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Form(
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
                  Text("Welcome Back").responsive(
                    mobileStyle: AppTypography.headlineMedium,
                    tabletStyle: AppTypography.headlineLarge,
                    desktopStyle: AppTypography.displaySmall,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Use credentials to login").responsive(
                    mobileStyle: AppTypography.bodyMedium,
                    tabletStyle: AppTypography.bodyLarge,
                    desktopStyle: AppTypography.displaySmall,
                  ),
                  SizedBox(
                    height:
                        MediaQuery.of(context).size.height * 0.04, // 10% height
                  ),
                  AuthField(
                    hintText: "Email",
                    prefixIcon: Icons.email_outlined,
                    controller: emailController,
                  ),
                  SizedBox(
                    height:
                        MediaQuery.of(context).size.height * 0.01, // 10% height
                  ),
                  AuthField(
                    hintText: "Password",
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    controller: passwordController,
                  ),
                  SizedBox(
                    height:
                        MediaQuery.of(context).size.height * 0.01, // 10% height
                  ),
                  AuthGradientButton(
                    buttonText: "Login",
                    onPressed: () {},
                  ),
                  SizedBox(
                    height:
                        MediaQuery.of(context).size.height * 0.02, // 10% height
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate to the forgot password page
                        },
                        child: Text("Forgot Password?").responsive(
                          mobileStyle: AppTypography.bodyMedium,
                          tabletStyle: AppTypography.bodyLarge,
                          desktopStyle: AppTypography.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height:
                        MediaQuery.of(context).size.height * 0.01, // 10% height
                  ),
                  Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Or continue with').responsive(
                          mobileStyle: AppTypography.bodyMedium,
                          tabletStyle: AppTypography.bodyLarge,
                          desktopStyle: AppTypography.bodyLarge,
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  SizedBox(
                    height:
                        MediaQuery.of(context).size.height * 0.01, // 10% height
                  ),
                  SigninGoogleButton(),
                  SizedBox(
                    height:
                        MediaQuery.of(context).size.height * 0.03, // 10% height
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the login page
                      Navigator.pushReplacement(
                        context,
                        LoginPage.routeName(),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: AppTypography.bodyLarge,
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: AppTypography.bodyLarge.copyWith(
                              color: ColorPalette.tertiary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
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

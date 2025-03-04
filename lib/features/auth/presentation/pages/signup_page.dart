import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/app_typography.dart';
import 'package:locoali_demo/core/theme/color_pallete.dart';
import 'package:locoali_demo/core/theme/responsive_typography.dart';
import 'package:locoali_demo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:locoali_demo/features/auth/domain/usecases/signup_with_email.dart';
import 'package:locoali_demo/features/auth/presentation/pages/email_verification_page.dart';
import 'package:locoali_demo/features/auth/presentation/pages/login_page.dart';
import 'package:locoali_demo/features/auth/presentation/widgets/auth_field.dart';
import 'package:locoali_demo/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:locoali_demo/features/auth/presentation/widgets/signup_google_button.dart';
import 'package:locoali_demo/features/auth/domain/usecases/check_email_verified_usecase.dart';
import 'package:locoali_demo/features/auth/domain/usecases/send_verification_email_usecase.dart';
import 'package:locoali_demo/features/auth/domain/usecases/sign_out_usecase.dart';

/// A stateful widget that represents the signup page of the application.
/// This page allows users to create a new account by providing their details.
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  static routeName() => MaterialPageRoute(
        builder: (context) => LoginPage(),
      );
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Controllers for handling user input in text fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form key for form validation
  final formKey = GlobalKey<FormState>();

  late final SignupWithEmailUseCase _signupUseCase;
  late final CheckEmailVerifiedUseCase _checkEmailVerifiedUseCase;
  late final SendVerificationEmailUseCase _sendVerificationEmailUseCase;
  late final SignOutUseCase _signOutUseCase;

  bool _isLoading = false;

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final repository = AuthRepositoryImpl();
    _signupUseCase = SignupWithEmailUseCase(repository);
    _checkEmailVerifiedUseCase = CheckEmailVerifiedUseCase(repository);
    _sendVerificationEmailUseCase = SendVerificationEmailUseCase(repository);
    _signOutUseCase = SignOutUseCase(repository);
  }

  // Add this method to handle signup
  Future<void> _handleSignup() async {
    if (formKey.currentState == null) {
      // print('Form state is null!');
      return;
    }

    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });

      try {
        final result = await _signupUseCase.execute(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text,
        );

        if (!mounted) return;

        result.fold(
          (failure) {
            setState(() {
              _isLoading = false; // Stop loading on failure
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failure.message)),
            );
          },
          (success) {
            // Don't stop loading on success since we're navigating away
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EmailVerificationPage(
                  checkEmailVerifiedUseCase: _checkEmailVerifiedUseCase,
                  sendVerificationEmailUseCase: _sendVerificationEmailUseCase,
                  signOutUseCase: _signOutUseCase,
                ),
              ),
            );
          },
        );
      } catch (e) {
        if (!mounted) return;

        setState(() {
          _isLoading = false; // Stop loading on error
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('An error occurred during signup: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // Makes the form scrollable
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width *
                  0.05, // Responsive horizontal padding
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // Top spacing
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),

                  // Logo section with responsive sizing
                  Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Calculate logo size based on screen width
                        double screenWidth = MediaQuery.of(context).size.width;
                        double logoWidth = screenWidth < 600
                            ? screenWidth * 0.6 // Phone size
                            : screenWidth < 1200
                                ? screenWidth * 0.5 // Tablet size
                                : screenWidth * 0.4; // Desktop size

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

                  // Header text with responsive typography
                  Text("Create an Account").responsive(
                    mobileStyle: AppTypography.headlineMedium,
                    tabletStyle: AppTypography.headlineLarge,
                    desktopStyle: AppTypography.displaySmall,
                  ),

                  // Subheader text
                  SizedBox(
                    height: 10,
                  ),
                  Text("Please fill in details to create an account")
                      .responsive(
                    mobileStyle: AppTypography.bodyMedium,
                    tabletStyle: AppTypography.bodyLarge,
                    desktopStyle: AppTypography.displaySmall,
                  ),
                  SizedBox(
                    height:
                        MediaQuery.of(context).size.height * 0.04, // 10% height
                  ),

                  // Input fields section
                  // Name input field
                  AuthField(
                    hintText: "Name",
                    prefixIcon: Icons.person_2_outlined,
                    controller: nameController,
                  ),
                  SizedBox(
                    height:
                        MediaQuery.of(context).size.height * 0.01, // 10% height
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
                  AuthField(
                    hintText: "Confirm Password",
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    controller: confirmPasswordController,
                  ),
                  SizedBox(
                    height:
                        MediaQuery.of(context).size.height * 0.01, // 10% height
                  ),

                  // Sign up button
                  AuthGradientButton(
                    buttonText: "Sign Up",
                    onPressed: _handleSignup,
                    isLoading: _isLoading,
                  ),
                  SizedBox(
                    height:
                        MediaQuery.of(context).size.height * 0.01, // 10% height
                  ),

                  // Divider section with "Or" text
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
                    height:
                        MediaQuery.of(context).size.height * 0.01, // 10% height
                  ),

                  // Google sign up button
                  SignupGoogleButton(),

                  SizedBox(
                    height:
                        MediaQuery.of(context).size.height * 0.02, // 10% height
                  ),

                  // Sign in link for existing users
                  GestureDetector(
                    onTap: () {
                      // Navigate to the Signup  page
                      Navigator.pushReplacement(
                        context,
                        SignupPage.routeName(),
                      );
                    },
                    child: RichText(
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

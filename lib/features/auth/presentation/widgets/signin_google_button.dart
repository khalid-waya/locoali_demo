import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/app_typography.dart';
import 'package:locoali_demo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:locoali_demo/features/auth/domain/usecases/google_signin_usecase.dart';
import 'package:locoali_demo/features/home/presentation/pages/home_page.dart';

class SigninGoogleButton extends StatelessWidget {
  final GoogleSignInUseCase _googleSignInUseCase;

  SigninGoogleButton({super.key})
      : _googleSignInUseCase = GoogleSignInUseCase(AuthRepositoryImpl());

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final result = await _googleSignInUseCase.execute();

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(failure.message)));
        },
        (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final buttonWidth = (395 / 40) * screenSize.width;
    final buttonHeight = (55 / 932) * screenSize.height;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton.icon(
        onPressed: () => _handleGoogleSignIn(context),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: Size(buttonWidth, buttonHeight),
        ),
        icon: Image.asset(
          "assets/img/google_logo.png",
          height: 40,
        ),
        label: Text(
          "Continue with Google",
          style: AppTypography.authButton.copyWith(color: Colors.black),
        ),
      ),
    );
  }
}

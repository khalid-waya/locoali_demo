import 'package:flutter/material.dart';
import 'package:locoali_demo/core/theme/app_typography.dart';
import 'package:locoali_demo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:locoali_demo/features/auth/domain/usecases/google_signin_usecase.dart';
import 'package:locoali_demo/features/home/presentation/pages/home_page.dart';

class SignupGoogleButton extends StatelessWidget {
  final GoogleSignInUseCase _googleSignInUseCase;

  SignupGoogleButton({super.key})
      : _googleSignInUseCase = GoogleSignInUseCase(AuthRepositoryImpl());

  Future<void> _handleGoogleSignUp(BuildContext context) async {
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
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _handleGoogleSignUp(context),
      icon: Image.asset('assets/google.png', height: 24),
      label: Text(
        'Continue with Google',
        style: AppTypography.authButton,
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }
}

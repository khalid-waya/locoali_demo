import 'dart:async';
import 'package:flutter/material.dart';
import 'package:locoali_demo/features/auth/domain/usecases/check_email_verified_usecase.dart';
import 'package:locoali_demo/features/auth/domain/usecases/send_verification_email_usecase.dart';
import 'package:locoali_demo/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:locoali_demo/features/home/presentation/pages/home_page.dart';
import 'package:locoali_demo/features/auth/presentation/pages/login_page.dart';

class EmailVerificationPage extends StatefulWidget {
  final CheckEmailVerifiedUseCase checkEmailVerifiedUseCase;
  final SendVerificationEmailUseCase sendVerificationEmailUseCase;
  final SignOutUseCase signOutUseCase;

  const EmailVerificationPage({
    required this.checkEmailVerifiedUseCase,
    required this.sendVerificationEmailUseCase,
    required this.signOutUseCase,
    super.key,
  });

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = true;

  @override
  void initState() {
    super.initState();
    checkEmailVerified();
    timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => checkEmailVerified(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    final result = await widget.checkEmailVerifiedUseCase.execute();

    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        }
      },
      (isVerified) {
        setState(() {
          isEmailVerified = isVerified;
        });

        if (isVerified) {
          timer?.cancel();
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        }
      },
    );
  }

  Future<void> sendVerificationEmail() async {
    if (!canResendEmail) return;

    final result = await widget.sendVerificationEmailUseCase.execute();

    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        }
      },
      (_) {
        setState(() => canResendEmail = false);
        Future.delayed(const Duration(seconds: 60), () {
          if (mounted) setState(() => canResendEmail = true);
        });
      },
    );
  }

  Future<void> _handleSignOut() async {
    final result = await widget.signOutUseCase.execute();

    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        }
      },
      (_) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
        actions: [
          TextButton(
            onPressed: _handleSignOut,
            child: const Text('Cancel'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Click the button below and an email verification will be sent to your email address.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.email),
              label: const Text('Send Email'),
              onPressed: canResendEmail ? sendVerificationEmail : null,
            ),
          ],
        ),
      ),
    );
  }
}

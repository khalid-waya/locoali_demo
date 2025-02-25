// lib/core/success/success.dart
abstract class Success {
  final String message;
  const Success(this.message);
}

class AuthSuccess extends Success {
  final String uid;
  const AuthSuccess({required this.uid, required String message}) : super(message);
}
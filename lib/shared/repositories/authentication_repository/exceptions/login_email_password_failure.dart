class LoginWithEmailAndPasswordFailure {
  final String message;
  const LoginWithEmailAndPasswordFailure(
      [this.message = 'An Unknown error occurred']);

  factory LoginWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'invalid-email':
        return const LoginWithEmailAndPasswordFailure(
            'Email address is malformed.');
      case 'user-disabled':
        return const LoginWithEmailAndPasswordFailure(
            'user account has been disabled.');
      case 'user-not-found':
        return const LoginWithEmailAndPasswordFailure(
            'No user exists with the specified email address.');
      case 'wrong-password':
        return const LoginWithEmailAndPasswordFailure('Password is incorrect.');
      default:
        return const LoginWithEmailAndPasswordFailure();
    }
  }
}

class EditDetailsFailure {
  final String message;
  const EditDetailsFailure([this.message = 'An Unknown error occurred']);

  factory EditDetailsFailure.code(String code) {
    switch (code) {
      case 'invalid-email':
        return const EditDetailsFailure('Email address is malformed.');
      case 'user-disabled':
        return const EditDetailsFailure('user account has been disabled.');
      case 'email-already-in-use':
        return const EditDetailsFailure('this email is already in use.');
      case 'user-not-found':
        return const EditDetailsFailure(
            'No user exists with the specified email address.');
      case 'wrong-password':
        return const EditDetailsFailure('Password is incorrect.');
      default:
        return const EditDetailsFailure();
    }
  }
}

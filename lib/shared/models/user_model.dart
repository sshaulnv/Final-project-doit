class UserModel {
  final String? id;
  final String username;
  final String email;
  final String password;

  const UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "Password": password,
    };
  }
}

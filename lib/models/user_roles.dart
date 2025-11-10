enum UserRole {
  Person,
  Admin,
}

class User {
  final String name;
  final String email;
  final UserRole role;

  User({required this.name, required this.email, required this.role});
}

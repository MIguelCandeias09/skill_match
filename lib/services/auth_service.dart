class AuthService {
  static bool login(String email, String password) {
    // Mock login logic
    return email == 'admin@example.com' && password == 'password';
  }

  static bool register(String name, String email, String password) {
    // Mock registration logic
    return true;
  }
}

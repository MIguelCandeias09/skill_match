import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variáveis para guardar os dados na memória da app
  static String? _currentUserId;
  static String? _currentUserName;
  static String? _currentUserEmail; // <--- NOVO: Guardar o email

  // Getters para aceder aos dados
  static String? get userId => _currentUserId;
  static String? get userName => _currentUserName;
  static String? get userEmail => _currentUserEmail; // <--- NOVO
  static bool get isAuthenticated => _currentUserId != null;

  /// Login user
  static Future<bool> login(String email, String password) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return false;
      }

      final doc = querySnapshot.docs.first;
      _currentUserId = doc.id;
      _currentUserName = doc.data()['name'] ?? 'User';
      _currentUserEmail = email; // <--- NOVO: Guardar o email ao entrar
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  /// Register new user
  static Future<bool> register(
      String name, String email, String password) async {
    try {
      final docRef = await _firestore.collection('users').add({
        'name': name,
        'email': email,
        'rating': 0.0,
        'reviewCount': 0,
        'verified': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _currentUserId = docRef.id;
      _currentUserName = name;
      _currentUserEmail = email; // <--- NOVO: Guardar o email ao registar
      return true;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  static void logout() {
    _currentUserId = null;
    _currentUserName = null;
    _currentUserEmail = null;
  }
}
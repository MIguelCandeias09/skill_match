import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseAuthService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String? _currentUserId;
  static String? _currentUserName;

  static String? get userId => _currentUserId;
  static String? get userName => _currentUserName;
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
      return true;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  static void logout() {
    _currentUserId = null;
    _currentUserName = null;
  }
}

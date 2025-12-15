import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  // As ferramentas oficiais
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variáveis de memória (para a app saber quem está logado facilmente)
  static String? _currentUserName;
  static String? _currentUserRole; // 'user' ou 'admin'
  static List<String> _favoriteIds = []; // <--- LISTA DE FAVORITOS LOCAL

  // Getters simples para a tua UI usar
  static String? get userId => _auth.currentUser?.uid;
  static String? get userEmail => _auth.currentUser?.email;
  static String? get userName => _currentUserName ?? 'Utilizador';
  static bool get isAuthenticated => _auth.currentUser != null;
  static bool get isAdmin => _currentUserRole == 'admin';
  static List<String> get favoriteIds => _favoriteIds; // <--- GETTER DOS FAVORITOS

  /// LOGIN OFICIAL
  static Future<bool> login(String email, String password) async {
    try {
      // 1. Autenticar com segurança
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      // 2. Se correu bem, carregar dados extra (Nome, Role e Favoritos)
      if (cred.user != null) {
        await _fetchUserData(cred.user!.uid);
      }

      return true;
    } catch (e) {
      print('Erro no Login: $e');
      return false;
    }
  }

  /// REGISTO OFICIAL
  static Future<bool> register(String name, String email, String password) async {
    try {
      // 1. Criar a conta segura no Firebase Auth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      if (cred.user == null) return false;

      // 2. Guardar os dados do perfil no Firestore
      await _firestore.collection('users').doc(cred.user!.uid).set({
        'name': name,
        'email': email,
        'rating': 0.0,
        'reviewCount': 0,
        'verified': false,
        'role': 'user',
        'favorites': [], // <--- INICIALIZAR LISTA VAZIA
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3. Atualizar memória local imediatamente
      _currentUserName = name;
      _currentUserRole = 'user';
      _favoriteIds = [];

      return true;
    } catch (e) {
      print('Erro no Registo: $e');
      return false;
    }
  }

  /// LOGOUT
  static Future<void> logout() async {
    await _auth.signOut();
    _currentUserName = null;
    _currentUserRole = null;
    _favoriteIds = [];
  }

  /// CARREGAR DADOS DO UTILIZADOR (Privado)
  static Future<void> _fetchUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        _currentUserName = data['name'];
        _currentUserRole = data['role'];

        // Carregar a lista de favoritos (garantindo que é List<String>)
        if (data['favorites'] != null) {
          _favoriteIds = List<String>.from(data['favorites']);
        } else {
          _favoriteIds = [];
        }
      }
    } catch (e) {
      print('Erro ao carregar perfil: $e');
    }
  }

  /// MUDAR FAVORITO (Like / Dislike)
  static Future<void> toggleFavorite(String offerId) async {
    final uid = userId;
    if (uid == null) return;

    try {
      if (_favoriteIds.contains(offerId)) {
        // REMOVER: Se já gosta, tiramos da lista
        _favoriteIds.remove(offerId);
        await _firestore.collection('users').doc(uid).update({
          'favorites': FieldValue.arrayRemove([offerId])
        });
      } else {
        // ADICIONAR: Se não gosta, pomos na lista
        _favoriteIds.add(offerId);
        await _firestore.collection('users').doc(uid).update({
          'favorites': FieldValue.arrayUnion([offerId])
        });
      }
    } catch (e) {
      print('Erro ao mudar favorito: $e');
    }
  }
}
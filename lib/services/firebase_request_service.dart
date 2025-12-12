import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_auth_service.dart';

class FirebaseRequestService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Enviar um pedido de contacto
  static Future<bool> sendRequest({
    required String toUserId,
    required String toUserName,
    required String offerTitle,
  }) async {
    final currentUserId = FirebaseAuthService.userId;
    final currentUserName = FirebaseAuthService.userName;

    if (currentUserId == null) return false;

    try {
      await _firestore.collection('requests').add({
        'fromUserId': currentUserId,
        'fromUserName': currentUserName,
        'toUserId': toUserId,
        'toUserName': toUserName,
        'offerTitle': offerTitle,
        'status': 'pending', // pending, accepted, rejected
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Erro ao enviar pedido: $e');
      return false;
    }
  }

  /// Aceitar um pedido
  static Future<void> acceptRequest(String requestId) async {
    await _firestore.collection('requests').doc(requestId).update({
      'status': 'accepted',
    });
  }

  /// Recusar um pedido
  static Future<void> rejectRequest(String requestId) async {
    await _firestore.collection('requests').doc(requestId).update({
      'status': 'rejected',
    });
  }

  /// Obter pedidos (recebidos e enviados) em tempo real
  static Stream<QuerySnapshot> getRequestsStream() {
    final userId = FirebaseAuthService.userId;
    if (userId == null) return const Stream.empty();

    // Vamos buscar onde somos o destinatário (toUserId) OU o remetente (fromUserId)
    // Nota: O Firestore tem limitações com OR queries complexas,
    // para simplificar vamos buscar onde somos o destinatário (quem recebe o pedido)
    return _firestore
        .collection('requests')
        .where('toUserId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
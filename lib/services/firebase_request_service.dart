import 'dart:async';
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
  /// Combina dois streams para evitar a necessidade de índices compostos complexos
  static Stream<List<QueryDocumentSnapshot>> getRequestsStream() {
    final userId = FirebaseAuthService.userId;
    if (userId == null) return Stream.value([]);

    late StreamController<List<QueryDocumentSnapshot>> controller;
    List<QueryDocumentSnapshot> received = [];
    List<QueryDocumentSnapshot> sent = [];
    StreamSubscription? sub1;
    StreamSubscription? sub2;

    controller = StreamController<List<QueryDocumentSnapshot>>(
      onListen: () {
        void updateController() {
          if (controller.isClosed) return;
          final combined = [...received, ...sent];
          // Ordenar manualmente por data
          combined.sort((a, b) {
            final dataA = a.data() as Map<String, dynamic>;
            final dataB = b.data() as Map<String, dynamic>;
            final t1 = dataA['createdAt'] as Timestamp?;
            final t2 = dataB['createdAt'] as Timestamp?;
            if (t1 == null) return -1;
            if (t2 == null) return 1;
            return t2.compareTo(t1); // Descending
          });
          controller.add(combined);
        }

        sub1 = _firestore
            .collection('requests')
            .where('toUserId', isEqualTo: userId)
            // .orderBy('createdAt', descending: true) // Removido para evitar erro de índice
            .snapshots()
            .listen((snapshot) {
          received = snapshot.docs;
          updateController();
        }, onError: (e) {
          if (!controller.isClosed) controller.addError(e);
        });

        sub2 = _firestore
            .collection('requests')
            .where('fromUserId', isEqualTo: userId)
            // .orderBy('createdAt', descending: true) // Removido para evitar erro de índice
            .snapshots()
            .listen((snapshot) {
          sent = snapshot.docs;
          updateController();
        }, onError: (e) {
          if (!controller.isClosed) controller.addError(e);
        });
      },
      onCancel: () {
        sub1?.cancel();
        sub2?.cancel();
      },
    );

    return controller.stream;
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Adiciona esta linha se tiveres o pacote intl, senão remove a formatação da data
import '../../services/firebase_request_service.dart';

class MessagesTab extends StatelessWidget {
  const MessagesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseRequestService.getRequestsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mark_email_unread_outlined, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text('Sem pedidos de contacto',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16)),
              ],
            ),
          );
        }

        final requests = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final req = requests[index];
            final data = req.data() as Map<String, dynamic>;
            final status = data['status'] ?? 'pending';
            final isPending = status == 'pending';

            // Definir cores e ícones com base no estado
            Color statusColor;
            IconData statusIcon;
            String statusText;

            switch (status) {
              case 'accepted':
                statusColor = Colors.green;
                statusIcon = Icons.check_circle;
                statusText = 'Aceite';
                break;
              case 'rejected':
                statusColor = Colors.red;
                statusIcon = Icons.cancel;
                statusText = 'Recusado';
                break;
              default:
                statusColor = Colors.orange;
                statusIcon = Icons.access_time_filled;
                statusText = 'Pendente';
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              shadowColor: Colors.black.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFE5D4FF),
                          child: Text(
                            (data['fromUserName'] ?? 'U')[0].toUpperCase(),
                            style: const TextStyle(color: Color(0xFF8A4FFF), fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['fromUserName'] ?? 'Utilizador',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                'Interessado em: ${data['offerTitle']}',
                                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(statusIcon, size: 14, color: statusColor),
                              const SizedBox(width: 4),
                              Text(statusText,
                                  style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    if (isPending) ...[
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => FirebaseRequestService.rejectRequest(req.id),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                              ),
                              child: const Text('Recusar'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => FirebaseRequestService.acceptRequest(req.id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8A4FFF),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Aceitar'),
                            ),
                          ),
                        ],
                      ),
                    ] else if (status == 'accepted') ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Futuro: Abrir chat real
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Chat em breve!')),
                            );
                          },
                          icon: const Icon(Icons.chat, size: 18),
                          label: const Text('Enviar Mensagem'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
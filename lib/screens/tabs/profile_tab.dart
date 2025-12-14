import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase_auth_service.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  double _rating = 0.0;
  int _reviewCount = 0;
  int _offersCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfileData();
  }

  Future<void> _loadUserProfileData() async {
    final userId = FirebaseAuthService.userId;
    final userName = FirebaseAuthService.userName;

    if (userId == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final offersQuery = await FirebaseFirestore.instance
          .collection('offers')
          .where('userName', isEqualTo: userName)
          .get();

      if (mounted) {
        setState(() {
          if (userDoc.exists) {
            final data = userDoc.data()!;
            _rating = (data['rating'] ?? 0.0).toDouble();
            _reviewCount = (data['reviewCount'] ?? 0).toInt();
          }
          _offersCount = offersQuery.docs.length;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = FirebaseAuthService.userName ?? 'Convidado';
    final email = FirebaseAuthService.userEmail ?? 'Sem email';

    String getInitials(String name) {
      if (name.isEmpty) return 'U';
      List<String> names = name.split(" ");
      String initials = "";
      if (names.isNotEmpty) initials += names[0][0];
      if (names.length > 1) initials += names[names.length - 1][0];
      return initials.toUpperCase();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        // Garante que o conteúdo não ultrapassa 800px e fica centrado
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              // Cabeçalho do Perfil
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFFE5D4FF),
                child: Text(
                  getInitials(name),
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF8A4FFF)),
                ),
              ),
              const SizedBox(height: 16),
              Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(email, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),

              // Estatísticas
              _isLoading
                  ? const CircularProgressIndicator()
                  : Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat(_rating.toStringAsFixed(1), 'Rating'),
                    _buildStat(_reviewCount.toString(), 'Reviews'),
                    _buildStat(_offersCount.toString(), 'Ofertas'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // MENU DE OPÇÕES (Botões Largos)
              // Agora são cartões bonitos em vez de linhas simples
              _buildMenuOption(Icons.person_outline, 'Editar Perfil'),
              _buildMenuOption(Icons.favorite_border, 'Favoritos'),
              _buildMenuOption(Icons.settings_outlined, 'Definições'),
              _buildMenuOption(Icons.help_outline, 'Ajuda'),

              const SizedBox(height: 24), // Espaço extra antes de sair

              _buildMenuOption(Icons.logout, 'Terminar Sessão',
                color: Colors.red,
                isLogout: true,
                onTap: () {
                  FirebaseAuthService.logout();
                  context.go('/login');
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8A4FFF))),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }

  // Função melhorada para criar botões com aspeto de "Cartão"
  Widget _buildMenuOption(IconData icon, String label, {Color? color, VoidCallback? onTap, bool isLogout = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Espaço entre botões
      decoration: BoxDecoration(
        color: isLogout ? const Color(0xFFFFF0F0) : Colors.white, // Fundo vermelho claro para logout
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: isLogout ? Border.all(color: Colors.red.withValues(alpha: .2)) : null,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (color ?? const Color(0xFF8A4FFF)).withValues(alpha: .1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color ?? const Color(0xFF8A4FFF), size: 20),
        ),
        title: Text(
            label,
            style: TextStyle(
              color: color ?? const Color(0xFF1A1A1A),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            )
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap ?? () {},
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
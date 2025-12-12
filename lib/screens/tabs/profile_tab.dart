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

    if (userId == null) return;

    try {
      // 1. Buscar dados do utilizador (Rating e Reviews)
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // 2. Contar quantas ofertas este utilizador tem
      // Nota: Estamos a procurar pelo Nome porque a criação antiga não guardava ID
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
      print("Erro ao carregar perfil: $e");
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
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFFE5D4FF),
            child: Text(
              getInitials(name),
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8A4FFF)
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            email,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),

          // Estatísticas Dinâmicas
          _isLoading
              ? const CircularProgressIndicator()
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat(_rating.toStringAsFixed(1), 'Rating'),
              _buildStat(_reviewCount.toString(), 'Reviews'),
              _buildStat(_offersCount.toString(), 'Ofertas'),
            ],
          ),

          const SizedBox(height: 32),

          _buildMenuOption(Icons.person_outline, 'Editar Perfil'),
          _buildMenuOption(Icons.favorite_border, 'Favoritos'),
          _buildMenuOption(Icons.settings_outlined, 'Definições'),
          _buildMenuOption(Icons.help_outline, 'Ajuda'),
          const Divider(height: 32),
          _buildMenuOption(Icons.logout, 'Terminar Sessão',
            color: Colors.red,
            onTap: () {
              FirebaseAuthService.logout();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8A4FFF))),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildMenuOption(IconData icon, String label, {Color? color, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFF1A1A1A)),
      title: Text(label, style: TextStyle(color: color ?? const Color(0xFF1A1A1A), fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap ?? () {},
      contentPadding: EdgeInsets.zero,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/firebase_auth_service.dart';
import '../../theme/app_theme.dart';
import '../favorites_screen.dart'; // <--- Importante: Importar o ecrã de favoritos

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obter dados do serviço
    final user = FirebaseAuthService.userName ?? 'Utilizador';
    final email = FirebaseAuthService.userEmail ?? 'email@exemplo.com';
    final favCount = FirebaseAuthService.favoriteIds.length; // Contagem de favoritos

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // === AVATAR E NOME ===
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 50, color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
              user,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
          ),
          Text(
              email,
              style: TextStyle(color: Colors.grey[600])
          ),

          const SizedBox(height: 40),

          // === SECÇÃO DE DEFINIÇÕES ===
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha(12),
                    blurRadius: 10
                )
              ],
            ),
            child: Column(
              children: [
                // Opção 1: Editar Perfil
                ListTile(
                  leading: const Icon(Icons.person_outline, color: AppTheme.primaryColor),
                  title: const Text('Editar Perfil'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Futuro: Navegar para editar perfil
                  },
                ),

                const Divider(height: 1),

                // Opção 2: FAVORITOS (A funcionar)
                ListTile(
                  leading: const Icon(Icons.favorite_border, color: AppTheme.primaryColor),
                  title: const Text('Favoritos'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Badge com número se tiver favoritos
                      if (favCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B9D),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                              '$favCount',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)
                          ),
                        ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                  onTap: () {
                    // Navegar para o ecrã de favoritos
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                    );
                  },
                ),

                const Divider(height: 1),

                // Opção 3: Definições
                ListTile(
                  leading: const Icon(Icons.settings_outlined, color: AppTheme.primaryColor),
                  title: const Text('Definições'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // === BOTÃO LOGOUT ===
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                FirebaseAuthService.logout();
                context.go('/'); // Voltar para o Login
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Terminar Sessão', style: TextStyle(color: Colors.red)),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red.withAlpha(12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),

          const SizedBox(height: 40), // Espaço extra no fundo
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../services/firebase_auth_service.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback onExploreTap;

  const HomeTab({Key? key, required this.onExploreTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Buscar o nome guardado
    final fullName = FirebaseAuthService.userName ?? 'Visitante';
    final firstName = fullName.split(' ')[0];

    // 2. Calcular a altura da barra de estado (onde estão as horas/bateria)
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return SingleChildScrollView(
      padding: EdgeInsets.zero, // Remove padding padrão se houver
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de Boas-vindas
          Container(
            width: double.infinity,
            // 3. AQUI ESTÁ A CORREÇÃO DO ESPAÇAMENTO:
            // Usamos EdgeInsets.fromLTRB para somar a altura da barra (+24px de margem)
            padding: EdgeInsets.fromLTRB(24, statusBarHeight + 24, 24, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8A4FFF), Color(0xFF6B3FCC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá, $firstName! 👋',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'O que queres aprender hoje?',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                    // Foto de perfil pequena no canto (opcional, fica bonito)
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Color(0xFF8A4FFF)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Botão de Pesquisa
                GestureDetector(
                  onTap: onExploreTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search, color: Color(0xFF8A4FFF)),
                        SizedBox(width: 12),
                        Text('Pesquisar guitarra, inglês...',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Categorias
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text('Categorias Populares',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryItem(Icons.music_note, 'Música', Colors.orange),
                _buildCategoryItem(Icons.code, 'Tech', Colors.blue),
                _buildCategoryItem(Icons.palette, 'Arte', Colors.pink),
                _buildCategoryItem(Icons.fitness_center, 'Desporto', Colors.green),
                _buildCategoryItem(Icons.language, 'Idiomas', Colors.purple),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Banner Promocional
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE5D4FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Torna-te Premium 🌟',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF4A2F99))),
                      const SizedBox(height: 4),
                      const Text('Destaque as suas ofertas e encontre matches mais rápido!',
                          style: TextStyle(color: Color(0xFF6B3FCC))),
                    ],
                  ),
                ),
                const Icon(Icons.rocket_launch, size: 40, color: Color(0xFF8A4FFF)),
              ],
            ),
          ),

          // Espaço extra no fundo para não ficar colado
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
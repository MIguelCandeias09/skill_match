import 'package:flutter/material.dart';
// Certifica-te que este caminho está correto para o teu projeto
import '../../services/firebase_auth_service.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback onExploreTap;

  const HomeTab({Key? key, required this.onExploreTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fullName = FirebaseAuthService.userName ?? 'Visitante';
    final firstName = fullName.split(' ')[0];
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // Detetar Web/Tablet
    final isWeb = MediaQuery.of(context).size.width > 600;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment:
        isWeb ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          // 1. HEADER ROXO
          Container(
            width: double.infinity,
            // EdgeInsets não pode ser const aqui porque usa statusBarHeight
            padding: EdgeInsets.fromLTRB(24, statusBarHeight + 24, 24, 40),
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
              crossAxisAlignment:
              isWeb ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                if (isWeb)
                // Layout Web
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Text(
                          firstName.isNotEmpty ? firstName[0] : 'U',
                          style: const TextStyle(
                              fontSize: 24,
                              color: Color(0xFF8A4FFF),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Olá, $firstName! 👋',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'O que queres aprender hoje?',
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    ],
                  )
                else
                // Layout Mobile
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
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'O que queres aprender hoje?',
                            style:
                            TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Text(
                          firstName.isNotEmpty ? firstName[0] : 'U',
                          style: const TextStyle(
                              color: Color(0xFF8A4FFF),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 32),

                // Barra de Pesquisa
                SizedBox(
                  width: isWeb ? 500 : double.infinity,
                  child: GestureDetector(
                    onTap: onExploreTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Color(0xFF8A4FFF)),
                          SizedBox(width: 12),
                          Text('Pesquisar guitarra, inglês...',
                              style:
                              TextStyle(color: Colors.grey, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Título Categorias
          // ADICIONADO: const no Padding e no Text
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Categorias Populares',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 2. LISTA DE CATEGORIAS
          if (isWeb)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    _buildCategoryItem(
                        Icons.music_note, 'Música', Colors.orange, isWeb),
                    _buildCategoryItem(Icons.code, 'Tech', Colors.blue, isWeb),
                    _buildCategoryItem(
                        Icons.palette, 'Arte', Colors.pink, isWeb),
                    _buildCategoryItem(
                        Icons.fitness_center, 'Desporto', Colors.green, isWeb),
                    _buildCategoryItem(
                        Icons.language, 'Idiomas', Colors.purple, isWeb),
                    _buildCategoryItem(
                        Icons.camera_alt, 'Foto', Colors.red, isWeb),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryItem(
                      Icons.music_note, 'Música', Colors.orange, false),
                  _buildCategoryItem(Icons.code, 'Tech', Colors.blue, false),
                  _buildCategoryItem(Icons.palette, 'Arte', Colors.pink, false),
                  _buildCategoryItem(
                      Icons.fitness_center, 'Desporto', Colors.green, false),
                  _buildCategoryItem(
                      Icons.language, 'Idiomas', Colors.purple, false),
                ],
              ),
            ),

          const SizedBox(height: 40),

          // 3. BANNER PROMOCIONAL
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE5D4FF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ADICIONADO: const na lista de children
                      children: [
                        Text('Torna-te Premium 🌟',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color(0xFF4A2F99))),
                        SizedBox(height: 8),
                        Text(
                            'Destaque as suas ofertas e encontre matches mais rápido!',
                            style: TextStyle(
                                color: Color(0xFF6B3FCC),
                                fontSize: 15,
                                height: 1.4)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    // ADICIONADO: const no Icon
                    child: const Icon(Icons.rocket_launch,
                        size: 32, color: Color(0xFF8A4FFF)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
      IconData icon, String label, Color color, bool isWeb) {
    final double iconSize = isWeb ? 32 : 28;
    final double padding = isWeb ? 20 : 16;

    return Container(
      margin: isWeb ? EdgeInsets.zero : const EdgeInsets.only(right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              boxShadow: isWeb
                  ? [
                BoxShadow(
                    color: color.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ]
                  : null,
            ),
            child: Icon(icon, color: color, size: iconSize),
          ),
          const SizedBox(height: 12),
          // ADICIONADO: const no Text, mas removido o fontWeight do const se quiseres flexibilidade
          Text(label,
              style:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Importa as tabs que já criaste nas pastas certas
import 'tabs/home_tab.dart';
import 'tabs/explore_tab.dart';
import 'tabs/messages_tab.dart';
import 'tabs/profile_tab.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({Key? key}) : super(key: key);

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  int _selectedIndex = 0;

  // Chave Global para aceder à função 'refreshOffers' dentro da ExploreTab
  final GlobalKey<ExploreTabState> _exploreTabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Títulos da AppBar para cada ecrã (o Início fica vazio porque tem banner)
    final titles = ['', 'Explorar', 'Mensagens', 'Perfil'];

    return Scaffold(
      // A AppBar só aparece se não estivermos na aba Início (index 0)
      appBar: _selectedIndex == 0
          ? null
          : AppBar(
        title: Text(titles[_selectedIndex]),
        automaticallyImplyLeading: false, // Remove a seta de voltar automática
        actions: _selectedIndex == 1 // Botão do mapa apenas na aba Explorar
            ? [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () => context.push('/map'),
          ),
        ]
            : null,
      ),

      // IndexedStack mantém as abas vivas em memória (não perdes o scroll nem o texto)
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF8A4FFF).withValues(alpha: 0.03),
              Colors.white,
            ],
          ),
        ),
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            // Aba 0: Início
            HomeTab(onExploreTap: () => setState(() => _selectedIndex = 1)),

            // Aba 1: Explorar (Passamos a chave aqui para poder recarregar a lista depois)
            ExploreTab(key: _exploreTabKey),

            // Aba 2: Mensagens
            const MessagesTab(),

            // Aba 3: Perfil
            const ProfileTab(),
          ],
        ),
      ),

      // Botão Flutuante (+ Nova Oferta) apenas no Início e Explorar
      floatingActionButton: (_selectedIndex <= 1)
          ? FloatingActionButton.extended(
        onPressed: () async {
          // Navega para o ecrã de criar e espera pelo resultado (true/false)
          final result = await context.push('/create-offer');

          // Se a oferta foi criada com sucesso (result == true)
          if (result == true) {
            setState(() => _selectedIndex = 1); // Força a mudança para a aba Explorar
            _exploreTabKey.currentState?.refreshOffers(); // Chama a função pública para recarregar dados
          }
        },
        label: const Text('Nova Oferta', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_rounded),
        elevation: 4,
      )
          : null,

      // Menu de Navegação Inferior
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: const Color(0xFF8A4FFF),
          unselectedItemColor: const Color(0xFF9E9E9E),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Início'),
            BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: 'Explorar'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: 'Mensagens'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
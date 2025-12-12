import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Importa as novas Tabs (nota os '..' porque agora estão numa subpasta)
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
  final GlobalKey<ExploreTabState> _exploreTabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final titles = ['', 'Explorar', 'Mensagens', 'Perfil'];

    return Scaffold(
      appBar: _selectedIndex == 0
          ? null
          : AppBar(
        title: Text(titles[_selectedIndex]),
        automaticallyImplyLeading: false,
        actions: _selectedIndex == 1
            ? [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () => context.push('/map'),
          ),
        ]
            : null,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF8A4FFF).withOpacity(0.03),
              Colors.white,
            ],
          ),
        ),
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeTab(onExploreTap: () => setState(() => _selectedIndex = 1)),
            ExploreTab(key: _exploreTabKey),
            const MessagesTab(),
            const ProfileTab(),
          ],
        ),
      ),
      floatingActionButton: (_selectedIndex <= 1)
          ? FloatingActionButton.extended(
        onPressed: () async {
          final result = await context.push('/create-offer');
          if (result == true) {
            setState(() => _selectedIndex = 1);
            _exploreTabKey.currentState?.refreshOffers();
          }
        },
        label: const Text('Nova Oferta', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_rounded),
        elevation: 4,
      )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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
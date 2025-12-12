import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  // Dados do Carrossel Informativo
  final List<Map<String, dynamic>> _slides = [
    {
      'title': 'Troca de Talentos',
      'desc': 'Ensina o que sabes, aprende o que amas.\nSem dinheiro envolvido.',
      'icon': Icons.swap_horiz_rounded,
    },
    {
      'title': 'Encontra Mentores',
      'desc': 'Descobre pessoas perto de ti dispostas\na partilhar conhecimento.',
      'icon': Icons.map_rounded,
    },
    {
      'title': 'Evolui na Carreira',
      'desc': 'Melhora o teu currículo com novas skills\nvalidadas pela comunidade.',
      'icon': Icons.rocket_launch_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Auto-scroll do carrossel a cada 4 segundos
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _slides.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutQuart,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Altura do ecrã para cálculos responsivos
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Fundo com Gradiente e Formas
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF8A4FFF), // Roxo Principal
                  Color(0xFF6B3FCC), // Roxo Escuro
                ],
              ),
            ),
          ),
          // Círculos decorativos de fundo
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            left: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF6B9D).withOpacity(0.15),
              ),
            ),
          ),

          // 2. Conteúdo Principal
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Logo e Nome da App
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.handshake_rounded,
                        color: Color(0xFF8A4FFF),
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Skill Match',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // 3. Carrossel de Informação (PageView)
                SizedBox(
                  height: 300,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int index) {
                      setState(() => _currentPage = index);
                    },
                    itemCount: _slides.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              _slides[index]['icon'],
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            _slides[index]['title'],
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              _slides[index]['desc'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Indicadores de Página (As bolinhas)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color(0xFFFF6B9D) // Rosa ativo
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // 4. Botões de Ação (Bottom Sheet Style)
                Container(
                  padding: const EdgeInsets.all(32),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Botão Principal: Começar (Registo)
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => context.push('/register'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8A4FFF),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Começar Agora',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Botão Secundário: Login
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () => context.push('/login'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF8A4FFF), width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Já tenho conta',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8A4FFF),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
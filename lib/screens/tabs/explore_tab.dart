import 'package:flutter/material.dart';
import '../../services/firebase_offer_service.dart';
import '../../services/firebase_request_service.dart';
import '../../models/offer_model.dart';
import '../../widgets/common_widgets.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({Key? key}) : super(key: key);

  @override
  State<ExploreTab> createState() => ExploreTabState();
}

class ExploreTabState extends State<ExploreTab> {
  late Future<List<Offer>> _offersFuture;

  // Variável de estado para saber qual o filtro ativo
  String _selectedCategory = 'Todos';

  @override
  void initState() {
    super.initState();
    refreshOffers();
  }

  void refreshOffers() {
    setState(() {
      // Passamos a categoria selecionada para o serviço
      _offersFuture =
          FirebaseOfferService.getOffers(category: _selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Detetar Web/Tablet
    final isWeb = MediaQuery.of(context).size.width > 600;
    // Largura máxima de 780px
    final contentWidth = isWeb ? 780.0 : double.infinity;

    return Column(
      children: [
        // 1. BARRA DE PESQUISA
        Center(
          child: Container(
            width: contentWidth,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Procurar habilidades...',
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF8A4FFF)),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8A4FFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        const Icon(Icons.tune, color: Colors.white, size: 20),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ),
          ),
        ),

        // 2. FILTROS
        if (isWeb)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Center(
              child: SizedBox(
                width: contentWidth,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: _buildFilterChips(),
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _buildFilterChips(),
            ),
          ),

        const SizedBox(height: 8),

        // 3. GRELHA DE RESULTADOS
        Expanded(
          child: FutureBuilder<List<Offer>>(
            future: _offersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.filter_list_off,
                          size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'Sem ofertas de "$_selectedCategory"',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      if (_selectedCategory != 'Todos')
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = 'Todos';
                              refreshOffers();
                            });
                          },
                          child: const Text('Ver tudo'),
                        ),
                    ],
                  ),
                );
              }

              final offers = snapshot.data!;

              return RefreshIndicator(
                onRefresh: () async => refreshOffers(),
                child: isWeb
                    ? GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 320,
                        ),
                        itemCount: offers.length,
                        itemBuilder: (context, index) =>
                            _buildOfferItem(context, offers[index]),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: offers.length,
                        itemBuilder: (context, index) =>
                            _buildOfferItem(context, offers[index]),
                      ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Gera os botões de categoria
  List<Widget> _buildFilterChips() {
    final categories = [
      'Todos',
      'Música',
      'Desporto',
      'Idiomas',
      'Arte',
      'Tecnologia'
    ];

    return categories.map((category) {
      final isSelected = _selectedCategory == category;
      return Container(
        margin: const EdgeInsets.only(right: 6),
        child: FilterChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedCategory = category;
              refreshOffers(); // <--- ISTO CHAMA O FIREBASE COM O FILTRO
            });
          },
          backgroundColor: Colors.white,
          selectedColor: const Color(0xFF8A4FFF),
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          showCheckmark: false,
        ),
      );
    }).toList();
  }

  Widget _buildOfferItem(BuildContext context, Offer offer) {
    return OfferCard(
      userName: offer.userName,
      verified: offer.verified,
      distance: offer.distance,
      rating: offer.rating,
      reviews: offer.reviews,
      offering: offer.offering,
      lookingFor: offer.lookingFor,
      onContactTap: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('A enviar pedido...'),
              duration: Duration(seconds: 1)),
        );

        final success = await FirebaseRequestService.sendRequest(
          toUserId: offer.userId,
          toUserName: offer.userName,
          offerTitle: offer.offering,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(success
                  ? 'Pedido enviado com sucesso!'
                  : 'Erro ao enviar pedido.'),
              backgroundColor: success ? const Color(0xFF8A4FFF) : Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }
}

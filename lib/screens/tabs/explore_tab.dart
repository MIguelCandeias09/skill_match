import 'package:flutter/material.dart';
import '../../services/firebase_offer_service.dart';
import '../../models/offer_model.dart';
import '../../widgets/common_widgets.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({Key? key}) : super(key: key);

  @override
  State<ExploreTab> createState() => ExploreTabState();
}

class ExploreTabState extends State<ExploreTab> {
  late Future<List<Offer>> _offersFuture;

  @override
  void initState() {
    super.initState();
    _offersFuture = FirebaseOfferService.getOffers();
  }

  void refreshOffers() =>
      setState(() => _offersFuture = FirebaseOfferService.getOffers());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra de Pesquisa
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Procurar habilidades...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF8A4FFF)),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8A4FFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: 20),
                ),
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),
        ),

        // Filtros Rápidos
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildCategoryChip('Todos', true),
              _buildCategoryChip('Música', false),
              _buildCategoryChip('Desporto', false),
              _buildCategoryChip('Idiomas', false),
              _buildCategoryChip('Arte', false),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Lista de Ofertas
        Expanded(
          child: FutureBuilder<List<Offer>>(
            future: _offersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Nenhuma oferta disponível'));
              }

              final offers = snapshot.data!;
              return RefreshIndicator(
                onRefresh: () async => refreshOffers(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    final offer = offers[index];
                    return OfferCard(
                      userName: offer.userName,
                      verified: offer.verified,
                      distance: offer.distance,
                      rating: offer.rating,
                      reviews: offer.reviews,
                      offering: offer.offering,
                      lookingFor: offer.lookingFor,
                      onContactTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Pedido enviado para ${offer.userName}!'),
                            backgroundColor: const Color(0xFF8A4FFF),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {},
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF8A4FFF),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
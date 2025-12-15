import 'package:flutter/material.dart';
import '../services/firebase_offer_service.dart';
import '../services/firebase_auth_service.dart'; // <--- Para saber quais são os favoritos
import '../models/offer_model.dart';
import '../widgets/common_widgets.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    // 1. Obter a lista de IDs favoritos da memória
    final myFavoritesIds = FirebaseAuthService.favoriteIds;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos ❤️'),
        centerTitle: true,
      ),
      body: myFavoritesIds.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Ainda não tens favoritos.',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      )
          : FutureBuilder<List<Offer>>(
        // 2. Carregar as ofertas (numa app real fariamos uma query "whereIn",
        // mas aqui carregamos tudo e filtramos para simplificar)
        future: FirebaseOfferService.getOffers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) return const SizedBox();

          // 3. Filtrar apenas as que estão na nossa lista de favoritos
          final favoriteOffers = snapshot.data!
              .where((offer) => myFavoritesIds.contains(offer.id))
              .toList();

          if (favoriteOffers.isEmpty) {
            return const Center(child: Text('As ofertas favoritas já não existem.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteOffers.length,
            itemBuilder: (context, index) {
              final offer = favoriteOffers[index];
              return OfferCard(
                userName: offer.userName,
                verified: offer.verified,
                distance: offer.distance,
                rating: offer.rating,
                reviews: offer.reviews,
                offering: offer.offering,
                lookingFor: offer.lookingFor,
                isFavorite: true, // Aqui é sempre verdade
                onFavoriteTap: () async {
                  // Remover dos favoritos
                  await FirebaseAuthService.toggleFavorite(offer.id);
                  setState(() {}); // Atualizar o ecrã para remover o cartão
                },
              );
            },
          );
        },
      ),
    );
  }
}
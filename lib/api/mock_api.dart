import 'dart:convert';
import '../models/offer_model.dart';

class MockAPI {
  static List<Map<String, String>> offers = [
    {
      'offer': 'Guitar Lessons',
      'exchange': 'Cooking Classes',
    },
    {
      'offer': 'Painting Lessons',
      'exchange': 'Yoga Classes',
    },
  ];

  static final List<Offer> _offerModels = [
    Offer(
      id: '1',
      userId: 'user1',
      userName: 'Ana Silva',
      offering: 'Aulas de Guitarra',
      offeringDescription: 'Ensino guitarra há 5 anos',
      offeringCategory: 'Música',
      lookingFor: 'Culinária',
      lookingForCategory: 'Culinária',
      location: 'Lisboa, Portugal',
      distance: 1.2,
      rating: 4.8,
      reviews: 24,
      verified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Offer(
      id: '2',
      userId: 'user2',
      userName: 'Pedro Santos',
      offering: 'Design Gráfico',
      offeringDescription: 'Designer profissional com experiência',
      offeringCategory: 'Arte',
      lookingFor: 'Fotografia',
      lookingForCategory: 'Arte',
      location: 'Porto, Portugal',
      distance: 2.5,
      rating: 4.9,
      reviews: 31,
      verified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  static List<Map<String, double>> locations = [
    {
      'latitude': 37.7749,
      'longitude': -122.4194,
    },
    {
      'latitude': 34.0522,
      'longitude': -118.2437,
    },
  ];

  static String getOffers() {
    return jsonEncode(offers);
  }

  static String getLocations() {
    return jsonEncode(locations);
  }

  static void addOffer(String offer, String exchange) {
    offers.add({'offer': offer, 'exchange': exchange});
  }

  static List<Offer> getOffersAsModels() {
    return List.from(_offerModels);
  }

  static void addOfferModel(Offer offer) {
    _offerModels.add(offer);
  }
}

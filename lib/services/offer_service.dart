import '../api/mock_api.dart';

class OfferService {
  static List<Map<String, String>> getOffers() {
    return MockAPI.offers;
  }

  static void createOffer(String offer, String exchange) {
    MockAPI.addOffer(offer, exchange);
  }
}

  }

  static void addOffer(String offer, String exchange) {
    offers.add({'offer': offer, 'exchange': exchange});
  }
}
import 'dart:convert';

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

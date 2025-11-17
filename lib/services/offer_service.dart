import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_config.dart';
import '../models/offer_model.dart';
import 'auth_service.dart';

class OfferService {
  /// Fetches all offers from the backend
  static Future<List<Offer>> getOffers() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.offersUrl),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Offer.fromJson(json)).toList();
      } else {
        print('Get offers error: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Get offers exception: $e');
      return [];
    }
  }

  /// Creates a new offer
  static Future<bool> createOffer(Offer offer) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.offersUrl),
        headers: ApiConfig.headers,
        body: jsonEncode({
          'offering': offer.offering,
          'offeringDescription': offer.offeringDescription,
          'offeringCategory': offer.offeringCategory,
          'lookingFor': offer.lookingFor,
          'lookingForCategory': offer.lookingForCategory,
          'location': offer.location,
          'distance': offer.distance,
          'userId': AuthService.userId ?? '1',
          'userName': AuthService.userName ?? 'Utilizador',
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Create offer error: $e');
      return false;
    }
  }

  /// Deletes an offer by ID
  static Future<bool> deleteOffer(String offerId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.offersUrl}/$offerId'),
        headers: ApiConfig.headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Delete offer error: $e');
      return false;
    }
  }
}

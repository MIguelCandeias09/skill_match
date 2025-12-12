import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/offer_model.dart';
import 'firebase_auth_service.dart';

class FirebaseOfferService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches all offers from Firestore
  static Future<List<Offer>> getOffers() async {
    try {
      final querySnapshot = await _firestore
          .collection('offers')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Offer(
          id: doc.id,
          userId: doc.id,
          userName: data['userName'] ?? 'User',
          offering: data['offering'] ?? '',
          offeringDescription: data['offeringDescription'] ?? '',
          offeringCategory: data['offeringCategory'] ?? 'Outro',
          lookingFor: data['lookingFor'] ?? '',
          lookingForCategory: data['lookingForCategory'] ?? 'Outro',
          location: data['location'] ?? '',
          distance: (data['distance'] ?? 0).toDouble(),
          rating: (data['rating'] ?? 0).toDouble(),
          reviews: data['reviews'] ?? 0,
          verified: data['verified'] ?? false,
          createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
        );
      }).toList();
    } catch (e) {
      print('Get offers error: $e');
      return [];
    }
  }

  /// Creates a new offer
  static Future<bool> createOffer(Offer offer) async {
    try {
      await _firestore.collection('offers').add({
        'userId': FirebaseAuthService.userId,
        'userName': FirebaseAuthService.userName ?? 'User',
        'offering': offer.offering,
        'offeringDescription': offer.offeringDescription,
        'offeringCategory': offer.offeringCategory,
        'lookingFor': offer.lookingFor,
        'lookingForCategory': offer.lookingForCategory,
        'location': offer.location,
        'distance': offer.distance,
        'rating': 0.0,
        'reviews': 0,
        'verified': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Create offer error: $e');
      return false;
    }
  }

  /// Deletes an offer by ID
  static Future<bool> deleteOffer(String offerId) async {
    try {
      await _firestore.collection('offers').doc(offerId).delete();
      return true;
    } catch (e) {
      print('Delete offer error: $e');
      return false;
    }
  }
}

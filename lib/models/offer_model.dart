import 'package:freezed_annotation/freezed_annotation.dart';

part 'offer_model.freezed.dart';
part 'offer_model.g.dart';

@freezed
class Offer with _$Offer {
  const factory Offer({
    required String id,
    required String userId,
    required String userName,
    required String offering,
    required String offeringDescription,
    required String offeringCategory,
    required String lookingFor,
    required String lookingForCategory,
    required String location,
    @Default(0.0) double distance,
    @Default(0.0) double rating,
    @Default(0) int reviews,
    @Default(false) bool verified,
    DateTime? createdAt,
  }) = _Offer;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OfferImpl _$$OfferImplFromJson(Map<String, dynamic> json) => _$OfferImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      offering: json['offering'] as String,
      offeringDescription: json['offeringDescription'] as String,
      offeringCategory: json['offeringCategory'] as String,
      lookingFor: json['lookingFor'] as String,
      lookingForCategory: json['lookingForCategory'] as String,
      location: json['location'] as String,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: (json['reviews'] as num?)?.toInt() ?? 0,
      verified: json['verified'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$OfferImplToJson(_$OfferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'offering': instance.offering,
      'offeringDescription': instance.offeringDescription,
      'offeringCategory': instance.offeringCategory,
      'lookingFor': instance.lookingFor,
      'lookingForCategory': instance.lookingForCategory,
      'location': instance.location,
      'distance': instance.distance,
      'rating': instance.rating,
      'reviews': instance.reviews,
      'verified': instance.verified,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

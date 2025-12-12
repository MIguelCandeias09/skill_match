// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Offer _$OfferFromJson(Map<String, dynamic> json) {
  return _Offer.fromJson(json);
}

/// @nodoc
mixin _$Offer {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get offering => throw _privateConstructorUsedError;
  String get offeringDescription => throw _privateConstructorUsedError;
  String get offeringCategory => throw _privateConstructorUsedError;
  String get lookingFor => throw _privateConstructorUsedError;
  String get lookingForCategory => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  double get distance => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviews => throw _privateConstructorUsedError;
  bool get verified => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Offer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OfferCopyWith<Offer> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OfferCopyWith<$Res> {
  factory $OfferCopyWith(Offer value, $Res Function(Offer) then) =
      _$OfferCopyWithImpl<$Res, Offer>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String offering,
      String offeringDescription,
      String offeringCategory,
      String lookingFor,
      String lookingForCategory,
      String location,
      double distance,
      double rating,
      int reviews,
      bool verified,
      DateTime? createdAt});
}

/// @nodoc
class _$OfferCopyWithImpl<$Res, $Val extends Offer>
    implements $OfferCopyWith<$Res> {
  _$OfferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? offering = null,
    Object? offeringDescription = null,
    Object? offeringCategory = null,
    Object? lookingFor = null,
    Object? lookingForCategory = null,
    Object? location = null,
    Object? distance = null,
    Object? rating = null,
    Object? reviews = null,
    Object? verified = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      offering: null == offering
          ? _value.offering
          : offering // ignore: cast_nullable_to_non_nullable
              as String,
      offeringDescription: null == offeringDescription
          ? _value.offeringDescription
          : offeringDescription // ignore: cast_nullable_to_non_nullable
              as String,
      offeringCategory: null == offeringCategory
          ? _value.offeringCategory
          : offeringCategory // ignore: cast_nullable_to_non_nullable
              as String,
      lookingFor: null == lookingFor
          ? _value.lookingFor
          : lookingFor // ignore: cast_nullable_to_non_nullable
              as String,
      lookingForCategory: null == lookingForCategory
          ? _value.lookingForCategory
          : lookingForCategory // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviews: null == reviews
          ? _value.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as int,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OfferImplCopyWith<$Res> implements $OfferCopyWith<$Res> {
  factory _$$OfferImplCopyWith(
          _$OfferImpl value, $Res Function(_$OfferImpl) then) =
      __$$OfferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String offering,
      String offeringDescription,
      String offeringCategory,
      String lookingFor,
      String lookingForCategory,
      String location,
      double distance,
      double rating,
      int reviews,
      bool verified,
      DateTime? createdAt});
}

/// @nodoc
class __$$OfferImplCopyWithImpl<$Res>
    extends _$OfferCopyWithImpl<$Res, _$OfferImpl>
    implements _$$OfferImplCopyWith<$Res> {
  __$$OfferImplCopyWithImpl(
      _$OfferImpl _value, $Res Function(_$OfferImpl) _then)
      : super(_value, _then);

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? offering = null,
    Object? offeringDescription = null,
    Object? offeringCategory = null,
    Object? lookingFor = null,
    Object? lookingForCategory = null,
    Object? location = null,
    Object? distance = null,
    Object? rating = null,
    Object? reviews = null,
    Object? verified = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$OfferImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      offering: null == offering
          ? _value.offering
          : offering // ignore: cast_nullable_to_non_nullable
              as String,
      offeringDescription: null == offeringDescription
          ? _value.offeringDescription
          : offeringDescription // ignore: cast_nullable_to_non_nullable
              as String,
      offeringCategory: null == offeringCategory
          ? _value.offeringCategory
          : offeringCategory // ignore: cast_nullable_to_non_nullable
              as String,
      lookingFor: null == lookingFor
          ? _value.lookingFor
          : lookingFor // ignore: cast_nullable_to_non_nullable
              as String,
      lookingForCategory: null == lookingForCategory
          ? _value.lookingForCategory
          : lookingForCategory // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviews: null == reviews
          ? _value.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as int,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OfferImpl implements _Offer {
  const _$OfferImpl(
      {required this.id,
      required this.userId,
      required this.userName,
      required this.offering,
      required this.offeringDescription,
      required this.offeringCategory,
      required this.lookingFor,
      required this.lookingForCategory,
      required this.location,
      this.distance = 0.0,
      this.rating = 0.0,
      this.reviews = 0,
      this.verified = false,
      this.createdAt});

  factory _$OfferImpl.fromJson(Map<String, dynamic> json) =>
      _$$OfferImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String offering;
  @override
  final String offeringDescription;
  @override
  final String offeringCategory;
  @override
  final String lookingFor;
  @override
  final String lookingForCategory;
  @override
  final String location;
  @override
  @JsonKey()
  final double distance;
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int reviews;
  @override
  @JsonKey()
  final bool verified;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Offer(id: $id, userId: $userId, userName: $userName, offering: $offering, offeringDescription: $offeringDescription, offeringCategory: $offeringCategory, lookingFor: $lookingFor, lookingForCategory: $lookingForCategory, location: $location, distance: $distance, rating: $rating, reviews: $reviews, verified: $verified, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfferImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.offering, offering) ||
                other.offering == offering) &&
            (identical(other.offeringDescription, offeringDescription) ||
                other.offeringDescription == offeringDescription) &&
            (identical(other.offeringCategory, offeringCategory) ||
                other.offeringCategory == offeringCategory) &&
            (identical(other.lookingFor, lookingFor) ||
                other.lookingFor == lookingFor) &&
            (identical(other.lookingForCategory, lookingForCategory) ||
                other.lookingForCategory == lookingForCategory) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviews, reviews) || other.reviews == reviews) &&
            (identical(other.verified, verified) ||
                other.verified == verified) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      userName,
      offering,
      offeringDescription,
      offeringCategory,
      lookingFor,
      lookingForCategory,
      location,
      distance,
      rating,
      reviews,
      verified,
      createdAt);

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OfferImplCopyWith<_$OfferImpl> get copyWith =>
      __$$OfferImplCopyWithImpl<_$OfferImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OfferImplToJson(
      this,
    );
  }
}

abstract class _Offer implements Offer {
  const factory _Offer(
      {required final String id,
      required final String userId,
      required final String userName,
      required final String offering,
      required final String offeringDescription,
      required final String offeringCategory,
      required final String lookingFor,
      required final String lookingForCategory,
      required final String location,
      final double distance,
      final double rating,
      final int reviews,
      final bool verified,
      final DateTime? createdAt}) = _$OfferImpl;

  factory _Offer.fromJson(Map<String, dynamic> json) = _$OfferImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String get offering;
  @override
  String get offeringDescription;
  @override
  String get offeringCategory;
  @override
  String get lookingFor;
  @override
  String get lookingForCategory;
  @override
  String get location;
  @override
  double get distance;
  @override
  double get rating;
  @override
  int get reviews;
  @override
  bool get verified;
  @override
  DateTime? get createdAt;

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OfferImplCopyWith<_$OfferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

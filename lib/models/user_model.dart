import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    String? profileImageUrl,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    @Default(false) bool verified,
    @Default([]) List<String> favorites, // Lista de IDs das ofertas favoritas
    DateTime? createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';

@freezed
class UserDTO with _$UserDTO {
  const factory UserDTO({
    required String name,
    required String avatarURL,
  }) = _UserDTO;

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      name: json['login'] as String,
      avatarURL: json['avatar_url'] as String,
    );
  }
}

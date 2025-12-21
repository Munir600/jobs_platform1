import 'User.dart';

class ProfileResponse {
  final User user;
  final dynamic profile;

  ProfileResponse({
    required this.user,
    this.profile,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      user: User.fromJson(json['user']),
      profile: json['profile'],
    );
  }
}

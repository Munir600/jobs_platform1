import 'User.dart';

class ProfileResponse {
  final User user;
  final dynamic profile; // Can be EmployerProfile or JobSeekerProfile

  ProfileResponse({
    required this.user,
    this.profile,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      user: User.fromJson(json['user']),
      profile: json['profile'], // We'll handle parsing this in the controller/service based on user type
    );
  }
}

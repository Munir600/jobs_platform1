class UserModel {
  final String username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? userType;
  final String? profilePicture;
  final String? bio;
  final String? location;

  UserModel({
    required this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.userType,
    this.profilePicture,
    this.bio,
    this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      userType: json['user_type'],
      profilePicture: json['profile_picture'],
      bio: json['bio'],
      location: json['location'],
    );
  }
}

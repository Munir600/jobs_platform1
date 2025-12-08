class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String userType;
  final String phone;
  final String? dateOfBirth;
  final String? profilePicture;
  final String? bio;
  final String? location;
  final bool isVerified;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.phone,
    this.dateOfBirth,
    this.profilePicture,
    this.bio,
    this.location,
    required this.isVerified,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      userType: json['user_type'],
      phone: json['phone'],
      dateOfBirth: json['date_of_birth'],
      profilePicture: json['profile_picture'],
      bio: json['bio'],
      location: json['location'],
      isVerified: json['is_verified'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'user_type': userType,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'profile_picture': profilePicture,
      'bio': bio,
      'location': location,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get fullName => '$firstName $lastName';
  bool get isJobSeeker => userType == 'job_seeker';
  bool get isEmployer => userType == 'employer';
  bool get isAdmin => userType == 'admin';
}

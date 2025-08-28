
class UserModel {
  final String username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? userType;

  UserModel({required this.username,required this.email, this.firstName, this.lastName,required this.phone,required this.userType});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      userType: json['user_type'],
    );
  }
}

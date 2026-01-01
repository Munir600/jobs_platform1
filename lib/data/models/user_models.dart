// lib/models/user_models.dart
export 'accounts/User.dart';
export 'accounts/EmployerProfile.dart';
export 'accounts/JobSeekerProfile.dart';

class UserRegistration {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String passwordConfirm;
  final String userType;
  final String phone;

  UserRegistration({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.passwordConfirm,
    required this.userType,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'password_confirm': passwordConfirm,
      'user_type': userType,
      'phone': phone,
    };
  }
}

class UserLogin {
  final String phone;
  final String password;

  UserLogin({
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'password': password,
    };
  }
}

class UserProfileUpdate {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? dateOfBirth;
  final String? profilePicture;
  final String? bio;
  final String? location;

  UserProfileUpdate({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.dateOfBirth,
    this.profilePicture,
    this.bio,
    this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'profile_picture': profilePicture,
      'bio': bio,
      'location': location,
    }..removeWhere((key, value) => value == null);
  }
}

class PasswordChange {
  final String oldPassword;
  final String newPassword;
  final String newPasswordConfirm;

  PasswordChange({
    required this.oldPassword,
    required this.newPassword,
    required this.newPasswordConfirm,
  });

  Map<String, dynamic> toJson() {
    return {
      'old_password': oldPassword,
      'new_password': newPassword,
      'new_password_confirm': newPasswordConfirm,
    };
  }
}

class PasswordResetRequest {
  final String phone;

  PasswordResetRequest({required this.phone});

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
    };
  }
}

class PasswordResetConfirm {
  final String phone;
  final String verificationCode;
  final String newPassword;
  final String newPasswordConfirm;

  PasswordResetConfirm({
    required this.phone,
    required this.verificationCode,
    required this.newPassword,
    required this.newPasswordConfirm,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'verification_code': verificationCode,
      'new_password': newPassword,
      'new_password_confirm': newPasswordConfirm,
    };
  }
}

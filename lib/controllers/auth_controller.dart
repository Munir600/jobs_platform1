// lib/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jobs_platform1/core/utils/error_handler.dart';
import '../core/api_service.dart';
import '../core/constants.dart';
import '../data/models/user_models.dart';
import '../routes/app_routes.dart';
import '../view/screens/main_screen.dart';
import 'account/AccountController.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find();
  final GetStorage _storage = GetStorage();
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxString erro_verifyPhone = ''.obs;
  final Rx<User?> _currentUser = Rx<User?>(null);
  String? _tempPassword;

  final firstName = ''.obs;
  final lastName = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final dateOfBirth = ''.obs;
  final profilePicture = ''.obs;
  final bio = ''.obs;
  final location = ''.obs;
  final userType = ''.obs;
  final isVerified = false.obs;
  final createdAt = ''.obs;
  User? get currentUser => _currentUser.value;
  bool get isJobSeeker => _currentUser.value?.userType == 'job_seeker';
  bool get isEmployer => _currentUser.value?.userType == 'employer';

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }



  Future<bool> login(String phone, String password) async {
    try {
      isLoading.value = true;
      _tempPassword = password;
      final userLogin = UserLogin(phone: phone, password: password);
      print("JSON SENT TO API: ${userLogin.toJson()}");
      final response = await _apiService.post(
          ApiEndpoints.login,
          userLogin.toJson()
      );
      print("RESPONSE FROM API: $response");
      print("The USERTYPE  FROM API: ${response["data"]["user"]["user_type"]}");
      _currentUser.value = User.fromJson(response["data"]["user"]
      );
      _storage.write('user_data', response["data"]["user"]);
     // final token = '';
      final token = response["data"]["token"];
      final refreshToken=response["data"]["refresh"];
      print('the refresh token is : $refreshToken');
      final ms=response["data"]["message"];
      print('MESSAGES login  FROM API is : $ms');
      _apiService.setAuthToken(token);
      _apiService.setRefreshToken(refreshToken);
      print('TOKEN SET IN API SERVICE After Login: $token');
      
      // final bool verified = response["data"]["user"]["is_verified"] ?? false;
      // print('the response is_verified is :${response["data"]["user"]["is_verified"]}');
      // if (!verified) {
      //   isLoading.value = false;
      //   AppErrorHandler.showErrorSnack('يجب التحقق من رقم الهاتف اولا');
      //   Get.toNamed(AppRoutes.verifyPhone, arguments: phone);
      //   return false;
      // }
      isLoggedIn.value = true;
      isLoading.value = false;
      
      if (Get.isRegistered<AccountController>()) {
        Get.find<AccountController>().fetchProfile();
      }
      AppErrorHandler.showSuccessSnack('$ms');
      return true;
    } catch (e) {
      print('the error login is : $e');
      isLoading.value = false;
      AppErrorHandler.showErrorSnack('$e');
      final String errorStr = e.toString();
      if (errorStr.contains('يجب التحقق من رقم الهاتف')) {
        Get.toNamed(
          AppRoutes.verifyPhone,
          arguments: {
            'phone': phone,
            'canResendImmediately': true,
          },
        );
      }
      return false;
    }
  }

  Future<bool> register(UserRegistration registration) async {
    try {
      isLoading.value = true;
      print('DATA SENT TO API: ${registration.toJson()}');
      final response = await _apiService.post(
        ApiEndpoints.register,
        registration.toJson(),
      );
      isLoading.value = false;
      Get.toNamed(AppRoutes.verifyPhone, arguments: registration.phone);
      String ms=response['data']['message']??''.toString();
      print('the message response after register is : $ms');
      print('the response register body is : ${response['data']}');
      AppErrorHandler.showSuccessSnack(ms);
      return true;
    } catch (e) {
      isLoading.value = false;
      print('ERROR register: $e');
      AppErrorHandler.showErrorSnack('$e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post(ApiEndpoints.logout, {});
      AppErrorHandler.showSuccessSnack('تم تسجيل الخروج بنجاح');
    } catch (e) {
     //AppErrorHandler.showErrorSnack('$e');
      print('ERROR during logout API call: $e');
    } finally {
      // Clear local auth state
      _currentUser.value = null;
      isLoggedIn.value = false;
      _storage.remove('user_data');
      _storage.remove(AppConstants.authTokenKey);
      _storage.remove(AppConstants.RefreshToken);
      if (Get.isRegistered<AccountController>()) {
        Get.find<AccountController>().clearUserData();
      }
      Get.offAllNamed('/login');
    }
  }
  void _loadUserFromStorage() {
    final stored = _storage.read('user_data');
    final token = _storage.read(AppConstants.authTokenKey);

    if (stored != null && token != null) {
      _apiService.setAuthToken(token);
      final user = User.fromJson(stored);
      _currentUser.value = user;
      firstName.value = user.firstName;
      lastName.value = user.lastName;
      email.value = user.email;
      phone.value = user.phone;
      dateOfBirth.value = user.dateOfBirth ?? '';
      profilePicture.value = user.profilePicture ?? '';
      bio.value = user.bio ?? '';
      location.value = user.location ?? '';
      userType.value = user.userType;
      isVerified.value = user.isVerified;
      createdAt.value = user.createdAt.toIso8601String();
      isLoggedIn.value = true;
    }
  }

  Future<bool> updateProfile(UserProfileUpdate profile) async {
    try {
      isLoading.value = true;

      final data = profile.toJson();
      final response = await _apiService.put(ApiEndpoints.updateProfile, data);

      final updatedUser = User.fromJson(response['data']['user']);
      _currentUser.value = updatedUser;

      _storage.write('user_data', response['data']['user']);
      firstName.value = updatedUser.firstName;
      lastName.value = updatedUser.lastName;
      email.value = updatedUser.email;
      phone.value = updatedUser.phone;
      dateOfBirth.value = updatedUser.dateOfBirth ?? '';
      profilePicture.value = updatedUser.profilePicture ?? '';
      bio.value = updatedUser.bio ?? '';
      location.value = updatedUser.location ?? '';
      userType.value = updatedUser.userType;
      isVerified.value = updatedUser.isVerified;
      createdAt.value = updatedUser.createdAt.toIso8601String();
      isLoading.value = false;
      AppErrorHandler.showSuccessSnack('تم تحديث الملف الشخصي بنجاح');
      return true;

    } catch (e) {
      isLoading.value = false;
      print("ERROR updateProfile: $e");
      AppErrorHandler.showErrorSnack('$e');

      return false;
    }
  }

  Future<bool> changePassword(PasswordChange passwordChange) async {
    try {
      isLoading.value = true;

      await _apiService.post(
        ApiEndpoints.changePassword,
        passwordChange.toJson(),
      );

      isLoading.value = false;
      AppErrorHandler.showSuccessSnack('تم تغيير كلمة المرور بنجاح');
      return true;
    } catch (e) {
      isLoading.value = false;
      AppErrorHandler.showErrorSnack(e);
      return false;
    }
  }

  Future<bool> resetPasswordRequest(String phone) async {
    try {
      isLoading.value = true;
      final response = await _apiService.post(
        ApiEndpoints.resetPasswordRequest,
        {"phone": phone},
      );
      isLoading.value = false;
      String ms = response['data']?['message'] ?? 'تم ارسال كود التحقق ';
      print('the response resetPasswordRequest is : $response');
      AppErrorHandler.showSuccessSnack(ms);
      return true;
    } catch (e) {
      isLoading.value = false;
      print('ERROR resetPasswordRequest: $e');
      AppErrorHandler.showErrorSnack(e);
      return false;
    }
  }

  Future<bool> resetPasswordConfirm(PasswordResetConfirm data) async {
    try {
      isLoading.value = true;
      final response = await _apiService.post(
        ApiEndpoints.resetPasswordConfirm,
        data.toJson(),
      );
      isLoading.value = false;
      String ms = response['data']?['message'] ?? 'تم تغيير كلمة المرور بنجاح';
      print('the response resetPasswordConfirm is : $response');
      AppErrorHandler.showSuccessSnack(ms);
      return true;
    } catch (e) {
      isLoading.value = false;
      print('ERROR resetPasswordConfirm: $e');
      AppErrorHandler.showErrorSnack(e);
      return false;
    }
  }


  Future<bool> verifyPhone(String phone, String code) async {
    try {
      isLoading.value = true;
      final response = await _apiService.post(
        ApiEndpoints.verifyPhone,
        {
          "phone": phone,
          "verification_code": code
        },
      );
      print('VERIFY PHONE RESPONSE: $response');
      isLoading.value = false;
      String ms=response['data']['message']??'تم التحقق بنجاح'.toString();
      AppErrorHandler.showSuccessSnack(ms);
      final ok = await login(phone, _tempPassword!);
      if (ok) {
        Get.offAll(() => MainScreen());
        return true;
      }
      _tempPassword = null;
      return true;
    } catch (e) {
      isLoading.value = false;
      erro_verifyPhone.value = e.toString();
      print('ERROR erro_verifyPhone is: ${erro_verifyPhone.value}');
      AppErrorHandler.showErrorSnack(e);
      return false;
    }
  }

  Future<bool> resendVerificationCode(String phone) async {
    try {
      isLoading.value = true;
      final response = await _apiService.post(
        ApiEndpoints.resendVerificationCode,
        {
          "phone": phone
        },
      );

      isLoading.value = false;
      final message = response['data']['message'] ?? 'تم إعادة إرسال الكود';

      AppErrorHandler.showSuccessSnack(message);
      return true;
    } catch (e) {
      isLoading.value = false;
      print('error in resendVerificationCode: $e');
      AppErrorHandler.showErrorSnack(e);
      return false;
    }
  }
  
}
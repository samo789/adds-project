import 'package:ads_app/core/data/repository/auth_repository.dart';
import 'package:ads_app/core/services/local_storage_service.dart';
import 'package:ads_app/ui/screens/bottom_navigation_screen.dart';
import 'package:ads_app/ui/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateController extends GetxController {
  late GlobalKey<FormState> formKey;
  late RegExp emailReq;

  late LocalStorageService localStorageService;
  late AuthRepository _authRepository;

  RxBool isLoading = false.obs;
  RxBool showPassword = false.obs;
  RxBool showConfirmPassword = false.obs;

  @override
  void onInit() {
    super.onInit();

    localStorageService = Get.find<LocalStorageService>();
    _authRepository = Get.find<AuthRepository>();

    formKey = GlobalKey<FormState>();

    emailReq = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
  }

  Future<void> openContentLink({required bool isTerms}) async {
    try {
      final result = await _authRepository.getContentLinks();
      result.fold(
        (errors) {
          Get.snackbar(
            'تنبيه',
            errors.isNotEmpty ? (errors.first.message ?? 'فشلت عملية جلب الرابط') : 'فشل جلب الرابط حالياً',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        },
        (linksModel) async {
          final String targetUrlString = isTerms
              ? (linksModel.termsUrl ?? '')
              : (linksModel.privacyUrl ?? '');

          if (targetUrlString.isNotEmpty) {
            final url = Uri.parse(targetUrlString);

            await launchUrl(
              url,
              mode: LaunchMode.inAppWebView,
            );
          } else {
            Get.snackbar(
              'تنبيه',
              'الرابط المرجوع من السيرفر فارغ حالياً',
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
          }
        },
      );
    } catch (e) {
      print("حدث خطأ أثناء فتح الرابط: ${e.toString()}");
    }
  }

  Future<void> registerUser({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    isLoading.value = true;

    final result = await _authRepository.register(
      fullName: fullName.trim(),
      email: email.trim(),
      password: password.trim(),
      passwordConfirmation: confirmPassword.trim(),
    );

    isLoading.value = false;

    result.fold(
      (errors) {
        Get.snackbar(
          'خطأ',
          errors.isNotEmpty ? (errors.first.message ?? 'فشلت عملية التسجيل') : 'حدث خطأ غير متوقع',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (tokenInfo) {
        localStorageService.setLoggedIn(value: true);
        localStorageService.setAccessToken(accessTokenValue: tokenInfo.accessToken ?? '');

        Get.snackbar(
          'نجاح',
          'تم إنشاء الحساب بنجاح!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAll(() => const BottomNavigationScreen());
      },
    );
  }
}

import 'package:ads_app/core/data/repository/auth_repository.dart';
import 'package:ads_app/core/di/service_locator.dart';
import 'package:ads_app/shared_widgets/app_button.dart';
import 'package:ads_app/shared_widgets/app_text_field.dart';
import 'package:ads_app/shared_widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'create_controller.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  return GetBuilder<CreateController>(
      init: Get.find<CreateController>(),
      builder: (controller) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
            onPressed: () => Get.back(),
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.only(left: 18, right: 18, bottom: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        Container(
                          width: 86,
                          height: 86,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              'Logo',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 19),

                        const Text(
                          'إنشاء حساب',
                          style: TextStyle(fontSize: 18, color: AppColors.black, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),

                        const Text('أدخل المعلومات المطلوب أدناه',
                          style: TextStyle(fontSize: 12, color: AppColors.greyText),
                        ),
                        const SizedBox(height: 32),

                        AppTextField(
                          controller: _fullNameController,
                          hintText: 'الاسم الكامل',
                          prefixIcon: const Icon(Icons.person_outline, color: AppColors.greyText),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'الرجاء إدخال الاسم الكامل';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        AppTextField(
                          controller: _emailController,
                          hintText: 'البريد الإلكتروني',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined, color: AppColors.greyText),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'البريد الإلكتروني مطلوب';
                            if (!controller.emailReq.hasMatch(value)) return 'البريد الإلكتروني غير صالح';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),


                        Obx(() => AppTextField(
                            controller: _passwordController,
                            hintText: 'كلمة المرور',
                            obscureText: !controller.showPassword.value,
                            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.greyText),
                            suffixIcon: InkWell(
                              onTap: () => controller.showPassword.toggle(),
                              child: Icon(
                                controller.showPassword.value ? Icons.visibility_off_outlined : Icons.remove_red_eye_outlined,
                                color: AppColors.greyText,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'كلمة المرور مطلوبة';
                              if (value.length < 6) return 'كلمة المرور يجب أن تكون 6 خانات على الأقل';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        Obx(() => AppTextField(
                            controller: _confirmPasswordController,
                            hintText: 'تأكيد كلمة المرور',
                            obscureText: !controller.showConfirmPassword.value,
                            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.greyText),
                            suffixIcon: InkWell(
                              onTap: () => controller.showConfirmPassword.toggle(),
                              child: Icon(
                                controller.showConfirmPassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.remove_red_eye_outlined,
                                color: AppColors.greyText,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'يرجى تأكيد كلمة المرور';
                              if (value != _passwordController.text) return 'كلمتا المرور غير متطابقتين';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 28),


                        Obx(() => controller.isLoading.value
                            ? const SizedBox(
                                height: 48,
                                child: Center(
                                  child: CircularProgressIndicator(color: AppColors.primaryColor),
                                ),
                              )
                            : AppButton(
                                text: 'إنشاء الحساب',
                                textColor: AppColors.white,
                                backgroundColor: AppColors.primaryColor,
                                onPressed: () {
                                  if (controller.formKey.currentState != null && controller.formKey.currentState!.validate()) {
                                    controller.registerUser(
                                      fullName: _fullNameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                      confirmPassword: _confirmPasswordController.text.trim(),
                                    );
                                  } else {
                                    Get.snackbar(
                                      'تنبيه',
                                      'يرجى التحقق من صحة الحقول المدخلة',
                                      backgroundColor: AppColors.errorRed,
                                      colorText: AppColors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                      margin: const EdgeInsets.all(16),
                                    );
                                             }
                                  },
                                ),
                              ),
                              const SizedBox(height: 60),

                                  Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text(
      'بالمتابعة، أنت توافق على ',
      style: TextStyle(fontSize: 11, color: Colors.black),
    ),


    InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () => controller.openContentLink(isTerms: true),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Text(
          'الشروط والأحكام',
          style: TextStyle(
            fontSize: 11,
            color: Colors.blue,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),

    const Text(' و ', style: TextStyle(fontSize: 11, color: Colors.black)),


    InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () => controller.openContentLink(isTerms: false),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Text(
          'سياسة الخصوصية',
          style: TextStyle(
            fontSize: 11,
            color: Colors.blue,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  ],
)


],
),
),
),
);
},
),
),
),
);
},
);
}
}

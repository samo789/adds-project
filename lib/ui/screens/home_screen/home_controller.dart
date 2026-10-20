import 'package:get/get.dart';
import 'package:ads_app/core/data/repository/home_repository.dart';
import 'package:ads_app/core/data/repository/lookups_repository.dart';
import 'package:ads_app/core/data/models/apis/home_stats_response_model.dart';
import 'package:ads_app/core/data/models/apis/ads_list_response_model.dart';
import 'package:ads_app/core/data/models/apis/governorate_model.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();
  final LookupsRepository _lookupsRepository = Get.find<LookupsRepository>();

  RxBool isLoading = false.obs;
  var homeStats = HomeStatsModel().obs;
  RxList<AdItemModel> nearbyDeals = <AdItemModel>[].obs;
  RxList<AdItemModel> recentAds = <AdItemModel>[].obs;


  RxString selectedGovernorateName = 'حمص'.obs;
  RxString selectedGovernorateId = ''.obs;
  RxList<GovernorateModel> governoratesList = <GovernorateModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllHomeData();
  }

  Future<void> fetchAllHomeData() async {
    try {
      isLoading.value = true;

      //*  إحصائيات الأقسام
      final statsResult = await _homeRepository.getHomeStats();
      statsResult.fold((errors) => null, (statsModel) => homeStats.value = statsModel);

      //*  أفضل الصفقات القريبة منك
      final nearbyResult = await _homeRepository.getNearbyDeals(
        limit: 10,
        governorateId: selectedGovernorateId.value.isEmpty ? null : selectedGovernorateId.value,
      );
      nearbyResult.fold((errors) => null, (list) => nearbyDeals.assignAll(list));

      //*  الإعلانات الحديثة
      final recentResult = await _homeRepository.getRecentAds(
        limit: 10,
        governorateId: selectedGovernorateId.value.isEmpty ? null : selectedGovernorateId.value,
      );
      recentResult.fold((errors) => null, (list) => recentAds.assignAll(list));

    } catch (e) {
      print("حدث خطأ في الكنترولر:");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> showGovernoratesDialog() async {
    if (governoratesList.isEmpty) {
      final result = await _lookupsRepository.getGovernorates();
      result.fold(
        (errors) => Get.snackbar('تنبيه', 'فشل جلب قائمة المحافظات السورية'),
        (list) => governoratesList.assignAll(list),
      );
    }

    if (governoratesList.isNotEmpty) {
      Get.defaultDialog(
        title: "اختر المحافظة",
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
        content: SizedBox(
          height: 300,
          width: 250,
          child: ListView.builder(
            itemCount: governoratesList.length,
            itemBuilder: (context, index) {
              final gov = governoratesList[index];
              return ListTile(
                title: Text(gov.nameAr ?? '', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
                onTap: () {

                  selectedGovernorateName.value = gov.nameAr ?? 'حمص';
                  selectedGovernorateId.value = gov.id?.toString() ?? '';

                  fetchAllHomeData();
                  Get.back();
                },
              );
            },
          ),
        ),
      );
    }
  }
}

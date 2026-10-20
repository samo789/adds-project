import 'package:ads_app/shared_widgets/category_card_widget.dart';
import 'package:ads_app/shared_widgets/product_card_widget.dart';
import 'package:ads_app/shared_widgets/product_shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black, size: 28),
          onPressed: () {},
        ),
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F5),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.search, color: Colors.grey),
              ),
              const Expanded(
                child: TextField(
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: '...ابحث عن أي شيء تريده',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const VerticalDivider(color: Colors.grey, indent: 10, endIndent: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: () => controller.showGovernoratesDialog(),
                  child: Row(
                    children: [
                      const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                      const SizedBox(width: 4),
                      Obx(() => Text(
                        controller.selectedGovernorateName.value,
                        style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                      )),
                      const SizedBox(width: 4),
                      const Icon(Icons.location_on_outlined, color: Colors.grey, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFFF1F3F5),
              child: Icon(Icons.person_outline, color: Colors.grey, size: 22),
            ),
          )
        ],
      ),
      body: Obx(() {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          CategoryCardWidget(
                            title: 'سيارات',
                            count: controller.isLoading.value ? 'جاري التحميل...' : '${controller.homeStats.value.carsCount ?? 0} إعلان',
                            bgImageUrl: 'assets/images/cars.png',
                            height: 125,
                          ),
                          const SizedBox(height: 16),
                          CategoryCardWidget(
                            title: 'عقارات',
                            count: controller.isLoading.value ? 'جاري التحميل...' : '${controller.homeStats.value.realEstateCount ?? 0} إعلان',
                            bgImageUrl: 'assets/images/real_estate.png',
                            height: 125,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          const CategoryCardWidget(
                            title: 'إلكترونيات',
                            count: '4,152 إعلان',
                            bgImageUrl: 'assets/images/electronics.png',
                            height: 125,
                          ),
                          const SizedBox(height: 16),
                          const CategoryCardWidget(
                            title: 'وظائف',
                            count: '182 إعلان',
                            bgImageUrl: 'assets/images/jobs.png',
                            height: 125,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                //! قسم أفضل الصفقات القريبة منك
                const Text('أفضل الصفقات القريبة منك', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 12),
                SizedBox(
                  height: 175,
                  child: controller.isLoading.value
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) => const ProductShimmerWidget(),
                        )
                      : controller.nearbyDeals.isEmpty
                          ? const Center(child: Text("لا توجد صفقات قريبة حالياً", style: TextStyle(color: Colors.grey)))
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.nearbyDeals.length,
                              itemBuilder: (context, index) {
                                final item = controller.nearbyDeals[index];
                                return ProductCardWidget(
                                  name: item.title ?? 'بدون عنوان',
                                  price: '${item.price ?? 0} \$',
                                  imgUrl: item.thumbnailUrl ?? '',
                                );
                              },
                            ),
                ),
                const SizedBox(height: 24),

                //! قسم وصل حديثاً
                const Text('وصل حديثاً', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 12),
                SizedBox(
                  height: 175,
                  child: controller.isLoading.value
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) => const ProductShimmerWidget(),
                        )
                      : controller.recentAds.isEmpty
                          ? const Center(child: Text("لا توجد إعلانات حديثة", style: TextStyle(color: Colors.grey)))
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.recentAds.length,
                              itemBuilder: (context, index) {
                                final item = controller.recentAds[index];
                                return ProductCardWidget(
                                  name: item.title ?? 'بدون عنوان',
                                  price: '${item.price ?? 0} \$',
                                  imgUrl: item.thumbnailUrl ?? '',
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

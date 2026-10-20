import 'package:flutter/material.dart';

class CategoryCardWidget extends StatelessWidget {
  final String title;
  final String count;
  final String bgImageUrl;
  final double height;

  const CategoryCardWidget({
    super.key,
    required this.title,
    required this.count,
    required this.bgImageUrl,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [

            //!  الصورة الخلفية للأقسام
            Positioned.fill(
              child: Image.asset(
                this.bgImageUrl,
                fit: BoxFit.cover,
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      const Color(0xff1C2A5A),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            //! النصوص  في الاسفل للكرت
            Positioned(
              bottom: 12,
              right: 14,
              left: 14,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    this.count,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

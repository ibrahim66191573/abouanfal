import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PromoBanner extends StatelessWidget {
  final List<String> imageUrls;
  const PromoBanner({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    return CarouselSlider(
      options: CarouselOptions(
        height: 160,
        autoPlay: true,
        viewportFraction: 0.9,
        autoPlayInterval: const Duration(seconds: 4),
        enlargeCenterPage: true,
      ),
      items: imageUrls.map((url) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            width: double.infinity,
            placeholder: (c, _) => Container(color: AppColors.secondary.withValues(alpha: 0.15)),
            errorWidget: (c, _, __) => Container(color: AppColors.secondary.withValues(alpha: 0.15)),
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/language_switcher.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // TODO: remplacer par les données réelles issues de Firestore (voir services/product_service.dart à venir)
  static final List<Product> _demoPopular = [
    const Product(
      id: '1',
      name: 'Poulet braisé entier',
      description: 'Poulet braisé aux épices maison, servi avec attiéké',
      price: 5000,
      imageUrl: 'https://images.unsplash.com/photo-1598103442097-8b74394b95c6',
      category: 'Braisé',
      isPromo: true,
      promoPrice: 4500,
    ),
    const Product(
      id: '2',
      name: 'Demi-poulet grillé',
      description: 'Demi-poulet mariné et grillé, sauce piquante en option',
      price: 3000,
      imageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec',
      category: 'Grillé',
    ),
    const Product(
      id: '3',
      name: 'Ailes de poulet épicées (x8)',
      description: 'Ailes croustillantes marinées, sauce au choix',
      price: 2500,
      imageUrl: 'https://images.unsplash.com/photo-1608039755401-742074f0548d',
      category: 'Ailes',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.egg_alt_outlined, color: AppColors.primary),
              // Remplacer par: backgroundImage: AssetImage('assets/images/logo.png')
            ),
            const SizedBox(width: 10),
            Text(t.appName),
          ],
        ),
        actions: const [LanguageSwitcher(), SizedBox(width: 8)],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            Text(
              t.welcomeMessage,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            TextField(
              decoration: InputDecoration(
                hintText: t.searchHint,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            PromoBanner(imageUrls: [
              'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58',
              'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d',
            ]),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.popularProducts,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {}, // TODO: naviguer vers le catalogue complet
                  child: Text(t.seeAll),
                ),
              ],
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _demoPopular.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) => ProductCard(product: _demoPopular[index]),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

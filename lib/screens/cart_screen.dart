import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/cart_provider.dart';
import '../theme/app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(t.cart)),
      body: cart.items.isEmpty
          ? Center(child: Text(t.emptyCart, style: const TextStyle(color: AppColors.textMuted)))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, i) {
                final item = cart.items[i];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(item.product.imageUrl, width: 56, height: 56, fit: BoxFit.cover),
                  ),
                  title: Text(item.product.name),
                  subtitle: Text('${item.unitPrice} FCFA x ${item.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => context.read<CartProvider>().decrementProduct(item.product.id),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                        onPressed: () => context.read<CartProvider>().addProduct(item.product),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.totalPrice, style: const TextStyle(color: AppColors.textMuted)),
                          Text('${cart.totalPrice} FCFA',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {}, // TODO: naviguer vers l'écran de commande
                      child: Text(t.orderNow),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

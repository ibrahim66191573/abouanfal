import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Étape suivante : brancher ce catalogue sur Firestore
/// (collection "products") avec filtre par catégorie.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.catalog)),
      body: Center(
        child: Text('${t.catalog} — à connecter à Firestore'),
      ),
    );
  }
}

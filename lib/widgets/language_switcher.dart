import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/locale_provider.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      onSelected: (locale) => context.read<LocaleProvider>().setLocale(locale),
      itemBuilder: (context) => const [
        PopupMenuItem(value: Locale('fr'), child: Text('Français')),
        PopupMenuItem(value: Locale('en'), child: Text('English')),
        PopupMenuItem(value: Locale('ar'), child: Text('العربية')),
      ],
      initialValue: localeProvider.locale,
    );
  }
}

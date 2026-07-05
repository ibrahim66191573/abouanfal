import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart'; // généré par `flutterfire configure`

import 'l10n/app_localizations.dart';
import 'screens/main_shell.dart';
import 'services/auth_service.dart';
import 'services/cart_provider.dart';
import 'services/locale_provider.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Étape suivante : décommenter une fois `flutterfire configure` exécuté
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const AbouanfalApp());
}

class AbouanfalApp extends StatelessWidget {
  const AbouanfalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return MaterialApp(
            title: 'Abouanfal',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            locale: localeProvider.locale,
            supportedLocales: LocaleProvider.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              // Bascule automatiquement en RTL pour l'arabe
              return Directionality(
                textDirection: localeProvider.isRtl ? TextDirection.rtl : TextDirection.ltr,
                child: child!,
              );
            },
            home: const MainShell(),
          );
        },
      ),
    );
  }
}

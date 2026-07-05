import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'auth/login_screen.dart';

/// Affiche soit le profil du client connecté, soit une invitation
/// à se connecter / créer un compte.
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final auth = context.watch<AuthService>();

    return Scaffold(
      appBar: AppBar(title: Text(t.account)),
      body: StreamBuilder(
        stream: auth.authStateChanges,
        builder: (context, snapshot) {
          final loggedIn = snapshot.data != null;

          if (!loggedIn) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_outline, size: 64, color: AppColors.textMuted),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      child: Text(t.login),
                    ),
                  ],
                ),
              ),
            );
          }

          return FutureBuilder<AppUser?>(
            future: auth.fetchCurrentProfile(),
            builder: (context, profileSnapshot) {
              final profile = profileSnapshot.data;
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: const Icon(Icons.person, size: 36, color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile?.fullName ?? '—',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  if (profile?.email != null)
                    Text(profile!.email!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
                  if (profile?.phoneNumber != null)
                    Text(profile!.phoneNumber!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () => auth.signOut(),
                    icon: const Icon(Icons.logout),
                    label: Text(t.logout),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

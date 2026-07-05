# Abouanfal — Application de vente de produits à base de poulet

## 🎯 Où en est le projet (Étape 2/8)

Ceci est le **socle de l'application** : structure du projet, thème visuel,
navigation, page d'accueil, panier fonctionnel (en mémoire), et système
multilingue **FR / EN / AR** (avec bascule RTL automatique en arabe).

Le catalogue reste pour l'instant en données de démonstration
(`_demoPopular` dans `home_screen.dart`) — il sera connecté à Firestore à
l'étape 3.

**Nouveau à cette étape : l'authentification des clients** (e-mail + mot
de passe, ou numéro de téléphone avec code SMS), avec création automatique
du profil dans Firestore.

## 🔥 Configuration Firebase (obligatoire pour cette étape)

1. Créez un projet gratuit sur [console.firebase.google.com](https://console.firebase.google.com)
2. Installez les outils : `dart pub global activate flutterfire_cli`
3. Depuis le dossier du projet : `flutterfire configure`
   → cela crée le fichier `lib/firebase_options.dart` et connecte l'app à votre projet.
4. Dans la Console Firebase → **Authentication** → **Sign-in method**, activez :
   - *E-mail/Mot de passe*
   - *Téléphone* (nécessite d'ajouter l'empreinte SHA-1 de votre app Android :
     `cd android && ./gradlew signingReport`)
5. Dans **Firestore Database**, créez la base (mode production) et ajoutez cette
   règle de sécurité minimale pour la collection `users` :
   ```
   match /users/{userId} {
     allow read, write: if request.auth != null && request.auth.uid == userId;
   }
   ```
6. Ouvrez `lib/main.dart` et décommentez les 2 lignes Firebase (import +
   `Firebase.initializeApp(...)`).

## ▶️ Comment lancer le projet

Prérequis : [Flutter SDK](https://docs.flutter.dev/get-started/install) installé sur votre ordinateur (Windows/Mac/Linux), et un téléphone Android en mode débogage USB (ou un émulateur).

```bash
cd abouanfal
flutter pub get
flutter gen-l10n        # génère les fichiers de traduction depuis lib/l10n/*.arb
flutter run
```

## 📁 Structure du projet

```
abouanfal/
  lib/
    main.dart                 -> point d'entrée, thème, langues
    theme/app_theme.dart      -> couleurs et style de la marque
    l10n/                     -> traductions FR/EN/AR (.arb)
    models/product.dart       -> modèle de données produit
    services/
      cart_provider.dart      -> logique du panier
      locale_provider.dart    -> logique de changement de langue
    screens/
      main_shell.dart         -> barre de navigation (Accueil/Catalogue/Panier/Compte)
      home_screen.dart        -> page d'accueil
      catalog_screen.dart     -> catalogue (à connecter)
      cart_screen.dart        -> panier
      account_screen.dart     -> connexion/compte (à connecter)
    widgets/
      product_card.dart       -> carte produit
      promo_banner.dart       -> carrousel de promotions
      language_switcher.dart  -> bouton de changement de langue
```

## 🗺️ Feuille de route complète

| Étape | Contenu | Statut |
|---|---|---|
| 1 | Structure, thème, navigation, accueil, multilingue | ✅ fait |
| 2 | Firebase : authentification (email + téléphone) | ✅ fait (ce livrable) |
| 3 | Catalogue connecté à Firestore + recherche | à venir |
| 4 | Commande : livraison/retrait, carte GPS, position modifiable | à venir |
| 5 | Suivi de commande en temps réel + notifications | à venir |
| 6 | Paiements : Moov Money / Airtel Money / à la livraison | à venir |
| 7 | Espace administrateur (produits, commandes, clients, statistiques) | à venir |
| 8 | Icônes, signature de l'app, publication Play Store | à venir |

## ⚠️ Points importants à anticiper

- **Firebase** : il faudra créer un projet gratuit sur [console.firebase.google.com](https://console.firebase.google.com)
  et exécuter `flutterfire configure` — je vous guiderai à l'étape 2.
- **Moov Money / Airtel Money** : ces opérateurs exigent un **compte marchand**
  et des identifiants API obtenus directement auprès d'eux. Le code sera
  structuré pour recevoir ces identifiants dès que vous les aurez ; je ne
  peux pas les obtenir à votre place.
- **Compte Google Play Developer** (25 $, une seule fois) : à créer par vous
  sur [play.google.com/console](https://play.google.com/console) — nécessaire
  avant la publication finale (étape 8).
- **Logo** : l'accueil utilise une icône temporaire. Dès que vous avez un
  logo (image), je l'intègre.

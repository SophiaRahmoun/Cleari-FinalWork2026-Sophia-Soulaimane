# Cleari — UI/UX Design Session
**Auteur :** Soulaimane Saadi  
**Branche principale :** `design/ui-polish`  
**Branche feature :** `feat/filter-dermatologist`  
**Date :** 5 juin 2026  
**Outil :** Claude AI (Anthropic)

---

## Vue d'ensemble

Session de travail complète dédiée au polish UI/UX et à l'ajout de fonctionnalités sur l'application iOS **Cleari** — application de dermatologie permettant aux utilisateurs de scanner leur peau, interagir avec des dermatologues certifiés et consulter des tendances beauté vérifiées.

---

## Changements effectués

### 🔐 1. Navigation Auth — LoginView ↔ RolePickerView
**Fichiers :** `LoginView.swift`, `RolePickerView.swift`, `AuthBottomLink.swift`

- "Sign up" dans `LoginView` navigue vers `RolePickerView`
- "Login" dans `RolePickerView` navigue vers `LoginView`
- `AuthBottomLink` : ajout d'un paramètre `action` pour le rendre cliquable
- Fix typographie : "already have an account?" en `.body` (normal), "Login" en `.button` (bold)
- Texte `RolePickerView` centré avec `.multilineTextAlignment(.center)`

---

### 🖼️ 2. Logo — Remplacement texte → image asset
**Fichiers :** `FeedTopBar.swift`, `AppFlowView.swift`

- `Text("cleari")` remplacé par `Image("Cleari_Header")` (asset SVG dans `Assets > Logo`)
- Appliqué sur le **header du feed** et le **loading/splash screen**

---

### 📰 3. Header FeedTopBar — Redesign complet
**Fichier :** `FeedTopBar.swift`

- Logo centré via `ZStack` — l'icône profil est overlaid à droite sans décaler le logo
- Tabs "explore" / "fake trends" : `TypographyLabel(.button)` — Gill Sans Bold, blanc
- Paramètre `activeTab: FeedTab` (.explore / .fakeTrends) — soulignement actif selon la page
- Spacing et padding ajustés pour un header plus aéré

---

### 💊 4. Bottom Navigation — Refonte Pill
**Fichiers :** `ScanBottomBar.swift`, `UserHomeShellView.swift`

- Style **capsule/pill** flottante avec `Capsule()` + ombre douce
- Couleur fond : `C97A94` (rose Cleari)
- Icône active : **blanc** — icône inactive : dark
- Paramètre `activeTab: Int` pour le hover par page
- Positionnement via `.safeAreaInset(edge: .bottom)`
- Taille icons réduite pour une navbar plus compacte
- Même style appliqué à la navbar dermatologue (2 icons)

---

### 🧹 5. FeedView — Nettoyage
**Fichier :** `FeedView.swift`

- Suppression du gradient opaque derrière le `ReplyBar`
- Réduction du padding bottom du `ReplyBar`

---

### 👤 6. Avatar / Photo de profil par défaut
**Fichier :** `FeedPostCard.swift`

- Opacity du fond du cercle d'initiale : `0.18` → `0.10`
- La lettre est plus visible sur le fond rose

---

### 🚫 7. Fake Trends — Refonte complète
**Fichiers :** `DebunkFeedView.swift`, `DebunkPostCard.swift`, `DebunkExpertReplyCard.swift`

**Header :**
- Padding top ajusté pour matcher la page Explore
- `activeTab: .fakeTrends` → "fake trends" souligné sur cette page
- Icône profil branchée → ouvre `UserProfileView`

**Navigation :**
- `ScanBottomBar` avec toutes les actions branchées
- Suppression du `DebunkReplyBar` ("Post your reply") — inutile sur cette page
- Navbar fonctionnelle depuis la page fake trends

**Likes / Commentaires :**
- Remplacement des données hardcodées ("30", "14", "1") par les vraies données API
- Icône partage commentée (feature non implémentée)
- Suppression des boutons en double hors de la card

**Badges Verdict :**
```
✅ "true"              → Badge vert   "True"
⚠️ "use_with_caution"  → Badge jaune  "Use with caution" (triangle)
❌ "not_recommended"   → Badge rouge  "Not recommended"
```

---

### 🧭 8. Navigation globale — Système de tabs
**Fichiers :** `FindDermatologistView.swift`, `MyAppointmentsView.swift`, `CameraCaptureView.swift`

- Suppression des back buttons sur les 3 pages
- Ajout de `ScanBottomBar` avec le bon icon actif (blanc) sur chaque page :
  - `FindDermatologistView` → loupe active (index 1)
  - `MyAppointmentsView` → calendrier actif (index 3)
  - `CameraCaptureView` → scan actif (index 2)
- Navigation entre toutes les pages via `fullScreenCover`
- Fix du conflit `NavigationStack` imbriqué dans `FindDermatologistView`

---

### 🎨 9. FindDermatologistView — Polish UI
**Fichiers :** `FindDermatologistView.swift`, `DermatologistCard.swift`

- Titre "Recommended dermatologist" → `TypographyLabel(.h1)` — même font que `MyAppointmentsView`
- Photo de profil des cartes : `76pt` → `52pt`

---

### 📍 10. Filtre Location — FindDermatologistView
**Fichier :** `FindDermatologistView.swift`

- Sheet demi-écran avec la liste des villes uniques extraites de l'API
- Bouton "Location" affiche la ville sélectionnée + ✕ pour reset
- Filtrage en temps réel combiné avec le filtre genre

---

### 🚻 11. Filtre Male/Female — FindDermatologistView
**Fichiers :** `Dermatologist.swift`, `FindDermatologistView.swift`, `DermatologistRegisterView.swift`, `AuthAPIService.swift`, `AuthViewModel.swift`, `AuthModels.swift`

**iOS :**
- Ajout de `pronouns: String?` dans `DermatologistUser` (décodé depuis `user.pronouns`)
- Propriété `gender` calculée : `"she/her"` → Female, `"he/him"` → Male
- Filtre genre branché sur `filteredDermatologists`
- Sélecteur pronouns ajouté au formulaire d'inscription dermatologue

**Backend :**
- `dermatologistController.js` : ajout de `"pronouns"` dans les attributs User retournés par `/api/dermatologists/verified`
- `authController.js` : `pronouns` sauvegardé à l'inscription d'un dermatologue

**Base de données :**
```sql
-- SQL à exécuter sur la DB webhosting
UPDATE users SET pronouns = 'she/her' 
WHERE username IN ('FannyCamus', 'celine_dh', 'murielbrouckaert', ...);

UPDATE users SET pronouns = 'he/him' 
WHERE username IN ('hali_said');
```

> ⚠️ **Important :** L'app iOS pointe vers le backend déployé sur **Render.com** (`cleari-finalwork2026-sophia-soulaimane.onrender.com`). Les changements backend doivent être mergés dans `main` et poussés pour que Render redéploie.

---

## Fichiers modifiés — Récapitulatif

### iOS (Swift)
| Fichier | Changement |
|--------|-----------|
| `AuthBottomLink.swift` | Action cliquable + fix typo |
| `LoginView.swift` | Sign up → RolePickerView |
| `RolePickerView.swift` | Login → LoginView + texte centré |
| `AppFlowView.swift` | Logo image sur loading screen |
| `FeedTopBar.swift` | Logo image, activeTab, pill tabs |
| `FeedView.swift` | Suppression gradient, fix ReplyBar |
| `FeedPostCard.swift` | Opacity avatar réduite |
| `ScanBottomBar.swift` | Refonte pill navbar |
| `UserHomeShellView.swift` | safeAreaInset, derm navbar |
| `DebunkFeedView.swift` | Header, navbar, profil, reply bar |
| `DebunkPostCard.swift` | Badges verdict |
| `DebunkExpertReplyCard.swift` | Vraies données likes/comments |
| `FindDermatologistView.swift` | Navbar, titre, filtres location + genre |
| `DermatologistCard.swift` | Photo profil réduite |
| `MyAppointmentsView.swift` | Navbar, navigation |
| `CameraCaptureView.swift` | Navbar, navigation |
| `Dermatologist.swift` | Champ `pronouns` + propriété `gender` |
| `DermatologistRegisterView.swift` | Sélecteur pronouns |
| `AuthAPIService.swift` | Passage pronouns à l'API |
| `AuthViewModel.swift` | Paramètre pronouns |
| `AuthModels.swift` | Champ pronouns dans la request |

### Backend (Node.js)
| Fichier | Changement |
|--------|-----------|
| `dermatologistController.js` | Ajout `pronouns` dans les attributs User |
| `authController.js` | Sauvegarde `pronouns` à l'inscription |

---

## Git

```
Branches de travail :
  design/ui-polish          → UI redesign (header, navbar, feed)
  feat/filter-dermatologist → Filtres genre + location

Commits clés :
  design(auth): fix navigation & typography consistency
  design(feed): redesign FeedTopBar header
  design(feed): redesign bottom navbar as pill + fix layout
  design(fake-trends): fix header, navbar, badges and active tab
  feat(find-dermatologist): add location filter with city picker sheet
  feat(filter-dermatologist): add gender & location filters with pronouns support
```

---

## Notes techniques

- Le backend local tourne sur **port 4000** mais l'app iOS pointe sur **Render.com**
- Les changements backend nécessitent un **push sur `main`** pour être pris en compte par Render
- La DB de production est sur `ID500308_cleari.db.webhosting.be` — le SQL doit y être exécuté
- Correction d'une référence Git corrompue `refs/remotes/origin/HEAD 2` en cours de session

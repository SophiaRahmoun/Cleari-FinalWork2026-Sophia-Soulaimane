# Cleari — Design & UI Session Log
**Branch:** `design/ui-polish`
**Date:** 5 juin 2026
**Participants:** Soulaimane Saadi & Claude (Anthropic AI)

---

## Contexte
Session de travail dédiée au polish UI/UX de l'application iOS **Cleari** — une app de dermatologie permettant aux utilisateurs de scanner leur peau, interagir avec des dermatologues et consulter des tendances beauté vérifiées.

---

## 1. Navigation Auth — LoginView ↔ RolePickerView

**Fichiers modifiés :**
- `Features/Auth/Views/LoginView.swift`
- `Features/Auth/Views/RolePickerView.swift`
- `Features/Auth/Components/AuthBottomLink.swift`

**Changements :**
- Le bouton **"Sign up"** dans `LoginView` navigue maintenant vers `RolePickerView` via le callback `onRegister()`
- Le lien **"Login"** dans `RolePickerView` navigue vers `LoginView` via le callback `onLogin()`
- `AuthBottomLink` reçoit un paramètre `action: () -> Void` pour être cliquable
- Correction typographie : "already have an account?" passe en style `.body` (normal) et "Login" reste en `.button` (bold) — cohérence avec `LoginView`
- Texte de `RolePickerView` centré avec `.multilineTextAlignment(.center)`

---

## 2. Header FeedTopBar — Redesign

**Fichier modifié :** `Features/Feed/Components/FeedTopBar.swift`

**Changements :**
- Remplacement du `Text("cleari")` par `Image("Cleari_Header")` — logo SVG depuis les assets Xcode (`Assets > Logo > Cleari_Header`)
- Logo centré via `ZStack` avec l'icône profil overlaid à droite (ne décale plus le logo)
- Tabs "explore" / "fake trends" : style `TypographyLabel(.button)` — Gill Sans Bold, blanc
- Spacing entre logo et tabs : `spacing: 24`
- Padding top augmenté pour agrandir le header
- Spacing entre les deux tabs : `100pt`
- Ajout d'un paramètre `activeTab: FeedTab` (.explore / .fakeTrends) pour gérer le soulignement actif selon la page

---

## 3. Loading Screen

**Fichier modifié :** `Features/Onboarding/Views/AppFlowView.swift`

**Changement :**
- Remplacement du `Text("cleari")` par `Image("Cleari_Header")` dans le `sessionCheckView` (splash screen)

---

## 4. Bottom Navigation — Redesign Pill

**Fichiers modifiés :**
- `Features/Scan/Components/ScanBottomBar.swift`
- `Features/UserHome/Views/UserHomeShellView.swift`

**Changements :**
- Refonte complète de `ScanBottomBar` : style **capsule/pill** flottante avec `Capsule()` + ombre
- Couleur fond : `C97A94` (rose Cleari)
- Icône active : blanc — icône inactive : dark (`1A1018`)
- Paramètre `activeTab: Int` pour gérer le hover par page
- Positionnement via `.safeAreaInset(edge: .bottom)` — colle proprement au bas de l'écran
- Taille icons réduite : `26` → `22`, padding vertical : `18` → `12`
- Refonte du dermatologue navbar (2 icons) : même style pill

---

## 5. FeedView — Nettoyage

**Fichier modifié :** `Features/Feed/Views/FeedView.swift`

**Changements :**
- Suppression du gradient opaque derrière le `ReplyBar` ("Share your thoughts")
- Réduction du `padding(.bottom)` du `ReplyBar` : `120` → `16`

---

## 6. Avatar / Profile Picture par défaut

**Fichier modifié :** `Features/Feed/Components/FeedPostCard.swift`

**Changement :**
- Opacity du fond du cercle d'initiale : `0.18` → `0.10` — la lettre est plus visible

---

## 7. Fake Trends Page — Refonte complète

**Fichiers modifiés :**
- `Features/Debunk/Views/DebunkFeedView.swift`
- `Features/Debunk/Components/DebunkPostCard.swift`
- `Features/Debunk/Components/DebunkExpertReplyCard.swift`

**Changements :**

### Header
- Padding top réduit : `55` → `20` — même hauteur que la page Explore
- `activeTab: .fakeTrends` passé au `FeedTopBar` — "fake trends" est souligné sur cette page
- Icône profil branchée → ouvre `UserProfileView`

### Navigation
- Restructuration avec `.safeAreaInset` — suppression du background opaque
- `ScanBottomBar` avec toutes les actions branchées
- Suppression du `DebunkReplyBar` ("Post your reply") — inutile sur cette page

### Likes / Commentaires
- Suppression des données hardcodées ("30", "14", "1") dans `DebunkExpertReplyCard`
- Remplacement par les vraies données de l'API (`likesCount`, `commentsCount`, `isLikedByCurrentUser`)
- Icône partage commentée (feature non implémentée)
- Suppression des boutons en double qui étaient hors de la card

### Badges Verdict
Ajout d'un badge visuel basé sur `post.status` :
- ✅ `"true"` → badge vert "True"
- ⚠️ `"use_with_caution"` → badge jaune "Use with caution" (triangle)
- ❌ `"not_recommended"` → badge rouge "Not recommended"

---

## 8. Navigation Globale — FindDermatologistView

**Fichier modifié :** `Features/FindDermatologist/Views/FindDermatologistView.swift`

**Changements :**
- Suppression du back button
- Ajout `ScanBottomBar` avec `activeTab: 1` (loupe en blanc)
- Navigation vers `CameraCaptureView` et `MyAppointmentsView` via `fullScreenCover`
- Titre "Recommended dermatologist" → `TypographyLabel(.h1)` — même font que `MyAppointmentsView`

**Fichier modifié :** `Features/FindDermatologist/Components/DermatologistCard.swift`
- Photo de profil réduite : `76` → `52`

---

## 9. Navigation Globale — MyAppointmentsView

**Fichier modifié :** `Features/Appointment/Views/MyAppointmentsView.swift`

**Changements :**
- Suppression du back button
- Ajout `ScanBottomBar` avec `activeTab: 3` (calendrier en blanc)
- Navigation vers `CameraCaptureView` et `FindDermatologistView` via `fullScreenCover`

---

## 10. Navigation Globale — CameraCaptureView

**Fichier modifié :** `Features/Scan/Views/CameraCaptureView.swift`

**Changements :**
- Suppression du back button
- Ajout `ScanBottomBar` avec `activeTab: 2` (scan icon en blanc)
- Navigation vers `FindDermatologistView` et `MyAppointmentsView` via `fullScreenCover`

---

## Résumé des fichiers modifiés

| Fichier | Nature du changement |
|--------|----------------------|
| `AuthBottomLink.swift` | Action cliquable + fix typographie |
| `LoginView.swift` | Sign up → RolePickerView |
| `RolePickerView.swift` | Login → LoginView + texte centré |
| `AppFlowView.swift` | Logo image sur loading screen |
| `FeedTopBar.swift` | Logo image, pill tabs, activeTab |
| `FeedView.swift` | Suppression gradient, fix ReplyBar |
| `FeedPostCard.swift` | Opacity avatar réduite |
| `ScanBottomBar.swift` | Refonte pill navbar |
| `UserHomeShellView.swift` | safeAreaInset, derm navbar |
| `DebunkFeedView.swift` | Header, navbar, profil, reply bar |
| `DebunkPostCard.swift` | Badges verdict |
| `DebunkExpertReplyCard.swift` | Vraies données likes/comments |
| `FindDermatologistView.swift` | Navbar, titre, navigation |
| `DermatologistCard.swift` | Photo profil réduite |
| `MyAppointmentsView.swift` | Navbar, navigation |
| `CameraCaptureView.swift` | Navbar, navigation |

---

## Gestion Git

- **Branche de travail :** `design/ui-polish`
- Correction d'une référence corrompue `refs/remotes/origin/HEAD 2` dans `.git/logs/`
- Commits effectués au fil de la session sur la branche `design/ui-polish`

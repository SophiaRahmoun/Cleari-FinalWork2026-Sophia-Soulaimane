# Session 06 — Setup Initial & Design System

**Date :** Février–Mars 2026  
**Branche :** `main` (commits initiaux)  
**Auteur :** Sophia Rahmoun / Soulaimane Saadi  
**Commits clés :** `4174b68`, `8c0e65d`, `c7980e4`, `c31355c`

---

## 1. Objectif

Poser les fondations du projet Cleari : structure de dossiers iOS, système de design partagé, composants de base et première vue d'accueil.

---

## 2. Structure du projet iOS créée

```
Cleari-FinalWork2026-Sophia-Soulaimane/
├── Core/
│   ├── API/           ← APIConfig, TokenStorage
│   └── Models/        ← Modèles partagés
├── DesignSystem/
│   ├── Components/    ← PrimaryButton, SecondaryButton, AvatarView, BackButton
│   ├── Typography/    ← TypographyLabel, TextSpan
│   └── Backgrounds/   ← RadialGradientBackground, LinearGradientBackground, AuthBackground
├── Features/
│   ├── Auth/          ← Login, Register, RolePicker
│   ├── Feed/          ← Community feed
│   ├── Scan/          ← Camera, scan result
│   ├── Forms/         ← Consultation form
│   ├── Profile/       ← User & Derm profiles
│   └── ...
└── Resources/
    └── Fonts/         ← GillSans, CorporateACondPro
```

---

## 3. Design System créé

### Typographie — `AppFont.swift`
```swift
enum AppFont {
    enum GillSans: String {
        case regular    = "GillSans"
        case bold       = "GillSans-Bold"
        case italic     = "GillSans-Italic"
        case boldItalic = "GillSans-BoldItalic"
        case light      = "GillSans-Light"
    }
    enum CorporateACondensed: String {
        case regular = "CorporateACondPro-Regular"
        case medium  = "CorporateAPro-Medium"
    }
    static func gillSwiftUI(_ style: GillSans, size: CGFloat) -> Font
    static func corporateSwiftUI(_ style: CorporateACondensed, size: CGFloat) -> Font
}
```

### `TypographyLabel.swift`
```swift
// Styles disponibles :
.h1         → GillSans Regular 32pt
.h1Italic   → GillSans Italic 32pt
.body       → GillSans Regular 16pt
.bodyItalic → GillSans Italic 16pt
.button     → GillSans Bold 14pt

TypographyLabel(text: "...", style: .h1Italic, color: .black, alignment: .center)
```

### `TextSpan` — mix de styles inline
```swift
// Permet de combiner styles dans un même Text SwiftUI
TextSpan.body("Du texte ", color: dark)
+ TextSpan.bodyItalic("en italique", color: dark)
+ TextSpan.body(" suivi de texte normal.", color: dark)
```

### Palette de couleurs — `Color+Hex.swift`
```swift
extension Color {
    init(hex: String)  // ex: Color(hex: "C66F8C")
}
```

| Couleur | Hex | Usage |
|---|---|---|
| Dark | `#1E141D` | Texte principal |
| Dark2 | `#1A1018` | Navbar, titres |
| Pink | `#C66F8C` | Dégradé start |
| Beige clair | `#F9BDB9` | Dégradé end |
| Beige neutre | `#E6DED6` | Inputs, cards |

### Backgrounds
```swift
RadialGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
LinearGradientBackground(startHex: "C66F8C", endHex: "F9BDB9")
AuthBackground()  // variante pour les écrans auth
```

### Composants de base
- `PrimaryButton(title:action:)` — bouton principal dark
- `SecondaryButton(title:action:)` — bouton outline
- `AvatarView(imageUrl:assetName:)` — avatar avec fallback
- `BackButton` — chevron gauche stylisé

---

## 4. `WelcomeView.swift` — Écran d'accueil

```swift
// Tagline principale :
"On the way to your skin"

// Texte descriptif (mix body + bodyItalic) :
"Check out the following news about " + "fake news"(italic)
+ ", be more aware of your skin..."

// Boutons :
PrimaryButton("Login")    → onLogin()
PrimaryButton("REGISTER") → onRegister()
```

Fond : `RadialGradientBackground(#C66F8C → #F9BDB9)`

---

## 5. Community feed initial — `FeedView.swift`

Première version du feed communauté : layout `ScrollView` + `LazyVStack`, fond dégradé linéaire, top bar avec logo et navigation.

---

## 6. Git — commits de la session

```
4174b68  Initial project setup and folder structure creation
8c0e65d  Update folder structure
c7980e4  Add initial community feed layout
c31355c  feat: add design system helpers, gradients, typography and WelcomeView
```

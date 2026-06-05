# Session 09 — Formulaire de Consultation (Skin Form)

**Date :** 3–7 Mai 2026  
**Branche :** `feat/form-user-skin` / `feat/backend-skin-form`  
**Auteur :** Sophia Rahmoun / Soulaimane Saadi  
**Commits clés :** `b700036`, `d676f98`, `62fce41`, `5d8c683`, `796a582`, `7117534`, `00af336`

---

## 1. Objectif

Créer le formulaire de consultation en plusieurs étapes que chaque utilisateur remplit une seule fois après son inscription, pour établir son profil de peau. Le formulaire est soumis au backend et stocké par utilisateur.

---

## 2. Structure du formulaire (3 étapes)

```
ConsultationFormView (conteneur)
    ├── KnowYourSkinView     ← Étape 1 : type de peau, sensibilité
    ├── YourSkinHistoryView  ← Étape 2 : historique, conditions
    └── YourSkinTodayView    ← Étape 3 : état actuel, objectifs
```

### `ConsultationFormViewModel.swift` — ViewModel partagé
```swift
// @StateObject partagé entre les 3 étapes (EnvironmentObject)
// Stocke toutes les réponses du formulaire
// currentStep: Int (0, 1, 2)
// isSubmitting: Bool
// submit() async → SkinFormService.submitForm()
// Validation par étape avant de passer à la suivante
```

### `ConsultationFormData.swift`
```swift
struct ConsultationFormData: Codable {
    // Étape 1
    var skinType: String           // "oily", "dry", "combination", "normal"
    var sensitivity: String        // "low", "medium", "high"

    // Étape 2
    var hasAcne: Bool
    var hasEczema: Bool
    var hasPsoriasis: Bool
    var hasRosacea: Bool
    var currentProducts: [String]

    // Étape 3
    var todayMood: String          // humeur actuelle
    var mainConcern: String        // préoccupation principale
    var goals: [String]            // objectifs beauté
    
    // CodingKeys : snake_case pour le backend
    enum CodingKeys: String, CodingKey {
        case skinType = "skin_type"
        case sensitivity
        case hasAcne = "has_acne"
        // ...
    }
}
```

---

## 3. Composants de formulaire créés

- `FormTextBox.swift` — champ texte stylisé
- `ImageChoiceRow.swift` — sélection avec image + label
- `FormSectionTitle.swift` — titre de section

Chaque étape utilise des boutons Oui/Non, des sélecteurs de type de peau, et des cases à cocher visuelles.

---

## 4. Backend

### `SkinFormAnswer.js` — modèle Sequelize (`62fce41`)
```js
// Colonnes : user_id, skin_type, sensitivity, has_acne, has_eczema,
//            has_psoriasis, has_rosacea, today_mood, main_concern,
//            goals (JSON), current_products (JSON)
// Un seul enregistrement par user (upsert)
```

### `skinFormController.js` (`5d8c683`)
```js
// POST /api/skin-form/submit
// → Vérifie que l'utilisateur n'a pas déjà soumis (enforce single form)
// → Crée ou met à jour SkinFormAnswer
// → Retourne { message: "Form saved successfully" }

// Enforce single form (c68d049) :
// → Si l'utilisateur a déjà soumis → retourne 409 Conflict
// → Côté iOS : redirige directement vers userHome si form déjà fait
```

### `SkinFormService.swift` (iOS)
```swift
// submitForm(_ data: ConsultationFormData) async throws
// → POST /api/skin-form/submit avec Bearer token
// → Corps JSON encodé depuis ConsultationFormData
```

---

## 5. Navigation post-formulaire

```swift
// AppFlowView :
// Après userRegister → consultationForm
// Après form soumis  → userHome

// Enforce : si l'user se reconnecte ET a déjà fait le form → userHome direct
// (pas de re-soumission du form)
```

Les dermatologues ne passent jamais par le formulaire de consultation.

---

## 6. Validation par étape

```swift
// ffb9a86 — feat(form): add step validation and disable next buttons
// Bouton "Next" désactivé si les champs requis de l'étape ne sont pas remplis
// Feedback visuel : bouton grisé
```

---

## 7. Git — commits de la session

```
b700036  feat(form): replace local state with shared ViewModel for KnowYourSkin, History and Today
d676f98  feat(onboarding): implement app flow navigation and update auth screens
81d5ec1  feat: add ConsultationFormData model
019c017  feat: add ConsultationFormViewModel
be237a6  feat: add consultation form data model
7a28a54  feat: integrate ConsultationFormView as main entry
62fce41  feat(backend): add SkinFormAnswer model for consultation form storage
5d8c683  feat(api): add skin form submission endpoint
796a582  feat(form): connect consultation form to backend and update data model
7117534  feat(forms): connect register flow with consultation form and backend submission
00af336  fix(forms): fix duplicated yes/no selection and improve consultation form submit flow
ffb9a86  feat(form): add step validation and disable next buttons
```

# Session 18 — Routine Utilisateur (Produits de soin)

**Date :** 2 Juin 2026  
**Branche :** `feat/user-routine`  
**Auteur :** Soulaimane Saadi  
**Commits clés :** `33bf0f0`, `63077b7`, `8dff178`, `c02ec07`, `fd989f8`, `b7857b5`, `4f90591`, `e46470f`, `153d1e9`, `71c482d`, `c8b7fa5`, `ca5c9fe`

---

## 1. Objectif

Permettre aux utilisateurs de gérer leur routine de soins personnelle : ajouter des produits avec photo, nom, catégorie, et les synchroniser avec le backend.

---

## 2. Backend

### `Routine.js` / `RoutineProduct.js` — modèles Sequelize
```js
// Routine (conteneur par user) :
// user_id, name ("Morning routine", "Evening routine"), created_at

// RoutineProduct (produit) :
// routine_id, name, category, image_url, notes
// category : "cleanser", "toner", "serum", "moisturizer", "sunscreen", "other"
```

### `routineController.js` (`c02ec07`)
```js
// GET /api/routines
// → Retourne les routines de l'utilisateur avec leurs produits

// POST /api/routines
// Body : { name, products: [{name, category, notes}] }

// POST /api/routines/:id/products
// → Ajouter un produit à une routine
// → Si image fournie : upload vers Cloudinary (dossier: routine-products)

// PUT /api/routines/:id/products/:productId
// → Modifier un produit (nom, catégorie, image)

// DELETE /api/routines/:id/products/:productId
// → Supprimer + destroy Cloudinary
```

### Upload Cloudinary pour produits
```js
// Multer memoryStorage → buffer → uploadToCloudinary(buffer, 'routine-products')
// Stocke secure_url dans RoutineProduct.image_url
```

---

## 3. iOS

### `RoutineModels.swift`
```swift
struct Routine: Codable, Identifiable {
    let id: Int
    let name: String
    var products: [RoutineProduct]
}
struct RoutineProduct: Codable, Identifiable {
    let id: Int
    let name: String
    let category: String
    let imageUrl: String?
    let notes: String?
}
```

### `RoutineViewModel.swift` (`4f90591`)
```swift
// @StateObject ObservableObject
// routines: [Routine]
// isLoading: Bool
// loadRoutines() async → GET /api/routines
// addProduct(to routineId:, name:, category:, image:?) async
// updateProduct(...) async
// deleteProduct(...) async
```

### `RoutineAPIService.swift` (`b7857b5`)
```swift
// fetchRoutines() async throws -> [Routine]
// addProduct(routineId:name:category:image:?) async throws
//   → multipart si image fournie (compression JPEG)
// updateProduct(...) async throws
// deleteProduct(routineId:productId:) async throws
```

### `RoutineView.swift` (`e46470f`)
```swift
// Liste des routines (Morning / Evening)
// Chaque routine affiche ses produits en cards horizontales
// Bouton "+" → RoutineAddProductSheet
// RoutineEmptyState si aucun produit
```

### `RoutineProductCard.swift` (`f121c42`)
```swift
// Image produit (AsyncImage Cloudinary ou placeholder)
// Nom + catégorie en badge
// Tap → édition inline
// Swipe → suppression
```

### Image picker pour produits (`153d1e9`, `71c482d`, `d22f3e8`, `18c3b62`)
```swift
// PhotosPicker (iOS 16+) ou UIImagePickerController
// Sélection depuis galerie ou caméra
// Compression JPEG avant upload
// c8b7fa5 : image du produit éditable après création
```

### Persistance locale (`7568bec`)
```swift
// feat(routine): persist routine products locally
// UserDefaults backup des routines pour un affichage instantané
// Sync avec le backend à chaque lancement
```

### Connexion API finale (`ca5c9fe`)
```swift
// feat(routine): connect routine view model to backend api
// RoutineViewModel utilise RoutineAPIService
// Chargement au onAppear de RoutineView
// Pull-to-refresh disponible
```

---

## 4. Git — commits de la session

```
33bf0f0  feat: add routine product model
63077b7  feat: add routine model and user associations
8dff178  feat: add routine api routes
c02ec07  feat: add routine controller with cloudinary support
fd989f8  feat: register routine routes in server
b7857b5  feat: add routine API models and service layer
4f90591  feat: add routine view model
e46470f  feat: build RoutineView layout
8575d94  feat: add routine empty state component
0253ba6  feat: add routine header component
f121c42  feat: add routine product card component
153d1e9  feat: add photo library support for routine products
71c482d  feat(routine): add camera and photo source selection
d22f3e8  feat: integrate photo picker for routine products
18c3b62  feat: integrate photo picker for routine products
7568bec  feat(routine): persist routine products locally
d635e11  feat(routine): add routine api service
c8b7fa5  feat: make routine product image editable
ca5c9fe  feat(routine): connect routine view model to backend api
b292779  feat: add the My routines row (dans UserProfileView)
1927429  feat: integrate routine API and profile navigation
```

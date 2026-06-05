# Session 13 — Fake Trends & Débunk

**Date :** 30 Avril – 23 Mai 2026 / 1er Juin 2026  
**Branche :** `feature/fake-trends` / `feat/debunk-fake-trend`  
**Auteur :** Sophia Rahmoun / Soulaimane Saadi  
**Commits clés :** `8ba3f53`, `04f3315`, `9fa9b4c`, `87a8f05`, `dc16e0e`, `e7d901e`, `ee54e8a`, `b86faf7`

---

## 1. Objectif

Créer le système "Fake Trends" : un feed de posts sur des tendances beauté potentiellement fausses, où les dermatologues peuvent débunker avec une réponse professionnelle, et les utilisateurs peuvent liker, commenter, sauvegarder et signaler.

---

## 2. Backend

### `FakeTrendPost.js` — modèle
```js
// Colonnes : user_id, title, description, image_url, video_url,
//            source_url (TikTok/Instagram), status ("published"/"draft"),
//            likes_count, is_debunked
```

### `fakeTrendPostController.js` (`8ba3f53`, `9fa9b4c`)

| Endpoint | Description |
|---|---|
| `GET /api/fake-trends/posts` | Liste tous les posts (feed) |
| `POST /api/fake-trends/posts` | Créer un post (dermatologue) |
| `PUT /api/fake-trends/posts/:id` | Modifier |
| `DELETE /api/fake-trends/posts/:id` | Supprimer (+ Cloudinary) |

### `FakeTrendDermatologistResponse.js` — réponse pro
```js
// Colonnes : fake_trend_post_id, user_id (dermatologue), response (TEXT),
//            is_verified_dermatologist, created_at
```

### `FTDermatoResponseController.js` (`3a8c480`)
```js
// POST /api/fake-trends/posts/:id/debunk
// → Crée une réponse de dermatologue
// → Met is_debunked = true sur le post

// GET /api/fake-trends/posts/:id/responses
// → Retourne les réponses pro pour un post
```

### Likes & Sauvegarde (`94fbafc`)
```js
// FakeTrendLike model, FakeTrendSave model
// POST/DELETE /api/fake-trends/posts/:id/like
// POST/DELETE /api/fake-trends/posts/:id/save
```

### Commentaires (`44dd128`)
```js
// FakeTrendComment model
// POST /api/fake-trends/posts/:id/comments
// GET  /api/fake-trends/posts/:id/comments
```

### Sources scientifiques (`1ae3849`)
```js
// FakeTrendScientificSource model : post_id, url, title, authors
// POST /api/fake-trends/posts/:id/sources
// → Permet aux dermatologues d'attacher des sources académiques
```

### Algorithme de ranking (`b757ae7`)
```js
// Personnalisation du feed selon :
// - interactions de l'utilisateur
// - posts non vus en priorité
// - poids : likes récents > vieux
```

### Réponses professionnelles pro (`44dd128`)
```js
// FTProReply model : permet aux dermatologues de répondre aux commentaires
// POST /api/fake-trends/posts/:id/pro-reply
```

---

## 3. iOS

### `FakeTrendPost.swift` — modèle
```swift
struct FakeTrendPost: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let imageUrl: String?
    let videoUrl: String?
    let sourceUrl: String?  // lien TikTok/Instagram
    var likesCount: Int
    var isLiked: Bool
    var isDebunked: Bool
    let createdAt: String
}
```

### `DebunkFeedViewModel.swift`
```swift
// posts: [FakeTrendPost]
// loadPosts() async → GET /api/fake-trends/posts
// toggleLike(for:) async → like/unlike avec update optimiste
```

### `DebunkFeedView.swift`
```swift
// Feed des Fake Trends
// Filtres de catégories en row scrollable
// Bouton "Add" (dermatologue uniquement) → AddDebunkView
// Navigation → DebunkDetailView
```

### `DebunkPostCard.swift`
```swift
// Titre + description + image (AsyncImage)
// Badge "DEBUNKED" si is_debunked
// Boutons like + commentaire
// Si sourceUrl TikTok → aperçu intégré (ee54e8a)
```

### TikTok Preview (`ee54e8a`, `b758d81`, `6718d2d`)
```swift
// feat: add TikTok link preview support for debunk posts
// Si post.sourceUrl contient "tiktok.com" :
//   → Affiche un WebView embedded avec l'aperçu TikTok
//   → Bouton "Watch on TikTok" en overlay
// Utilise WKWebView via UIViewRepresentable
```

### `AddDebunkView.swift` (dermatologues)
```swift
// Champs : titre, description, image (picker)
// URL source (TikTok, Instagram, article)
// Sources scientifiques (liste ajout/suppression)
// Statut : draft / published
// AddDebunkViewModel → AddDebunkService.createPost()
```

### `AddDebunkService.swift` (`b86faf7`)
```swift
// createPost(title:description:image:sourceUrl:) async throws
// → POST /api/fake-trends/posts (multipart si image)
// Uniquement accessible aux dermatologues (rôle vérifié)
```

### `DebunkDetailView.swift`
```swift
// Affiche le post complet
// Liste des réponses professionnelles (DebunkExpertReplyCard)
// Section commentaires
// Bouton "Add expert response" si dermatologue
```

### Composants créés
- `DebunkPostCard.swift` — card feed
- `DebunkExpertReplyCard.swift` — réponse pro
- `DebunkFilterLabel.swift` — filtre catégorie
- `DebunkReplyBar.swift` — barre d'action bas
- `AddDebunkHeader.swift` — header formulaire création
- `AddDebunkButton.swift` — bouton flottant

### Contrôle d'accès premium
```swift
// feat(auth): store user role for fake trends access control (8987282)
// Si user non premium → FakeTrendLockedSheet affiché
// Si dermatologue → accès total
// TokenStorage.hasFakeTrendAccess → bool
```

---

## 4. Git — commits de la session

```
04f3315  add fake trend post model
8ba3f53  add fake trend post controller + utils for video url
9fa9b4c  add fake trend post system + fake trend feed & post controller
1ae3849  add scientific source routes + model
3a8c480  add fake trend dermatologist response controller
94fbafc  add fake trend like and save endpoints
44dd128  add professional replies for fake trend debunks
b757ae7  add personalized fake trend feed ranking
87a8f05  feat(debunk): build DebunkFeedView UI
b86faf7  feat: AddDebunkService for fake trend
dc16e0e  feat: connect debunk feed to backend posts
e7d901e  feat: add fake trend like toggle logic
04be083  feat: connect dynamic likes to fake trend feed
ee54e8a  feat: add TikTok link preview support for debunk posts
b758d81  feat: integrate TikTok web preview inside debunk cards
6718d2d  feat: improve add debunk UI and add TikTok preview
8987282  feat(auth): store user role for fake trends access control
```

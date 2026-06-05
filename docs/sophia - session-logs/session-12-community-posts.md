# Session 12 — Community Posts : Feed, Likes, Commentaires

**Date :** 14–19 Mai 2026 / 2 Juin 2026  
**Branche :** `feat/community-frontend-backend` / `community-posts`  
**Auteur :** Sophia Rahmoun / Soulaimane Saadi  
**Commits clés :** `e858e36`, `79adefd`, `e4e69a0`, `8c14fe5`, `161213a`, `a6f9fe7`, `1087de2`, `0c4ddc1`

---

## 1. Objectif

Créer un feed communautaire complet : création de posts, likes, commentaires, sauvegarde, signalement — avec backend et app iOS connectés.

---

## 2. Backend

### `CommunityPost.js` — modèle
```js
// Colonnes : user_id, content (TEXT), image_url, likes_count
// Association : belongsTo User
```

### `communityPostController.js` (`79adefd`)

| Endpoint | Description |
|---|---|
| `GET /api/community/posts` | Liste tous les posts (avec auteur) |
| `GET /api/community/posts/:id` | Post par ID |
| `POST /api/community/posts` | Créer un post |
| `PUT /api/community/posts/:id` | Modifier un post |
| `DELETE /api/community/posts/:id` | Supprimer (+ supprime image locale) |

### Likes (`e4e69a0`, `a315145` → `1087de2`)
```js
// CommunityPostLike model : user_id, post_id
// POST /api/community/posts/:id/like    → like
// DELETE /api/community/posts/:id/like  → unlike
// Retourne : { liked: bool, likesCount: int }
```

### Commentaires (`8c14fe5`, `ae9ebe7`)
```js
// CommunityPostComment model : user_id, post_id, content
// POST /api/community/posts/:id/comments
// GET  /api/community/posts/:id/comments
```

### Sauvegarde (`5a36c91`, `bab61b9`)
```js
// CommunityPostSave model : user_id, post_id
// POST /api/community/posts/:id/save
// DELETE /api/community/posts/:id/save
// GET /api/community/saved → liste des posts sauvegardés
```

### Signalement (`174e78c`)
```js
// CommunityPostReport model : user_id, post_id, reason
// POST /api/community/posts/:id/report
```

### Upload image (`1e47479`, `c5f1870`)
```js
// Multer middleware → stockage local uploads/community/
// (migré vers Cloudinary en session 04)
```

---

## 3. iOS

### `CommunityPost.swift` — modèle
```swift
struct CommunityPost: Codable, Identifiable {
    let id: Int
    let content: String
    let imageUrl: String?
    let likesCount: Int
    var isLiked: Bool
    let author: PostAuthor?
    let createdAt: String
}
struct PostAuthor: Codable {
    let id: Int
    let username: String
    let profilePictureUrl: String?
}
```

### `CommunityPostService.swift`
```swift
// fetchPosts() async throws -> [CommunityPost]
// createPost(content:image:?) async throws
// likePost(id:) / unlikePost(id:) async throws
// deletePost(id:) async throws
```

### `FeedViewModel.swift`
```swift
// posts: [CommunityPost]
// isLoading: Bool
// loadPosts() async
// toggleLike(for post:) async
//   → Mise à jour optimiste du compteur avant la réponse serveur
```

### `FeedView.swift`
```swift
// ScrollView → LazyVStack → FeedPostCard
// ReplyBar en bas → sheet CreatePostView
// Rafraîchissement après création ou fermeture de modal
```

### `FeedPostCard.swift`
```swift
// Avatar auteur + username + contenu
// Image AsyncImage si présente (Cloudinary URL)
// Bouton like (cœur) avec compteur + animation
// Bouton commentaire → PostDetailView
```

### `CreatePostView.swift` (`a6f9fe7`, `8c813d0`)
```swift
// TextField pour le contenu
// Bouton "Add photo" → ImagePicker → prévisualisation
// Bouton "Post" → CommunityPostService.createPost()
// Dismiss après succès → FeedViewModel.loadPosts()
```

### `PostDetailView.swift` (`534e8cf`)
```swift
// Affiche le post complet + liste des commentaires
// TextField pour ajouter un commentaire
// Refresh du feed à la fermeture (15f0382)
```

### Design du feed (`0c4ddc1`, `fbb74ca`)
Affinage UI pour correspondre au Figma :
- Espacement entre cards
- Typographie auteur / contenu
- Couleurs like / boutons

---

## 4. Git — commits de la session

```
e858e36  add CommunityPost model with user association
79adefd  add CRUD logic for community posts + add community post routes  (+105 lignes)
1e47479  add multer upload middleware for community posts
e4e69a0  add community post like model
8c14fe5  add comment support for community posts
ae9ebe7  add save and comment routes for community posts
5a36c91  add save and unsave support for community posts
bab61b9  add saved community posts list endpoint
174e78c  add community + FT post report system
161213a  feat(feed): connect feed UI to backend posts
a6f9fe7  feat: add dynamic community post creation flow
1087de2  feat: add dynamic like system for community posts
298b604  feat: connect dynamic post like interactions to feed UI
534e8cf  feat(feed): add post detail view with comments section
15f0382  feat(feed): refresh posts after closing post detail modal
0c4ddc1  design(community): finetune feed UI to match Figma
fbb74ca  Improve community posts UI
```

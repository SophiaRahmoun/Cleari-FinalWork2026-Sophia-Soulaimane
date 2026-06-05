# Session 04 — Cloudinary Image Uploads Integration

**Date :** 2026-06-02 (commits datés au 01/06/2026 — branche mergée le 02)  
**Session Claude Code :** "Cloudinary image uploads integration"  
**Branche :** `feature/upload-images`  
**Auteur :** Sophia Rahmoun  
**Commits clés :** `4f9e7e1`, `64c7734`, `d7f304e`, `2700c69`, `8b4bb99`, `45aa063`, `d69e92c`, `77e9ef1`, `8c813d0`, `d00f589`, `fcd991e`

---

## 1. Contexte et problème de départ

### Situation avant la session
Toutes les images (posts communauté, fake trends, photos de profil, images chat) étaient stockées **localement sur le serveur** dans le dossier `uploads/`. Ce système posait plusieurs problèmes :
- Les images disparaissent lors d'un redéploiement (Render.com efface les fichiers temporaires)
- Pas de CDN → chargement lent sur mobile
- L'app iOS construisait des URLs du type `http://localhost:4000/uploads/...` qui ne fonctionnent pas en production

### Objectif de la session
Migrer **intégralement** le système d'upload vers **Cloudinary** (CDN cloud) :
1. Côté backend : remplacer `diskStorage` (Multer) par `memoryStorage` + upload direct vers Cloudinary
2. Côté iOS : remplacer les URL locales par des `https://res.cloudinary.com/...` URLs
3. Côté iOS : ajouter les interfaces d'upload pour profil, posts, chat

---

## 2. Changements backend

### 2.1 `fakeTrendUplMiddleware.js` — Switch vers memoryStorage

**Avant :**
```js
const storage = multer.diskStorage({
    destination: (req, file, cb) => cb(null, 'uploads/fake-trends/'),
    filename: (req, file, cb) => cb(null, Date.now() + '-' + file.originalname)
});
```

**Après :**
```js
const storage = multer.memoryStorage();
// Le fichier est disponible en req.file.buffer pour upload Cloudinary
```

### 2.2 `communityPostController.js` — Migration vers Cloudinary

**Avant :** sauvegarde du fichier sur disque + URL relative  
**Après :**
```js
// createPost et updatePost
const result = await uploadToCloudinary(req.file.buffer, 'community-posts');
imageUrl = result.secure_url;  // https://res.cloudinary.com/...

// deletePost
const publicId = extractPublicIdFromUrl(imageUrl);  // extrait depuis l'URL stockée
await cloudinary.uploader.destroy(publicId);         // supprime sur Cloudinary
```

### 2.3 `fakeTrendPostController.js` — Migration vers Cloudinary

Même pattern que `communityPostController` :
- `createFakeTrendPost` / `updateFakeTrendPost` → upload buffer vers Cloudinary (dossier `fake-trends`)
- `deleteFakeTrendPost` → destruction de l'asset Cloudinary par son `public_id`

### 2.4 `userController.js` — Nouveau endpoint photo de profil

```js
// Nouveau controller : updateProfilePicture
// Cloudinary folder : profile-pictures
// Stocke le secure_url dans User.profile_picture_url

// Nouvelle route : PUT /api/users/me/profile-picture
// multipart/form-data — champ "image"
```

### 2.5 `chatController.js` — Nouveau endpoint image en message

```js
// Nouveau controller : sendImageMessage
// Cloudinary folder : chat-images
// Crée un message avec messageType: 'image', content: cloudinary_url

// Nouvelle route : POST /api/chat/conversations/:id/messages/image
// multipart/form-data — champ "image"
```

---

## 3. Changements iOS (Swift)

### 3.1 `AvatarView.swift` & `ProfileAvatarView.swift`

**Avant :** n'acceptaient qu'un nom d'asset local (`Image(assetName)`)  
**Après :**
```swift
// Paramètre optionnel imageUrl ajouté
if let url = URL(string: imageUrl) {
    AsyncImage(url: url) { phase in
        // loading, success, failure states
    }
} else {
    Image(assetName)  // fallback local
}
```

### 3.2 `ProfileHeader.swift` + `UserProfileViewModel.swift` + `UserProfileView.swift`

**Chaîne mise à jour :**
```
API response → profilePictureUrl dans ViewModel
           → passé à ProfileHeader via imageUrl
           → affiché dans AvatarView via AsyncImage
```

### 3.3 `EditProfileView.swift` + `UserProfileService.swift`

**Nouveau bouton "Edit picture" :**
```swift
// ImagePicker → UIImage → compression JPEG → upload multipart
// UserProfileService.updateProfilePicture(imageData: Data) async throws
// PUT /users/me/profile-picture — multipart/form-data
// Retourne le nouveau profile_picture_url
```

### 3.4 `CommunityPostService.swift` + `CreatePostView.swift`

**Avant :** `createPost` n'acceptait pas d'image  
**Après :**
```swift
// CommunityPostService.createPost(content: String, image: UIImage?) async throws
// Si image fournie : compression JPEG + multipart form
// Si non : JSON classique

// CreatePostView : bouton "Add photo" + prévisualisation + bouton "Remove"
```

### 3.5 `FeedPostCard.swift` + `DebunkPostCard.swift`

**Problème résolu :** les images Cloudinary étaient préfixées de `http://localhost:4000`  
**Fix :**
```swift
// Avant
let fullUrl = "http://localhost:4000/" + imageUrl

// Après
let fullUrl = imageUrl.hasPrefix("https://") ? imageUrl : baseURL + "/" + imageUrl
```

### 3.6 `ChatService.swift` + `ChatViewModel.swift` + `ChatDetailView.swift` + `MessageBubble.swift`

**Upload d'image dans le chat :**
```swift
// ChatService.sendImageMessage(conversationId:, imageData:) async throws
// POST /chat/conversations/:id/messages/image — multipart JPEG

// ChatDetailView : bouton caméra → ImagePicker → sendImageMessage()

// MessageBubble : affichage conditionnel selon messageType
if message.messageType == "image" {
    AsyncImage(url: URL(string: message.content))  // image Cloudinary
} else if message.messageType == "appointment_request" {
    HStack { Image(systemName: "calendar"); Text(...) }  // icône calendrier
} else {
    Text(message.content)  // texte normal
}
```

---

## 4. Décisions techniques

| Décision | Justification |
|---|---|
| `memoryStorage` au lieu de `diskStorage` | Le buffer mémoire est nécessaire pour uploader directement vers Cloudinary sans écrire sur disque |
| Extraction du `public_id` depuis l'URL stockée | Évite de stocker une colonne supplémentaire en DB pour l'id Cloudinary |
| Compression JPEG côté iOS avant upload | Réduit la taille des requêtes multipart (80% quality, acceptable pour mobile) |
| `hasPrefix("https://")` pour distinguer URLs | Compatible avec les anciennes données locales et les nouvelles Cloudinary |
| Dossiers Cloudinary séparés | `community-posts`, `fake-trends`, `profile-pictures`, `chat-images` → organisation claire dans le media manager |

---

## 5. Nouveaux endpoints backend créés

| Méthode | Endpoint | Description |
|---|---|---|
| `PUT` | `/api/users/me/profile-picture` | Upload photo de profil |
| `POST` | `/api/chat/conversations/:id/messages/image` | Envoyer une image dans un chat |

---

## 6. Résumé des fichiers modifiés

### Backend (5 fichiers)
| Fichier | Type de changement |
|---|---|
| `middleware/fakeTrendUplMiddleware.js` | `diskStorage` → `memoryStorage` |
| `controllers/communityPostController.js` | Upload + delete Cloudinary |
| `controllers/fakeTrendPostController.js` | Upload + delete Cloudinary |
| `controllers/userController.js` | Nouveau endpoint photo de profil |
| `controllers/chatController.js` | Nouveau endpoint image message |
| `routes/userRoutes.js` | `PUT /me/profile-picture` |
| `routes/chatRoutes.js` | `POST /conversations/:id/messages/image` |

### iOS / Swift (8 fichiers)
| Fichier | Type de changement |
|---|---|
| `DesignSystem/Components/AvatarView.swift` | Support `AsyncImage` Cloudinary |
| `Chat/Components/ProfileAvatarView.swift` | Support `AsyncImage` Cloudinary |
| `Profile/Components/ProfileHeader.swift` | Passe `imageUrl` à `AvatarView` |
| `Profile/User/ViewModels/UserProfileViewModel.swift` | Expose `profilePictureUrl` |
| `Profile/User/Views/UserProfileView.swift` | Passe URL au header |
| `EditProfile/Views/EditProfileView.swift` | Upload photo de profil |
| `User/Service.swift/UserProfileService.swift` | `updateProfilePicture(imageData:)` |
| `Feed/Services/CommunityPostService.swift` | Multipart avec image optionnelle |
| `Feed/Views/CreatePostView.swift` | UI de sélection photo |
| `Feed/Components/FeedPostCard.swift` | Fix URL Cloudinary |
| `Debunk/Components/DebunkPostCard.swift` | Fix URL Cloudinary |
| `Chat/Services/ChatService.swift` | `sendImageMessage(...)` |
| `Chat/ViewModels/ChatViewModel.swift` | `sendImageMessage(...)` |
| `Chat/Views/ChatDetailView.swift` | Bouton caméra → upload |
| `Chat/Components/MessageBubble.swift` | Rendu conditionnel image/texte |

---

## 7. Git — commits de la session

```
4f9e7e1  feat(backend): switch fakeTrend upload middleware to memory storage
64c7734  feat(backend): migrate community post images to Cloudinary
d7f304e  feat(backend): migrate fake trend post images to Cloudinary
2700c69  feat(backend): add profile picture upload endpoint
8b4bb99  feat(backend): add image message endpoint in chat
45aa063  feat(iOS): update AvatarView and ProfileAvatarView to support Cloudinary URLs
d69e92c  feat(iOS): wire profile picture URL through profile stack
77e9ef1  feat(iOS): add profile picture upload in EditProfileView
8c813d0  feat(iOS): add image picker to CreatePostView with Cloudinary upload
d00f589  feat(iOS): fix image display in FeedPostCard and DebunkPostCard for Cloudinary URLs
fcd991e  feat(iOS): add image upload and display in chat
```

# Session 15 — Système de Chat

**Date :** 27 Mai – 1er Juin 2026  
**Branche :** `feature/chat-system`  
**Auteur :** Sophia Rahmoun / Soulaimane Saadi  
**Commits clés :** `48d00ba`, `754cc1c`, `9b8d252`, `2168f9a`, `a3cf960`, `e2d0e8f`, `f77726c`, `8b4bb99`, `fcd991e`, `448dbc7`

---

## 1. Objectif

Créer un système de messagerie en temps réel entre patients et dermatologues, avec accès au contexte médical du patient (skin scan, formulaire, routine) depuis la vue chat du dermatologue.

---

## 2. Backend (`48d00ba`)

### `Conversation.js` — modèle
```js
// Colonnes : user_id (patient), dermatologist_id (→ DermatologistProfile)
// Contrainte unique : (user_id, dermatologist_id)
// → Empêche la création de doublons de conversations
```

### `Message.js` — modèle
```js
// Colonnes : conversation_id, sender_id, content (TEXT),
//            message_type ENUM("text", "image", "appointment_request"),
//            is_read (BOOLEAN)
```

### `chatController.js` (`48d00ba`, `e2d0e8f`, `f77726c`)

| Endpoint | Description |
|---|---|
| `POST /api/chat/conversations` | Créer/récupérer une conv (user → derm) |
| `GET /api/chat/conversations` | Liste des conversations de l'utilisateur |
| `GET /api/chat/conversations/:id/messages` | Messages d'une conversation |
| `POST /api/chat/conversations/:id/messages` | Envoyer un message texte |
| `POST /api/chat/conversations/:id/messages/image` | Envoyer une image |
| `GET /api/chat/conversations/:id/patient-scans` | Scans du patient |
| `GET /api/chat/conversations/:id/patient-form` | Formulaire du patient |
| `GET /api/chat/conversations/:id/patient-routines` | Routine du patient |

```js
// Contexte patient (e2d0e8f) :
// Ces endpoints exposent les données médicales du patient au dermatologue
// Sécurisés : seul le dermatologue de la conversation peut y accéder
// Utilisés dans le dashboard web ET le dashboard iOS derm
```

### Upload image dans le chat (`8b4bb99`)
```js
// POST /api/chat/conversations/:id/messages/image
// → multipart/form-data (champ "image")
// → Upload sur Cloudinary (dossier: chat-images)
// → Stocke le secure_url comme content du message
// → messageType: "image"
```

---

## 3. iOS

### `ChatModels.swift`
```swift
struct Conversation: Codable, Identifiable {
    let id: Int
    let otherParticipant: ChatParticipant  // l'autre personne
    let lastMessage: String?
    let lastMessageAt: String?
    let unreadCount: Int
}
struct ChatMessage: Codable, Identifiable {
    let id: Int
    let senderId: Int
    let content: String
    let messageType: String  // "text" | "image" | "appointment_request"
    let createdAt: String
}
struct ChatParticipant: Codable {
    let id: Int
    let username: String
    let profilePictureUrl: String?
}
```

### `ChatService.swift` (`754cc1c`)
```swift
// getConversations() async throws -> [Conversation]
// getMessages(conversationId:) async throws -> [ChatMessage]
// sendMessage(conversationId:content:) async throws
// sendImageMessage(conversationId:imageData:) async throws  (fcd991e)
// createOrGetConversation(dermatologistId:) async throws -> Conversation
```

### `ChatViewModel.swift`
```swift
// conversations: [Conversation]
// messages: [ChatMessage]
// loadConversations() async
// loadMessages(for conversationId:) async
// sendMessage(content:) async
// sendImageMessage(image: UIImage) async  (fcd991e)
// Polling automatique toutes les 3 secondes pour nouveaux messages
```

### `ChatListView.swift`
```swift
// Liste des conversations de l'utilisateur
// Chaque ligne : avatar + username + dernier message + horodatage
// Tap → ChatDetailView
```

### `ChatDetailView.swift`
```swift
// Header : nom du participant + avatar
// ScrollView de messages (MessageBubble)
// TextField + bouton Send
// Bouton caméra → ImagePicker → sendImageMessage() (fcd991e)
// Bouton "Book appointment" → TakeAppointmentView (0eff4dd)
```

### `MessageBubble.swift` (`fcd991e`)
```swift
// Affichage conditionnel selon messageType :
// "text"                → Text(message.content)
// "image"               → AsyncImage(url: cloudinaryUrl)
// "appointment_request" → HStack { Image("calendar.badge.clock") + Text }

// Alignement : bulle droite (sender) / bulle gauche (receiver)
// Couleurs : rose pour envoyé, beige pour reçu
```

### Vues contexte patient (dashboard derm iOS)
```swift
// PatientScansView.swift    → affiche l'historique des scans du patient
// PatientSkinFormView.swift → affiche les réponses au formulaire de consultation
// PatientRoutinesView.swift → affiche la routine du patient
// Accessibles depuis le chat dermatologue via onglets latéraux
```

### Noms des patients (`9b8d252`, `2168f9a`)
```
fix(chat): display patient names and improve conversation handling
fix(chat): show patient names and update messages instantly

Problème : l'API ne retournait que user.email au lieu de user.username
Fix : controller mis à jour pour inclure User.username dans les conversations
     + mise à jour instantanée de la liste après envoi de message
```

---

## 4. Flux complet

```
User → FindDermatologistView
    → tap "Chat" sur DermatologistCard
    → POST /chat/conversations { dermatologistId }
    → Conversation créée / récupérée
    → ChatDetailView(conversationId)
        → messages chargés + polling 3s
        → TextField → sendMessage()
        → Caméra → sendImageMessage()
        → Calendrier → TakeAppointmentView

Dermatologue (dashboard web ou iOS) :
    → GET /chat/conversations (liste patients)
    → tap conversation
    → messages + patient-scans / patient-form / patient-routines
```

---

## 5. Git — commits de la session

```
48d00ba  Feat: Add chat backend for users and dermatologists       (+414 lignes)
754cc1c  feat(chat): update chat models, services, and views & add cloudinary upload
9b8d252  fix(chat): display patient names and improve conversation handling
2168f9a  fix(chat): show patient names and update messages instantly
a3cf960  fix(chat): improve navigation state and message sending flow
e2d0e8f  feat(chat): expose patient details in dermatologist conversations
f77726c  feat(chat): fix patient data retrieval and appointment request flow
3688fe9  fix(chat): improve dermatologist patient data retrieval
8b4bb99  feat(backend): add image message endpoint in chat
fcd991e  feat(iOS): add image upload and display in chat
448dbc7  feat(iOS): wire FindDermatologist → Chat end-to-end
```

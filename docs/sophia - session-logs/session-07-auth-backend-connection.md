# Session 07 — Auth iOS ↔ Backend : Connexion Réelle

**Date :** 27–30 Avril 2026  
**Branche :** `feature/backend-frontend-auth` (début)  
**Auteur :** Sophia Rahmoun / Soulaimane Saadi  
**Commits clés :** `e54949b`, `0aa9cbf`, `b6b2bf3`, `c3c00e3`, `6adb892`, `d676f98`

---

## 1. Objectif

Créer le backend Node.js complet d'authentification ET le connecter à l'app iOS (login, register user, register dermatologue, JWT, stockage token).

---

## 2. Backend créé (`e54949b`)

### Structure
```
backend/
├── src/
│   ├── config/
│   │   ├── database.js        ← Sequelize + SQLite (dev)
│   │   └── config.js          ← Variables d'environnement
│   ├── controllers/
│   │   └── authController.js  ← registerUser, registerDermatologist, login
│   ├── middleware/
│   │   ├── authMiddleware.js  ← Vérifie JWT Bearer token
│   │   └── roleMiddleware.js  ← Vérifie user.role
│   ├── models/
│   │   ├── User.js            ← username, email, password, role
│   │   ├── DermatologistProfile.js
│   │   └── index.js           ← Associations Sequelize
│   ├── routes/
│   │   └── authRoutes.js      ← /register-user, /register-dermatologist, /login
│   └── server.js              ← Express + middleware + routes
```

### `User.js` — modèle Sequelize
```js
// Champs : id, username, email, password (hashé bcrypt), role, language
// role : ENUM("user", "dermatologist", "admin")
```

### Endpoints créés
| Méthode | Route | Description |
|---|---|---|
| `POST` | `/auth/register-user` | Inscription utilisateur |
| `POST` | `/auth/register-dermatologist` | Inscription dermatologue |
| `POST` | `/auth/login` | Connexion (retourne JWT) |

### Sécurité
- Mots de passe hashés avec `bcrypt` (10 rounds)
- JWT signé avec `JWT_SECRET` (env variable), expire en 7 jours
- `authMiddleware` : vérifie `Authorization: Bearer <token>`
- `roleMiddleware` : vérifie `user.role` pour les routes protégées

### Service YouCam (prototype)
- `youcamService.js` : premier prototype de connexion à l'API YouCam pour l'analyse de peau
- Inclut un fallback mock si l'API est indisponible

---

## 3. iOS — Vues Auth créées

### `LoginView.swift` (`0aa9cbf`)
```swift
// Champs : email + password (SecureField)
// Bouton NEXT STEP → viewModel.login()
// Feedback : erreur en rouge, succès → navigation
```

### `UserRegisterView.swift` (`b6b2bf3`)
```swift
// Champs : first_name, last_name, username, email, password
// Bouton REGISTER → viewModel.registerUser()
```

### `RolePickerView.swift` (`5ef63de`)
```swift
// Deux boutons : "User" / "Dermatologist"
// Description de chaque rôle
// Navigation → UserRegisterView ou DermatologistRegisterView
```

### `AuthRegisterInput.swift`, `AuthTextField.swift`, `AuthBackground.swift`
Composants réutilisables partagés entre toutes les vues auth.

---

## 4. iOS — Connexion backend (`c3c00e3`)

### `APIConfig.swift`
```swift
struct APIConfig {
    static let baseURL = "http://localhost:4000/api"  // dev
    // → Render URL en production
}
```

### `TokenStorage.swift` (version initiale)
```swift
// Stockage UserDefaults :
var token: String?    // cleari_auth_token
var userRole: String? // cleari_user_role
var userId: Int?      // cleari_user_id
func clear()          // logout
```

### `AuthModels.swift` (version initiale)
```swift
struct AuthResponse: Codable { let token: String; let user: AuthUser }
struct AuthUser: Codable { let id: Int; let username: String; let email: String; let role: String }
struct LoginRequest: Codable { let email: String; let password: String }
struct RegisterUserRequest: Codable { let first_name, last_name, username, email, password: String }
```

### `AuthAPIService.swift`
```swift
// login(email:password:) → POST /auth/login
// registerUser(firstName:lastName:username:email:password:) → POST /auth/register-user
// Gestion erreurs HTTP (4xx/5xx) → NSError avec message backend
```

### `AuthViewModel.swift`
```swift
// @MainActor ObservableObject
// login() → stocke token + role + userId dans TokenStorage
// registerUser() → idem
// logout() → TokenStorage.clear()
// errorMessage: String? → affiché dans les vues
```

### `AppFlowView.swift` (`d676f98`)
Première version de la navigation globale avec `NavigationStack` et `AppRoute` enum :
```swift
.welcome → .login → .rolePicker → .userRegister → .consultationForm → .userHome
                                → .dermatologistRegister
```

---

## 5. Git — commits de la session

```
e54949b  feat(auth): setup backend with authentication and role-based access  (+3303 lignes)
1717b4d  Create AuthBackground.swift
0aa9cbf  feat(auth): build loginView with reusable auth components
b6b2bf3  feat(auth): create UserRegisterView
7791579  feat(auth): create authentication background component
599be8b  feat(auth): create dermatologist document upload box
5ef63de  feat(auth): create role picker components
5c058ab  feat(auth): create user register components
91a0ec2  feat(auth): update role picker selection UI
c3c00e3  feat(frontend-auth): connect iOS app with backend authentication  (+318 lignes)
6adb892  feat(auth/scan): connect frontend to backend (register, login, scan flow WIP)
d676f98  feat(onboarding): implement app flow navigation and update auth screens
```

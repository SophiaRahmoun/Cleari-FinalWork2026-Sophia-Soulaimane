# Session 14 — Paiement Stripe & Abonnement Premium

**Date :** 25–30 Mai 2026  
**Branche :** `feat/user-payment`  
**Auteur :** Soulaimane Saadi  
**Commits clés :** `7d8e0ef`, `a41e213`, `855ed9c`, `b0cd0cf`, `17909b6`, `57f4313`, `5c50c32`, `27310bc`, `cc1ee5a`, `f97c6ea`, `2338d1c`

---

## 1. Objectif

Intégrer Stripe pour permettre aux utilisateurs de souscrire à un abonnement premium, débloquant l'accès complet aux Fake Trends et à d'autres fonctionnalités.

---

## 2. Backend

### `paymentController.js`

```js
// POST /api/payment/create-checkout-session
// → Crée une session Stripe Checkout
// → Retourne { url: "https://checkout.stripe.com/..." }
// → L'app iOS ouvre cette URL dans SafariViewController

// GET /api/payment/subscription-status
// → Vérifie le statut de l'abonnement de l'utilisateur connecté
// → Retourne { status: "active" | "inactive" | "cancelled" }
```

### `paymentWebhookController.js` (`b0cd0cf`, `2d2c25d`)
```js
// POST /api/payment/webhook  (endpoint public, pas de JWT)
// → Reçoit les événements Stripe (checkout.session.completed, etc.)
// → Vérifie la signature Stripe (STRIPE_WEBHOOK_SECRET)
// → Sur checkout.session.completed :
//     → Trouve l'user via metadata.userId
//     → Crée ou met à jour Subscription { user_id, status: "active", ... }
```

### `Subscription.js` — modèle
```js
// Colonnes : user_id, stripe_customer_id, stripe_subscription_id,
//            status ("active"/"inactive"/"cancelled"),
//            current_period_end (DATE)
```

### Configuration Stripe (`7d8e0ef`)
```js
// Variables d'environnement :
// STRIPE_SECRET_KEY   → clé secrète Stripe
// STRIPE_WEBHOOK_SECRET → secret de vérification webhook
// FRONTEND_URL        → pour redirect après paiement

// Enregistrement des routes dans server.js
// Route webhook AVANT le middleware JSON (signature brute nécessaire)
```

---

## 3. iOS

### `TokenStorage` — extension abonnement (`f97c6ea`)
```swift
var subscriptionStatus: String?  // "active" | "inactive"

var hasFakeTrendAccess: Bool {
    if userRole == "dermatologist" { return true }
    return subscriptionStatus == "active"
}
```

### `PaymentView.swift` (`855ed9c`, `cc1ee5a`)
```swift
// Écran de présentation du premium :
// - Avantages listés (accès Fake Trends complet, etc.)
// - Prix et fréquence
// - Bouton "Subscribe" → ouvre Stripe Checkout dans SafariViewController

// Flux :
// 1. GET /payment/create-checkout-session → URL Stripe
// 2. SafariViewController ouvre l'URL
// 3. Stripe redirige vers deeplink Cleari après paiement
// 4. App reçoit le deeplink → ferme Safari
// 5. PaymentView vérifie le statut → GET /payment/subscription-status
// 6. Met à jour TokenStorage.subscriptionStatus
// 7. Rafraîchit l'accès aux Fake Trends

// Auto-refresh (27310bc, cc1ee5a) :
// Polling toutes les 3 secondes pendant 30s après retour de Safari
// Pour détecter le paiement confirmé via webhook
```

### `FakeTrendLockedSheet.swift` (`2338d1c`)
```swift
// Sheet modal affiché si !TokenStorage.hasFakeTrendAccess
// Présente les avantages premium
// Bouton "Unlock" → PaymentView
// Bouton "Maybe later" → dismiss
```

### Accès depuis le profil (`54eda88`)
```swift
// feat: add subscription access from profile page
// Bouton "Premium" dans UserProfileView → PaymentView
```

---

## 4. Flux complet

```
User tape "Fake Trends"
    │
    ├─ hasFakeTrendAccess = true  → DebunkFeedView
    │
    └─ hasFakeTrendAccess = false → FakeTrendLockedSheet
                                        │
                                        ↓ "Unlock"
                                    PaymentView
                                        │
                                        ↓ "Subscribe"
                                    POST /payment/create-checkout-session
                                        │
                                        ↓ URL Stripe
                                    SafariViewController (Stripe Checkout)
                                        │
                                        ↓ Paiement confirmé
                                    Stripe → Webhook → subscription "active"
                                        │
                                        ↓ Deeplink → App
                                    GET /payment/subscription-status
                                        │
                                        ↓ "active"
                                    TokenStorage.subscriptionStatus = "active"
                                        │
                                        ↓
                                    DebunkFeedView (accès débloqué)
```

---

## 5. Git — commits de la session

```
7d8e0ef  feat: configure Stripe environment and payment routes
a41e213  feat: add Stripe checkout service for premium subscriptions
855ed9c  feat: open Stripe checkout from PaymentView
b0cd0cf  feat: add Stripe webhook endpoint and payment event handler
2d2c25d  feat: add Stripe webhook handler
17909b6  feat: connect stripe Webhook with Subscriptions model
57f4313  feat: activate subscriptions from Stripe webhook
5c50c32  feat: add subscription status payment endpoint
27310bc  feat: auto refresh premium status after payment
f97c6ea  feat: add subscription access logic to token storage
2338d1c  feat: add premium lock sheet flow for fake trends
54eda88  feat: add subscription access from profile page
cc1ee5a  feat: auto refresh premium status after stripe checkout
```

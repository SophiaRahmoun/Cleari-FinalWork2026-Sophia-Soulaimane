# Cleari

> **Bachelorproef**: Soulaimane Saadi & Sophia Kenza Rahmoun
> Research question: *"How do we raise awareness about skincare in an interactive way?"*

A mobile iOS app that combines AI skin analysis, verified dermatologists, and community features to help users make better skincare decisions.

---

## Tech Stack

| Layer              | Tech                     |
| ------------------ | ------------------------ |
| iOS Frontend       | SwiftUI (MVVM)           |
| Backend            | Node.js + Express.js     |
| Database           | MySQL + Sequelize        |
| Auth               | JWT + Bcrypt             |
| AI Analysis        | YouCam Skin Analysis API |
| Image Storage      | Cloudinary               |
| Payments           | Stripe                   |
| Hosting (DB)       | Combell + phpMyAdmin     |
| Hosting (Backend)  | Render                   |
| Admin Dashboard    | GitHub Pages + Render    |

---

## Live Deployments

| Service                  | URL                                                                                                                                              |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| Dermatologist Dashboard  | [sophiarahmoun.github.io/Cleari-FinalWork2026-Sophia-Soulaimane](https://sophiarahmoun.github.io/Cleari-FinalWork2026-Sophia-Soulaimane/)         |
| Dermatologist Dashboard  | [cleari-finalwork2026-sophia-soulaimane-wa9x.onrender.com](https://cleari-finalwork2026-sophia-soulaimane-wa9x.onrender.com) *(Render mirror)*    |
| Backend API              | [cleari-finalwork2026-sophia-soulaimane.onrender.com](https://cleari-finalwork2026-sophia-soulaimane.onrender.com)                                |
| Admin Dashboard          | `localhost:3000` — run locally (see Getting Started below)                                                                                       |

### Test Credentials

| Role          | Email                                      | Password |
| ------------- | ------------------------------------------ | -------- |
| User          | rayan@gmail.com                            | testtest |
| Dermatologist | HaliouiSaid@cleari.com *(case-sensitive)*  | 123456   |
| Admin         | drsmith@test.com                           | 123456   |

---

## Prerequisites

* Xcode + iOS Simulator
* Node.js (v18+)
* VSCode (recommended for backend)
* MySQL running locally

---

## Getting Started

### Backend

```bash
cd backend
npm install
npm run dev
```

### Dermatologist Dashboard

```bash
cd dermatologist-dashboard
npm install
npm run dev
```

> The dermatologist dashboard is also deployed via GitHub Pages.

### Admin Dashboard

The admin dashboard is a standalone HTML/JS app — no build step, no deployment. It runs locally only.

```bash
cd admin
npx serve .
```

Then open **http://localhost:3000** in your browser.

> The admin dashboard connects directly to the production backend on Render — make sure you have internet access.

### iOS Frontend

1. Open `Cleari.xcodeproj` in Xcode
2. Select a simulator (iPhone 15 recommended)
3. Hit **Run** (⌘R)

> Make sure the backend is running before launching the app.

---

## Backend Environment Variables

Create a `.env` file in the `backend/` folder with the following variables:

```env
PORT=

DB_HOST=
DB_USER=
DB_PASSWORD=
DB_NAME=

JWT_SECRET=
JWT_EXPIRES_IN=7d

YOUCAM_API_KEY=
YOUCAM_BASE_URL=

USE_MOCK_SKIN_SCAN=true

STRIPE_SECRET_KEY=
STRIPE_PRICE_MONTHLY=
CLIENT_SUCCESS_URL=
CLIENT_CANCEL_URL=
STRIPE_WEBHOOK_SECRET=

CLOUDINARY_CLOUD_NAME=
CLOUDINARY_API_KEY=
CLOUDINARY_API_SECRET=
```

---

## External API Dependencies

| Service    | Purpose                               | Docs                                                                                 |
| ---------- | ------------------------------------- | ------------------------------------------------------------------------------------ |
| YouCam     | AI skin scan (acne, pores, texture…)  | [yce.perfectcorp.com](https://yce.perfectcorp.com/ai-api/products/skin-analysis-api) |
| Cloudinary | Image storage (scans, profile pics…)  | [cloudinary.com](https://cloudinary.com/)                                            |
| Stripe     | Dermatologist subscription & payments | [docs.stripe.com](https://docs.stripe.com/billing/quickstart)                        |

---

## Features

* **Community** posts, questions, comments and discussions between users
* **AI Skin Analysis** photo-based skin scan via YouCam API (acne, pores, texture, moisture, etc.)
* **Skin Type Quiz** onboarding form to determine the user's skin type, combined with the AI scan
* **Skincare Routine** users can build and save their personal skincare routine
* **Verified Dermatologists** dermatologist accounts manually verified by us before going live
* **Appointments** users can book appointments directly with verified dermatologists
* **Chat** real-time messaging between users and dermatologists
* **Fake Trend Debunker** dermatologists can link TikTok trends and share their professional opinion on them
* **Subscription (Stripe)** dermatologists are compensated based on their activity through a Stripe-powered subscription model
* **Role-based Auth** separate flows and permissions for users and dermatologists

---

## AI Prompt Logs (docs/)

All Claude and ChatGPT prompts used during development are saved in the `docs/` folder, split by contributor:

```
docs/
├── sophia-session-logs/       # All sessions & prompts from Sophia
└── soulaimane-session-logs/   # All sessions & prompts from Soulaimane
```

Each `.md` file in those folders documents a working session — what was built, discussed, or fixed with AI assistance.

### AI Session References

* **ChatGPT project (Sophia)** [chatgpt.com/g/g-p-69908e48...](https://chatgpt.com/g/g-p-69908e4852a481919a37686b243c3239)
* **ChatGPT project (Soulaimane)** https://chatgpt.com/g/g-p-6a22305485d48191b3570bd94d6f5f51-finalwork/project
* **Claude** — [claude.ai/share/c96f9c5c...](https://claude.ai/share/c96f9c5c-f166-4a2a-b7f6-74a7a5d7cefb)
* **Claude** — [claude.ai/share/5acd3da1...](https://claude.ai/share/5acd3da1-3eeb-4359-aeb1-f1cb3c3799d0)

---

## Resources Used

### iOS / Xcode

* https://stackoverflow.com/questions/31853859/radial-gradient-background-in-swift
* https://stackoverflow.com/questions/56874133/use-hex-color-in-swiftui
* https://community.adobe.com/questions-652/using-fonts-from-adobe-in-xcode-801392
* https://stackoverflow.com/questions/46690619/build-fails-with-command-failed-with-a-nonzero-exit-code
* https://stackoverflow.com/questions/21998706/terminal-window-inside-xcode
* https://www.google.com/search?q=Configure++for+running+xcode+error
* https://discussions.unity.com/t/mac-xcode-projects-are-missing-a-build-target-and-cannot-be-built-found-in-unity-2021-2-11/872269

### Backend / Database

* https://www.npmjs.com/package/sequelize
* https://sequelize.org/docs/v7/querying/operators/
* https://stackoverflow.com/questions/47731340/how-to-setup-a-role-based-authentication-api-using-node-js-and-sequelize
* https://www.npmjs.com/package/axios
* https://stackoverflow.com/questions/63797390/sql-error-1064-you-have-an-error-in-your-sql-syntax
* https://expressjs.com/en/guide/routing/

### YouCam API

* https://yce.perfectcorp.com/document/index.html#section/API-Playground/
* https://yce.perfectcorp.com/document/index.html#section/API-Playground/Users-Guide

### Stripe

* https://docs.stripe.com/billing/quickstart
* https://docs.stripe.com/api/checkout/sessions

### GDPR / Privacy

* https://www.edpb.europa.eu/our-work-tools/our-documents/guidelines/transparency_en

### Git

* https://stackoverflow.com/questions/5601931/how-do-i-safely-merge-a-git-branch-into-master
* https://superuser.com/questions/1072422/how-to-display-git-ls-file-result-in-a-tree-like-format


### Other

* https://github.com/jaywcjlove/svgtofont/issues/247

---

## Authors

**Soulaimane Saadi** & **Sophia Kenza Rahmoun**
Bachelor's Thesis — 2025–2026

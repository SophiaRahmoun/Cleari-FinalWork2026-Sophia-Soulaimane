# Cleari

> **Bachelorproef**: Soulaimane Saadi & Sophia Kenza Rahmoun  
> Research question: *"How do we raise awareness about skincare in an interactive way?"*

A mobile iOS app that combines AI skin analysis, verified dermatologists, and community features to help users make better skincare decisions.

---

## Tech Stack

| Layer | Tech |
|---|---|
| iOS Frontend | SwiftUI (MVVM) |
| Backend | Node.js + Express.js |
| Database | MySQL + Sequelize |
| Auth | JWT + Bcrypt |
| AI Analysis | YouCam Skin Analysis API |

---

## Prerequisites

- [Xcode](https://developer.apple.com/xcode/) + iOS Simulator
- [Node.js](https://nodejs.org/) (v18+)
- [VSCode](https://code.visualstudio.com/) (recommended for backend)
- MySQL running locally

---

## Getting Started

### Backend

```bash
cd backend
npm install
npm run dev
```

### iOS Frontend

1. Open `Cleari.xcodeproj` in Xcode
2. Select a simulator (iPhone 15 recommended)
3. Hit **Run** (⌘R)

> Make sure the backend is running before launching the app.

---

## Features

- **Community** — posts, questions, comments and discussions between users
- **AI Skin Analysis** — photo-based skin scan via YouCam API (acne, pores, texture, moisture, etc.)
- **Skin Type Quiz** — onboarding form to determine the user's skin type, combined with the AI scan
- **Skincare Routine** — users can build and save their personal skincare routine
- **Verified Dermatologists** — dermatologist accounts manually verified by us before going live
- **Appointments** — users can book appointments directly with verified dermatologists
- **Chat** — real-time messaging between users and dermatologists
- **Fake Trend Debunker** — dermatologists can link TikTok trends and share their professional opinion on them
- **Subscription (Stripe)** — dermatologists are compensated based on their activity through a Stripe-powered subscription model
- **Role-based auth** — separate flows and permissions for users and dermatologists

---

## Resources used

**iOS / Xcode**
- [Radial gradient in SwiftUI](https://stackoverflow.com/questions/31853859/radial-gradient-background-in-swift)
- [Hex colors in SwiftUI](https://stackoverflow.com/questions/56874133/use-hex-color-in-swiftui)
- [Using Adobe fonts in Xcode](https://community.adobe.com/questions-652/using-fonts-from-adobe-in-xcode-801392)
- [Build fails — nonzero exit code](https://stackoverflow.com/questions/46690619/build-fails-with-command-failed-with-a-nonzero-exit-code)
- [Terminal window inside Xcode](https://stackoverflow.com/questions/21998706/terminal-window-inside-xcode)
- [Configure Xcode for running — error fix](https://www.google.com/search?q=Configure++for+running+xcode+error)
- [Xcode project missing build target](https://discussions.unity.com/t/mac-xcode-projects-are-missing-a-build-target-and-cannot-be-built-found-in-unity-2021-2-11/872269)

**Backend / Database**
- [Sequelize npm package](https://www.npmjs.com/package/sequelize)
- [Sequelize operators docs](https://sequelize.org/docs/v7/querying/operators/)
- [Role-based auth with Node + Sequelize](https://stackoverflow.com/questions/47731340/how-to-setup-a-role-based-authentication-api-using-node-js-and-sequelize)
- [Axios npm package](https://www.npmjs.com/package/axios)
- [SQL error 1064 — syntax fix](https://stackoverflow.com/questions/63797390/sql-error-1064-you-have-an-error-in-your-sql-syntax)

**YouCam API**
- [YouCam Skin Analysis API — Playground](https://yce.perfectcorp.com/document/index.html#section/API-Playground/)
- [YouCam API — Users Guide](https://yce.perfectcorp.com/document/index.html#section/API-Playground/Users-Guide)

**Git**
- [Safe Git branch merge into master](https://stackoverflow.com/questions/5601931/how-do-i-safely-merge-a-git-branch-into-master)
- [Display git ls-files as tree](https://superuser.com/questions/1072422/how-to-display-git-ls-file-result-in-a-tree-like-format)

**Other**
- [SVG to font — issue reference](https://github.com/jaywcjlove/svgtofont/issues/247)

---

## Authors

**Soulaimane Saadi** & **Sophia Kenza Rahmoun**  
Bachelor's thesis — 2025

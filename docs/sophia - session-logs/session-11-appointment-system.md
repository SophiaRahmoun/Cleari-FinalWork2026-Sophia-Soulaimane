# Session 11 — Système de Rendez-vous

**Date :** 12 Mai / 28–31 Mai 2026  
**Branche :** `feature/appointment-system`  
**Auteur :** Sophia Rahmoun / Soulaimane Saadi  
**Commits clés :** `60f72be`, `d8713f0`, `7110b0a`, `b522fe3`, `6501ce1`, `1b850b3`, `89d27f2`

---

## 1. Objectif

Permettre aux utilisateurs de demander un rendez-vous avec un dermatologue, et aux dermatologues de gérer les demandes (approuver/refuser) depuis l'app et le dashboard web.

---

## 2. Backend

### `Appointment.js` — modèle Sequelize
```js
// Colonnes :
// user_id, dermatologist_id (→ DermatologistProfile.id)
// appointment_date (DATE), appointment_time (STRING)
// status : ENUM("pending", "confirmed", "cancelled", "completed")
// notes : TEXT (optionnel)
```

### `appointmentController.js` (`60f72be`)

| Endpoint | Description |
|---|---|
| `POST /api/appointments` | Créer une demande de RDV |
| `GET /api/appointments/my` | RDV de l'utilisateur connecté |
| `GET /api/appointments/dermatologist/requests` | Demandes reçues par le derm |
| `PATCH /api/appointments/:id/status` | Approuver / Refuser / Confirmer |

```js
// POST /api/appointments
// Body : { dermatologist_id, appointment_date, appointment_time, notes? }
// → Vérifie que le dermatologue existe et est approuvé
// → status initial : "pending"

// PATCH /api/appointments/:id/status
// Body : { status: "confirmed" | "cancelled" | "completed" }
// → Vérifie que le dermatologue est bien le propriétaire
```

### Système de disponibilités (`722a900`)
```js
// DermatologistAvailability model :
// dermatologist_id, day_of_week (0-6), start_time, end_time

// availabilityController.js :
// POST /api/availability → le derm définit ses créneaux
// GET  /api/availability/:dermatologistId → l'user consulte les créneaux
```

---

## 3. iOS

### `AppointmentModels.swift`
```swift
struct Appointment: Codable, Identifiable {
    let id: Int
    let dermatologistId: Int
    let appointmentDate: String
    let appointmentTime: String
    let status: String  // "pending", "confirmed", "cancelled"
    let notes: String?
}

struct CreateAppointmentRequest: Codable {
    let dermatologist_id: Int
    let appointment_date: String
    let appointment_time: String
    let notes: String?
}
```

### `AppointmentService.swift`
```swift
// createAppointment(_:) async throws
// getMyAppointments() async throws -> [Appointment]
// getDermatologistRequests() async throws -> [Appointment]
// updateAppointmentStatus(id:status:) async throws
```

### `AppointmentViewModel.swift`
```swift
// appointments: [Appointment]
// isLoading: Bool
// loadAppointments() async
// createAppointment(dermatologistId:date:time:) async
// confirmAppointment(id:) / cancelAppointment(id:)
```

### `TakeAppointmentView.swift` (`b522fe3`)
```swift
// Calendrier de sélection de date (AppointmentCalendarCard)
// Sélection du créneau horaire
// Bouton "Confirm Appointment" → createAppointment()
// Popup de confirmation : AppointmentThankYouPopup
```

Composants :
- `AppointmentCalendarCard.swift` — calendrier mensuel interactif
- `AppointmentDayCell.swift` — cellule de jour sélectionnable
- `AppointmentThankYouPopup.swift` — popup de confirmation
- `AppointmentRequestCard.swift` — card de demande (vue dermatologue)
- `AppointmentActionButton.swift` — bouton Approve/Decline

### `MyAppointmentsView.swift` (`1b850b3`)
```swift
// Liste des rendez-vous de l'utilisateur avec statut coloré
// pending → orange / confirmed → vert / cancelled → rouge
```

### `DermatologistAppointmentRequestsView.swift` (`89d27f2`)
```swift
// Vue dermatologue : liste des demandes reçues
// Boutons Approve / Decline sur chaque card
// Appelle updateAppointmentStatus()
```

---

## 4. Booking depuis le Chat

```swift
// feat(appointments): add booking flow from chat (0eff4dd)
// Dans ChatDetailView : bouton "Book appointment"
// → Navigate vers TakeAppointmentView(dermatologistId:)
// → Après confirmation → retour au chat avec message automatique
```

---

## 5. Git — commits de la session

```
60f72be  Add appointment booking system for dermatologists and routes   (+621 lignes)
d8713f0  feat: update appointment backend logic for request-based booking system
7110b0a  wip(appointments): add appointment UI and backend connection structure (+851 lignes)
b522fe3  feat(appointments): add appointment calendar request UI           (+347 lignes)
6501ce1  feat(appointments): Connect dermatologist appointment requests to backend
1b850b3  feat(appointments): add user appointments overview
89d27f2  feat: add dermatologist request management ui
722a900  feat: add dermatologist availability system and fix appointment controller
0eff4dd  feat(appointments): add booking flow from chat
```

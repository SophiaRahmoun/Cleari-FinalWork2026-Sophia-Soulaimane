const express = require("express");
const router = express.Router();

const appointmentController = require("../controllers/appointmentController");
const authMiddleware = require("../middleware/authMiddleware");
const roleMiddleware = require("../middleware/roleMiddleware");

router.post(
  "/",
  authMiddleware,
  roleMiddleware("user"),
  appointmentController.createAppointment
);

router.get(
  "/me",
  authMiddleware,
  roleMiddleware("user"),
  appointmentController.getMyAppointments
);

router.get(
  "/dermatologist/me",
  authMiddleware,
  roleMiddleware("dermatologist"),
  appointmentController.getDermatologistAppointments
);

router.patch(
  "/:id/status",
  authMiddleware,
  roleMiddleware("dermatologist"),
  appointmentController.updateAppointmentStatus
);

router.patch(
  "/:id/cancel",
  authMiddleware,
  roleMiddleware("user"),
  appointmentController.cancelMyAppointment
);

module.exports = router;
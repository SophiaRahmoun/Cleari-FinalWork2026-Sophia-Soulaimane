const express = require("express");
const router = express.Router();
const availabilityController = require("../controllers/availabilityController");
const authMiddleware = require("../middleware/authMiddleware");
const roleMiddleware = require("../middleware/roleMiddleware");

router.post(
	"/",
	authMiddleware,
	roleMiddleware("dermatologist"),
	availabilityController.createAvailability
);

router.get(
	"/dermatologist/:id",
	authMiddleware,
	availabilityController.getAvailabilityByDermatologist
);

router.delete(
	"/:id",
	authMiddleware,
	roleMiddleware("dermatologist"),
	availabilityController.deleteAvailability
);

module.exports = router;

const express = require("express");
const router = express.Router();

const authMiddleware = require("../middleware/authMiddleware");

const {
	createCheckoutSession,
	getSubscriptionStatus,
} = require("../controllers/paymentController");

router.post(
	"/create-checkout-session",
	authMiddleware,
	createCheckoutSession
);

// Check if user premium
router.get(
	"/subscription-status",
	authMiddleware,
	getSubscriptionStatus
);

module.exports = router;
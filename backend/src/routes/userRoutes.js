const express = require("express");
const router = express.Router();

const authMiddleware = require("../middleware/authMiddleware");

const {
	getCurrentUser,
	updateUsername,
} = require("../controllers/userController");

router.get(
	"/me",
	authMiddleware,
	getCurrentUser
);

router.put(
	"/me/username",
	authMiddleware,
	updateUsername
);

module.exports = router;
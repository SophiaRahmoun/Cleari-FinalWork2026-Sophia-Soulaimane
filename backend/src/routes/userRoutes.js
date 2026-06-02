const express = require("express");
const router = express.Router();

const authMiddleware = require("../middleware/authMiddleware");
const upload = require("../middleware/uploadMiddleware");

const {
	getCurrentUser,
	updateUsername,
    updatePassword,
	updatePronouns,
	updateProfilePicture,
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
router.put(
	"/me/password",
	authMiddleware,
	updatePassword
);
router.put(
	"/me/pronouns",
	authMiddleware,
	updatePronouns
);

router.put(
	"/me/profile-picture",
	authMiddleware,
	upload.single("image"),
	updateProfilePicture
);

module.exports = router;
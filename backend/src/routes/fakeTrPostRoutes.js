const express = require("express");
const router = express.Router();

const authMiddleware = require("../middleware/authMiddleware");
const dermatologistOnlyMiddleware = require("../middleware/dermatologistOnlyMiddleware");
const upload = require("../middleware/fakeTrendUploadMiddleware");

const {
	createFakeTrendPost,
	getAllFakeTrendPosts,
	getFakeTrendPostById,
	getFakeTrendPostsByDermatologist,
	updateFakeTrendPost,
	deleteFakeTrendPost,
} = require("../controllers/fakeTrendPostController");

router.post(
	"/posts",
	authMiddleware,
	dermatologistOnlyMiddleware,
	upload.single("media"),
	createFakeTrendPost
);

router.get("/posts", getAllFakeTrendPosts);
router.get("/posts/:id", getFakeTrendPostById);
router.get("/dermatologists/:dermatologistId/posts", getFakeTrendPostsByDermatologist);

router.put(
	"/posts/:id",
	authMiddleware,
	dermatologistOnlyMiddleware,
	upload.single("media"),
	updateFakeTrendPost
);

router.delete(
	"/posts/:id",
	authMiddleware,
	dermatologistOnlyMiddleware,
	deleteFakeTrendPost
);

module.exports = router;
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

const {
	addScientificSource,
	getSourcesByPost,
	updateScientificSource,
	deleteScientificSource,
} = require("../controllers/fakeTrendScientificSourceController");

router.post(
	"/posts",
	authMiddleware,
	dermatologistOnlyMiddleware,
	upload.single("media"),
	createFakeTrendPost
);

router.get("/posts", getAllFakeTrendPosts);
router.get("/posts/:id", getFakeTrendPostById);
router.get(
	"/dermatologists/:dermatologistId/posts",
	getFakeTrendPostsByDermatologist
);

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
router.post(
	"/posts/:postId/sources",
	authMiddleware,
	dermatologistOnlyMiddleware,
	addScientificSource
);

router.get("/posts/:postId/sources", getSourcesByPost);

router.put(
	"/sources/:sourceId",
	authMiddleware,
	dermatologistOnlyMiddleware,
	updateScientificSource
);

router.delete(
	"/sources/:sourceId",
	authMiddleware,
	dermatologistOnlyMiddleware,
	deleteScientificSource
);

module.exports = router;

const express = require("express");
const router = express.Router();

const authMiddleware = require("../middleware/authMiddleware");
const dermatologistOnlyMiddleware = require("../middleware/dermatoloOnlyMiddleware");
const upload = require("../middleware/fakeTrendUplMiddleware");

const {
	createFakeTrendPost,
	getAllFakeTrendPosts,
	getFakeTrendPostById,
	getFakeTrendFeed,
	getFakeTrendPostsByDermatologist,
	updateFakeTrendPost,
	deleteFakeTrendPost,
} = require("../controllers/fakeTrendPostController");

const {
	createProReply,
	getProRepliesByPost,
	updateProReply,
	deleteProReply,
} = require("../controllers/FTProReplyController");

const {
	addScientificSource,
	getSourcesByPost,
	updateScientificSource,
	deleteScientificSource,
} = require("../controllers/fakeTrendScientificSourceController");

const {
	createFakeTrendComment,
	getFakeTrendCommentsByPost,
	updateFakeTrendComment,
	deleteFakeTrendComment,
} = require("../controllers/fakeTrendCommentController");

const {
	createDermatologistResponse,
	getDermatologistResponsesByPost,
	updateDermatologistResponse,
	deleteDermatologistResponse,
} = require("../controllers/FTDermatoResponseController");

const {
	saveFakeTrendPost,
	unsaveFakeTrendPost,
	getSavedFakeTrendPosts,
} = require("../controllers/FTSaveController");

const {
	likeFakeTrendPost,
	unlikeFakeTrendPost,
} = require("../controllers/fakeTrendLikeController");

router.post(
	"/posts",
	authMiddleware,
	dermatologistOnlyMiddleware,
	upload.single("media"),
	createFakeTrendPost
);

router.get("/posts", getAllFakeTrendPosts);
router.get("/feed", authMiddleware, getFakeTrendFeed);
router.get("/posts/:id", getFakeTrendPostById);
router.get(
	"/dermatologists/:dermatologistId/posts",
	getFakeTrendPostsByDermatologist
);
router.get("/saved-posts", authMiddleware, getSavedFakeTrendPosts);
router.get(
	"/dermatologists/:dermatologistId/posts",
	getFakeTrendPostsByDermatologist
);
router.get("/posts/:id", getFakeTrendPostById);
router.post("/posts/:postId/like", authMiddleware, likeFakeTrendPost);
router.delete("/posts/:postId/like", authMiddleware, unlikeFakeTrendPost);

router.post("/posts/:postId/save", authMiddleware, saveFakeTrendPost);
router.delete("/posts/:postId/save", authMiddleware, unsaveFakeTrendPost);

router.post("/posts/:postId/comments", authMiddleware, createFakeTrendComment);
router.get("/posts/:postId/comments", getFakeTrendCommentsByPost);
router.put("/comments/:commentId", authMiddleware, updateFakeTrendComment);
router.delete("/comments/:commentId", authMiddleware, deleteFakeTrendComment);

router.post(
	"/posts/:postId/sources",
	authMiddleware,
	dermatologistOnlyMiddleware,
	addScientificSource
);

router.post(
	"/posts/:postId/pro-replies",
	authMiddleware,
	dermatologistOnlyMiddleware,
	createProReply
);

router.get("/posts/:postId/pro-replies", getProRepliesByPost);

router.put(
	"/pro-replies/:replyId",
	authMiddleware,
	dermatologistOnlyMiddleware,
	updateProReply
);

router.delete(
	"/pro-replies/:replyId",
	authMiddleware,
	dermatologistOnlyMiddleware,
	deleteProReply
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
router.get("/posts/:postId/responses", getDermatologistResponsesByPost);

router.put(
	"/responses/:responseId",
	authMiddleware,
	dermatologistOnlyMiddleware,
	updateDermatologistResponse
);

router.delete(
	"/sources/:sourceId",
	authMiddleware,
	dermatologistOnlyMiddleware,
	deleteScientificSource
);
router.post(
	"/posts/:postId/responses",
	authMiddleware,
	dermatologistOnlyMiddleware,
	createDermatologistResponse
);

router.delete(
	"/responses/:responseId",
	authMiddleware,
	dermatologistOnlyMiddleware,
	deleteDermatologistResponse
);
module.exports = router;

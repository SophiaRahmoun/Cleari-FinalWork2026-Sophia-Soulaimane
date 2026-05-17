const express = require("express");
const router = express.Router();

const authMiddleware = require("../middleware/authMiddleware");
const upload = require("../middleware/uploadMiddleware");

const {
	createPost,
	getAllPosts,
	getPostById,
	getPostsByUser,
	updatePost,
	deletePost,
} = require("../controllers/communityPostController");

const {
	likePost,
	unlikePost,
} = require("../controllers/communityPostLikeController");

const {

	savePost,
	unsavePost,

} = require("../controllers/communityPostSaveController");

const {

	createComment,
	getCommentsByPost,
	updateComment,
	deleteComment,

} = require("../controllers/communityPostCommentController");


router.post("/posts", authMiddleware, upload.single("image"), createPost);
router.get("/posts", getAllPosts);
router.get("/users/:userId/posts", getPostsByUser);
router.put("/posts/:id", authMiddleware, upload.single("image"), updatePost);
router.delete("/posts/:id", authMiddleware, deletePost);
router.get("/posts/:id", getPostById);

router.post("/posts/:postId/like", authMiddleware, likePost);
router.delete("/posts/:postId/like", authMiddleware, unlikePost);

router.post("/posts/:postId/save", authMiddleware, savePost);
router.delete("/posts/:postId/save", authMiddleware, unsavePost);

router.post("/posts/:postId/comments", authMiddleware, createComment);
router.get("/posts/:postId/comments", getCommentsByPost);
router.put("/comments/:commentId", authMiddleware, updateComment);
router.delete("/comments/:commentId", authMiddleware, deleteComment);

module.exports = router;

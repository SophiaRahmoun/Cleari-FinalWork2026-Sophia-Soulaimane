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
router.post("/posts", authMiddleware, upload.single("image"), createPost);
router.get("/posts", getAllPosts);
router.get("/users/:userId/posts", getPostsByUser);
router.put("/posts/:id", authMiddleware, upload.single("image"), updatePost);
router.delete("/posts/:id", authMiddleware, deletePost);
router.get("/posts/:id", getPostById);
module.exports = router;

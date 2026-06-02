const CommunityPost = require("../models/CommunityPost");
const CommunityPostLike = require("../models/CommunityPostLike");

exports.likePost = async (req, res) => {
	try {
		const postId = req.params.postId;
		const userId = req.user.id;
		const post = await CommunityPost.findByPk(postId);
		if (!post) {
			return res.status(404).json({ message: "Post not found" });
		}
		const existingLike = await CommunityPostLike.findOne({
			where: { postId, userId },
		});
		if (existingLike) {
			return res.status(400).json({ message: "Post already liked" });
		}
		await CommunityPostLike.create({ postId, userId });
		const likesCount = await CommunityPostLike.count({
			where: { postId },
		});
		res.status(201).json({
			message: "Post liked successfully",
			likesCount,
			isLikedByCurrentUser: true,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error liking post",
			error: error.message,
		});
	}
};

exports.unlikePost = async (req, res) => {
	try {
		const postId = req.params.postId;
		const userId = req.user.id;
		const like = await CommunityPostLike.findOne({
			where: { postId, userId },
		});
		if (!like) {
			return res.status(404).json({ message: "Like not found" });
		}
		await like.destroy();
		const likesCount = await CommunityPostLike.count({
			where: { postId },
		});
		res.json({
			message: "Post unliked successfully",
			likesCount,
			isLikedByCurrentUser: false,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error unliking post",
			error: error.message,
		});
	}
};

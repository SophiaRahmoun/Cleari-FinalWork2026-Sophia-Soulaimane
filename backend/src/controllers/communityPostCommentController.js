const CommunityPost = require("../models/CommunityPost");
const CommunityPostComment = require("../models/CommunityPostComment");
const User = require("../models/User");

exports.createComment = async (req, res) => {
	try {
		const postId = req.params.postId;
		const userId = req.user.id;
		const { content } = req.body;
		if (!content || content.trim() === "") {
			return res.status(400).json({ message: "Comment content is required" });
		}

		const post = await CommunityPost.findByPk(postId);

		if (!post) {
			return res.status(404).json({ message: "Post not found" });
		}

		const comment = await CommunityPostComment.create({
			content,
			postId,
			userId,
		});

		res.status(201).json(comment);
	} catch (error) {
		res.status(500).json({
			message: "Error creating comment",
			error: error.message,
		});
	}
};

exports.getCommentsByPost = async (req, res) => {
	try {
		const postId = req.params.postId;

		const comments = await CommunityPostComment.findAll({
			where: { postId },
			include: [{ model: User, attributes: ["id", "username", "email"] }],
			order: [["createdAt", "ASC"]],
		});
		res.json(comments);
	} catch (error) {
		res.status(500).json({
			message: "Error fetching comments",
			error: error.message,
		});
	}
};

exports.updateComment = async (req, res) => {
	try {
		const comment = await CommunityPostComment.findByPk(req.params.commentId);

		if (!comment) {
			return res.status(404).json({ message: "Comment not found" });
		}
		if (comment.userId !== req.user.id) {
			return res.status(403).json({
				message: "You can only edit your own comment",
			});
		}

		comment.content = req.body.content || comment.content;
		await comment.save();

		res.json(comment);
	} catch (error) {
		res.status(500).json({
			message: "Error updating comment",
			error: error.message,
		});
	}
};

exports.deleteComment = async (req, res) => {
	try {
		const comment = await CommunityPostComment.findByPk(req.params.commentId);
		if (!comment) {
			return res.status(404).json({ message: "Comment not found" });
		}
		if (comment.userId !== req.user.id) {
			return res.status(403).json({
				message: "You can only delete your own comment",
			});
		}
		await comment.destroy();

		res.json({ message: "Comment deleted successfully" });
	} catch (error) {
		res.status(500).json({
			message: "Error deleting comment",
			error: error.message,
		});
	}
};

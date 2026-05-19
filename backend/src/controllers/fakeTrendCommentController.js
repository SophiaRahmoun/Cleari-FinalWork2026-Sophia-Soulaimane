const FakeTrendPost = require("../models/FakeTrendPost");
const FakeTrendComment = require("../models/FakeTrendComment");
const User = require("../models/User");

exports.createFakeTrendComment = async (req, res) => {
	try {
		const fakeTrendPostId = req.params.postId;
		const userId = req.user.id;
		const { content, parentCommentId } = req.body;
        

		if (!content || content.trim() === "") {
			return res.status(400).json({ message: "Comment content is required" });
		}

		const post = await FakeTrendPost.findByPk(fakeTrendPostId);

		if (!post) {
			return res.status(404).json({ message: "Fake trend post not found" });
		}

		const comment = await FakeTrendComment.create({
			content,
			userId,
			fakeTrendPostId,
			parentCommentId: parentCommentId || null,
		});

		res.status(201).json(comment);
	} catch (error) {
		res.status(500).json({
			message: "Error creating fake trend comment",
			error: error.message,
		});
	}
};

exports.getFakeTrendCommentsByPost = async (req, res) => {
	try {
		const fakeTrendPostId = req.params.postId;

		const comments = await FakeTrendComment.findAll({
			where: { fakeTrendPostId },
			include: [
				{ model: User, attributes: ["id", "username", "email", "role"] },
				{
					model: FakeTrendComment,
					as: "childComments",
					include: [
						{
							model: User,
							attributes: ["id", "username", "email", "role"],
						},
					],
				},
			],
			order: [["createdAt", "ASC"]],
		});

		const topLevelComments = comments.filter(
			(comment) => !comment.parentCommentId
		);

		res.json(topLevelComments);
	} catch (error) {
		res.status(500).json({
			message: "Error fetching fake trend comments",
			error: error.message,
		});
	}
};

exports.updateFakeTrendComment = async (req, res) => {
	try {
		const comment = await FakeTrendComment.findByPk(req.params.commentId);
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
			message: "Error updating fake trend comment",
			error: error.message,
		});
	}
};

exports.deleteFakeTrendComment = async (req, res) => {
	try {
		const comment = await FakeTrendComment.findByPk(req.params.commentId);
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
			message: "Error deleting fake trend comment",
			error: error.message,
		});
	}
};

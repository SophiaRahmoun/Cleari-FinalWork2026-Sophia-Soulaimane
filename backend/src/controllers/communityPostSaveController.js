const CommunityPost = require("../models/CommunityPost");
const CommunityPostSave = require("../models/CommunityPostSave");

const User = require("../models/User");
const CommunityPostLike = require("../models/CommunityPostLike");
const CommunityPostComment = require("../models/CommunityPostComment");

exports.savePost = async (req, res) => {
	try {
		const postId = req.params.postId;
		const userId = req.user.id;
		const post = await CommunityPost.findByPk(postId);
		if (!post) {
			return res.status(404).json({ message: "Post not found" });
		}
		const existingSave = await CommunityPostSave.findOne({
			where: { postId, userId },
		});
		if (existingSave) {
			return res.status(400).json({ message: "Post already saved" });
		}
		await CommunityPostSave.create({ postId, userId });
		res.status(201).json({
			message: "Post saved successfully",
			isSavedByCurrentUser: true,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error saving post",
			error: error.message,
		});
	}
};

exports.unsavePost = async (req, res) => {
	try {
		const postId = req.params.postId;
		const userId = req.user.id;
		const savedPost = await CommunityPostSave.findOne({
			where: { postId, userId },
		});
		if (!save) {
			return res.status(404).json({ message: "Save not found" });
		}
		await savedPost.destroy();
		res.json({
			message: "Post unsaved successfully",
			isSavedByCurrentUser: false,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error unsaving post",
			error: error.message,
		});
	}
};

exports.getSavedPosts = async (req, res) => {
	try {
		const userId = req.user.id;
		const savedPosts = await CommunityPostSave.findAll({
			where: { userId },
			include: [
				{
					model: CommunityPost,
					include: [{ model: User, attributes: ["id", "username", "email"] }],
				},
			],
			order: [["createdAt", "DESC"]],
		});

		const posts = await Promise.all(
			savedPosts.map(async (savedPost) => {
				const post = savedPost.CommunityPost;
				const likesCount = await CommunityPostLike.count({
					where: { postId: post.id },
				});
				const commentsCount = await CommunityPostComment.count({
					where: { postId: post.id },
				});


				const isLikedByCurrentUser = await CommunityPostLike.findOne({
					where: { postId: post.id, userId },
				});
				return {
					...post.toJSON(),
					likesCount,
					commentsCount,
					isLikedByCurrentUser: !!isLikedByCurrentUser,
					isSavedByCurrentUser: true,
				};
			})
		);

		res.json(posts);
	} catch (error) {
		res.status(500).json({
			message: "Error fetching saved posts",
			error: error.message,
		});
	}
};

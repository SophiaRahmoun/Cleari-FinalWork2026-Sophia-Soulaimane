const CommunityPost = require("../models/CommunityPost");

const User = require("../models/User");
const CommunityPostLike = require("../models/CommunityPostLike");
const { Op } = require("sequelize");
const fs = require("fs");
const path = require("path");

const CommunityPostSave = require("../models/CommunityPostSave");
const CommunityPostComment = require("../models/CommunityPostComment");
const SkinFormAnswer = require("../models/SkinFormAnswer");

exports.createPost = async (req, res) => {
	try {
		const { content } = req.body;

		const imageUrl = req.file
			? `/uploads/community/${req.file.filename}`
			: null;

		const post = await CommunityPost.create({
			content,
			imageUrl,
			userId: req.user.id,
		});

		res.status(201).json(post);
	} catch (error) {
		res
			.status(500)
			.json({ message: "Error creating post", error: error.message });
	}
};

exports.getAllPosts = async (req, res) => {
	try {
		const posts = await CommunityPost.findAll({
			include: [{ model: User, attributes: ["id", "username", "email"] }],
			order: [["createdAt", "DESC"]],
		});

		const postsWithLikes = await Promise.all(
			posts.map(async (post) => {
				const likesCount = await CommunityPostLike.count({
					where: { postId: post.id },
				});
				return {
					...post.toJSON(),
					likesCount,
				};
			})
		);

		res.json(postsWithLikes);
	} catch (error) {
		res
			.status(500)
			.json({ message: "Error fetching posts", error: error.message });
	}
};

exports.getPostsByUser = async (req, res) => {
	try {
		const posts = await CommunityPost.findAll({
			where: { userId: req.params.userId },
			order: [["createdAt", "DESC"]],
		});

		res.json(posts);
	} catch (error) {
		res
			.status(500)
			.json({ message: "Error fetching user posts", error: error.message });
	}
};

exports.updatePost = async (req, res) => {
	try {
		const post = await CommunityPost.findByPk(req.params.id);
		if (!post) return res.status(404).json({ message: "Post not found" });

		if (post.userId !== req.user.id) {
			return res
				.status(403)
				.json({ message: "You can only edit your own post" });
		}

		post.content = req.body.content || post.content;

		if (req.file) {
			post.imageUrl = `/uploads/community/${req.file.filename}`;
		}

		await post.save();

		res.json(post);
	} catch (error) {
		res
			.status(500)
			.json({ message: "Error updating post", error: error.message });
	}
};

exports.deletePost = async (req, res) => {
	try {
		const post = await CommunityPost.findByPk(req.params.id);
		if (!post) return res.status(404).json({ message: "Post not found" });
		if (post.userId !== req.user.id) {
			return res
				.status(403)
				.json({ message: "You can only delete your own post" });
		}

        if (post.imageUrl) {
            const imagePath = path.join(__dirname, "../../", post.imageUrl.replace(/^\/+/, ""));
            
            if (fs.existsSync(imagePath)) {
                fs.unlinkSync(imagePath);
            }
        }
		await post.destroy();
		res.json({ message: "Post deleted successfully" });
	} catch (error) {
		res
			.status(500)
			.json({ message: "Error deleting post", error: error.message });
	}
};

exports.getPostById = async (req, res) => {
	try {
		const post = await CommunityPost.findByPk(req.params.id, {
			include: [{ model: User, attributes: ["id", "username", "email"] }],
		});
		if (!post) return res.status(404).json({ message: "Post not found" });

		const likesCount = await CommunityPostLike.count({
			where: { postId: post.id },
		});
		res.json({
			...post.toJSON(),
			likesCount,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error fetching post",
			error: error.message,
		});
	}
};

exports.getPersonalizedFeed = async (req, res) => {
	try {
		const userId = req.user.id;

		const page = parseInt(req.query.page) || 1;
		const limit = parseInt(req.query.limit) || 10;
		const offset = (page - 1) * limit;

		const currentUserSkinForm = await SkinFormAnswer.findOne({
			where: { user_id: userId },
			order: [["created_at", "DESC"]],
		});

		const posts = await CommunityPost.findAll({
			include: [{ model: User, attributes: ["id", "username", "email"] }],
			order: [["createdAt", "DESC"]],
			limit: limit * 3,
			offset,
		});

		const enrichedPosts = await Promise.all(
			posts.map(async (post) => {
				const postJson = post.toJSON();

				const authorSkinForm = await SkinFormAnswer.findOne({
					where: { user_id: post.userId },
					order: [["created_at", "DESC"]],
				});

				let matchScore = 0;

				if (currentUserSkinForm && authorSkinForm) {
					if (
						currentUserSkinForm.main_concern &&
						currentUserSkinForm.main_concern === authorSkinForm.main_concern
					) {
						matchScore += 3;
					}

					if (
						currentUserSkinForm.skin_feeling &&
						currentUserSkinForm.skin_feeling === authorSkinForm.skin_feeling
					) {
						matchScore += 2;
					}

					if (
						currentUserSkinForm.diagnosed_condition &&
						currentUserSkinForm.diagnosed_condition ===
							authorSkinForm.diagnosed_condition
					) {
						matchScore += 2;
					}

					if (
						currentUserSkinForm.product_reaction &&
						currentUserSkinForm.product_reaction ===
							authorSkinForm.product_reaction
					) {
						matchScore += 1;
					}
				}

				const likesCount = await CommunityPostLike.count({
					where: { postId: post.id },
				});
				const commentsCount = await CommunityPostComment.count({
					where: { postId: post.id },
				});
				const isLikedByCurrentUser = await CommunityPostLike.findOne({
					where: { postId: post.id, userId },
				});
				const isSavedByCurrentUser = await CommunityPostSave.findOne({
					where: { postId: post.id, userId },
				});

				return {
					...postJson,
					matchScore,
					likesCount,
					commentsCount,
					isLikedByCurrentUser: !!isLikedByCurrentUser,
					isSavedByCurrentUser: !!isSavedByCurrentUser,
					authorSkinProfile: authorSkinForm
						? {
								mainConcern: authorSkinForm.main_concern,
								skinFeeling: authorSkinForm.skin_feeling,
								diagnosedCondition: authorSkinForm.diagnosed_condition,
							}
						: null,
				};
			})
		);

		const sortedPosts = enrichedPosts
			.sort((a, b) => {
				if (b.matchScore !== a.matchScore) {
					return b.matchScore - a.matchScore;
				}

				return new Date(b.createdAt) - new Date(a.createdAt);
			})
			.slice(0, limit);

		res.json({
			page,
			limit,
			hasMore: posts.length > limit,
			posts: sortedPosts,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error fetching personalized feed",
			error: error.message,
		});
	}
};

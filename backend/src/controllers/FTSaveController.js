const FakeTrendPost = require("../models/FakeTrendPost");
const FakeTrendSave = require("../models/FakeTrendSave");
const FakeTrendLike = require("../models/FakeTrendLike");
const FakeTrendComment = require("../models/FakeTrendComment");
const User = require("../models/User");

exports.saveFakeTrendPost = async (req, res) => {
	try {
		const fakeTrendPostId = req.params.postId;
		const userId = req.user.id;

		const post = await FakeTrendPost.findByPk(fakeTrendPostId);

		if (!post) {
			return res.status(404).json({ message: "Fake trend post not found" });
		}

		const existingSave = await FakeTrendSave.findOne({
			where: { fakeTrendPostId, userId },
		});

		if (existingSave) {
			return res.status(400).json({ message: "Post already saved" });
		}

		await FakeTrendSave.create({ fakeTrendPostId, userId });

		res.status(201).json({
			message: "Fake trend post saved successfully",
			isSavedByCurrentUser: true,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error saving fake trend post",
			error: error.message,
		});
	}
};

exports.unsaveFakeTrendPost = async (req, res) => {
	try {
		const fakeTrendPostId = req.params.postId;
		const userId = req.user.id;

		const savedPost = await FakeTrendSave.findOne({
			where: { fakeTrendPostId, userId },
		});

		if (!savedPost) {
			return res.status(404).json({ message: "Saved post not found" });
		}

		await savedPost.destroy();

		res.json({
			message: "Fake trend post unsaved successfully",
			isSavedByCurrentUser: false,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error unsaving fake trend post",
			error: error.message,
		});
	}
};

exports.getSavedFakeTrendPosts = async (req, res) => {
	try {
		const userId = req.user.id;

		const savedPosts = await FakeTrendSave.findAll({
			where: { userId },
			include: [
				{
					model: FakeTrendPost,
					include: [
						{
							model: User,
							as: "dermatologist",
							attributes: ["id", "username", "email", "role"],
						},
					],
				},
			],
			order: [["createdAt", "DESC"]],
		});

		const posts = await Promise.all(
			savedPosts.map(async (savedPost) => {
				const post = savedPost.FakeTrendPost;

				const likesCount = await FakeTrendLike.count({
					where: { fakeTrendPostId: post.id },
				});

				const commentsCount = await FakeTrendComment.count({
					where: { fakeTrendPostId: post.id },
				});

				const isLikedByCurrentUser = await FakeTrendLike.findOne({
					where: { fakeTrendPostId: post.id, userId },
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
			message: "Error fetching saved fake trend posts",
			error: error.message,
		});
	}
};

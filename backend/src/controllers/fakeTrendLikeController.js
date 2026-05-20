const FakeTrendPost = require("../models/FakeTrendPost");

const FakeTrendLike = require("../models/FakeTrendLike");

exports.likeFakeTrendPost = async (req, res) => {
	try {
		const fakeTrendPostId = req.params.postId;
		const userId = req.user.id;
		const post = await FakeTrendPost.findByPk(fakeTrendPostId);
		if (!post) {
			return res.status(404).json({ message: "Fake trend post not found" });
		}
		const existingLike = await FakeTrendLike.findOne({
			where: { fakeTrendPostId, userId },
		});
		if (existingLike) {
			return res.status(400).json({ message: "Post already liked" });
		}
		await FakeTrendLike.create({ fakeTrendPostId, userId });
		const likesCount = await FakeTrendLike.count({
			where: { fakeTrendPostId },
		});
		res.status(201).json({
			message: "Fake trend post liked successfully",
			likesCount,
			isLikedByCurrentUser: true,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error liking fake trend post",
			error: error.message,
		});
	}
};

exports.unlikeFakeTrendPost = async (req, res) => {
	try {
		const fakeTrendPostId = req.params.postId;
		const userId = req.user.id;
		const like = await FakeTrendLike.findOne({
			where: { fakeTrendPostId, userId },
		});
		if (!like) {
			return res.status(404).json({ message: "Like not found" });
		}
		await like.destroy();
		const likesCount = await FakeTrendLike.count({
			where: { fakeTrendPostId },
		});
		res.json({
			message: "Fake trend post unliked successfully",
			likesCount,
			isLikedByCurrentUser: false,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error unliking fake trend post",
			error: error.message,
		});
	}
};

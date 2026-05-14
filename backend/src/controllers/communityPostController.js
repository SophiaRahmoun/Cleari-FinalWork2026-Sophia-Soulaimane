const CommunityPost = require("../models/CommunityPost");

const User = require("../models/User");

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

		res.json(posts);
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

		await post.destroy();

		res.json({ message: "Post deleted successfully" });
	} catch (error) {
		res
			.status(500)
			.json({ message: "Error deleting post", error: error.message });
	}
};

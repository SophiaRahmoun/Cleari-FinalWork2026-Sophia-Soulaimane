const fs = require("fs");

const path = require("path");

const FakeTrendPost = require("../models/FakeTrendPost");

const User = require("../models/User");

const {
	extractTikTokVideoId,
	isValidTikTokUrl,
} = require("../utils/tiktokUtils");

function formatFakeTrendPost(post) {
	const json = post.toJSON();
	let scientificSources = [];
	if (json.scientificSources) {
		try {
			scientificSources = JSON.parse(json.scientificSources);
		} catch (error) {
			scientificSources = [];
		}
	}
	return {
		...json,
		scientificSources,
		tiktokPreview: json.tiktokUrl
			? {
					url: json.tiktokUrl,
					videoId: json.tiktokVideoId,
				}
			: null,
	};
}

exports.createFakeTrendPost = async (req, res) => {
	try {
		const {
			title,
			trendName,
			description,
			debunkExplanation,
			tiktokUrl,
			scientificSources,
			skinConcernTag,
			status,
		} = req.body;
		if (!title || !trendName || !description || !debunkExplanation) {
			return res.status(400).json({
				message:
					"title, trendName, description and debunkExplanation are required",
			});
		}
		if (tiktokUrl && !isValidTikTokUrl(tiktokUrl)) {
			return res.status(400).json({
				message: "Invalid TikTok URL",
			});
		}
		let parsedSources = [];
		if (scientificSources) {
			try {
				parsedSources = JSON.parse(scientificSources);
			} catch (error) {
				return res.status(400).json({
					message: "scientificSources must be a valid JSON array",
				});
			}
		}
		const mediaUrl = req.file
			? `/uploads/fake-trends/${req.file.filename}`
			: null;
		const post = await FakeTrendPost.create({
			title,
			trendName,
			description,
			debunkExplanation,
			tiktokUrl,
			tiktokVideoId: extractTikTokVideoId(tiktokUrl),
			imageUrl: mediaUrl,
			scientificSources: JSON.stringify(parsedSources),
			skinConcernTag,
			status: status || "published",
			dermatologistId: req.user.id,
		});
		res.status(201).json(formatFakeTrendPost(post));
	} catch (error) {
		res.status(500).json({
			message: "Error creating fake trend post",
			error: error.message,
		});
	}
};

exports.getAllFakeTrendPosts = async (req, res) => {
	try {
		const posts = await FakeTrendPost.findAll({
			include: [
				{
					model: User,
					as: "dermatologist",
					attributes: ["id", "username", "email", "role"],
				},
			],
			order: [["createdAt", "DESC"]],
		});
		res.json(posts.map(formatFakeTrendPost));
	} catch (error) {
		res.status(500).json({
			message: "Error fetching fake trend posts",
			error: error.message,
		});
	}
};

exports.getFakeTrendPostById = async (req, res) => {
	try {
		const post = await FakeTrendPost.findByPk(req.params.id, {
			include: [
				{
					model: User,
					as: "dermatologist",
					attributes: ["id", "username", "email", "role"],
				},
			],
		});
		if (!post) {
			return res.status(404).json({ message: "Fake trend post not found" });
		}
		res.json(formatFakeTrendPost(post));
	} catch (error) {
		res.status(500).json({
			message: "Error fetching fake trend post",
			error: error.message,
		});
	}
};

exports.getFakeTrendPostsByDermatologist = async (req, res) => {
	try {
		const posts = await FakeTrendPost.findAll({
			where: { dermatologistId: req.params.dermatologistId },
			include: [
				{
					model: User,
					as: "dermatologist",
					attributes: ["id", "username", "email", "role"],
				},
			],
			order: [["createdAt", "DESC"]],
		});
		res.json(posts.map(formatFakeTrendPost));
	} catch (error) {
		res.status(500).json({
			message: "Error fetching dermatologist fake trend posts",
			error: error.message,
		});
	}
};

exports.updateFakeTrendPost = async (req, res) => {
	try {
		const post = await FakeTrendPost.findByPk(req.params.id);
		if (!post) {
			return res.status(404).json({ message: "Fake trend post not found" });
		}
		if (post.dermatologistId !== req.user.id) {
			return res.status(403).json({
				message: "You can only edit your own fake trend post",
			});
		}
		const {
			title,
			trendName,
			description,
			debunkExplanation,
			tiktokUrl,
			scientificSources,
			skinConcernTag,
			status,
		} = req.body;
		if (tiktokUrl && !isValidTikTokUrl(tiktokUrl)) {
			return res.status(400).json({
				message: "Invalid TikTok URL",
			});
		}
		if (scientificSources) {
			try {
				post.scientificSources = JSON.stringify(JSON.parse(scientificSources));
			} catch (error) {
				return res.status(400).json({
					message: "scientificSources must be a valid JSON array",
				});
			}
		}
		if (req.file) {
			if (post.imageUrl) {
				const oldImagePath = path.join(
					__dirname,
					"../../",
					post.imageUrl.replace(/^\/+/, "")
				);
				if (fs.existsSync(oldImagePath)) {
					fs.unlinkSync(oldImagePath);
				}
			}
			post.imageUrl = `/uploads/fake-trends/${req.file.filename}`;
		}
		post.title = title || post.title;
		post.trendName = trendName || post.trendName;
		post.description = description || post.description;
		post.debunkExplanation = debunkExplanation || post.debunkExplanation;
		post.tiktokUrl = tiktokUrl || post.tiktokUrl;
		post.tiktokVideoId = tiktokUrl
			? extractTikTokVideoId(tiktokUrl)
			: post.tiktokVideoId;
		post.skinConcernTag = skinConcernTag || post.skinConcernTag;
		post.status = status || post.status;
		await post.save();
		res.json(formatFakeTrendPost(post));
	} catch (error) {
		res.status(500).json({
			message: "Error updating fake trend post",
			error: error.message,
		});
	}
};

exports.deleteFakeTrendPost = async (req, res) => {
	try {
		const post = await FakeTrendPost.findByPk(req.params.id);
		if (!post) {
			return res.status(404).json({ message: "Fake trend post not found" });
		}
		if (post.dermatologistId !== req.user.id) {
			return res.status(403).json({
				message: "You can only delete your own fake trend post",
			});
		}
		if (post.imageUrl) {
			const imagePath = path.join(
				__dirname,
				"../../",
				post.imageUrl.replace(/^\/+/, "")
			);
			if (fs.existsSync(imagePath)) {
				fs.unlinkSync(imagePath);
			}
		}
		await post.destroy();
		res.json({ message: "Fake trend post deleted successfully" });
	} catch (error) {
		res.status(500).json({
			message: "Error deleting fake trend post",
			error: error.message,
		});
	}
};

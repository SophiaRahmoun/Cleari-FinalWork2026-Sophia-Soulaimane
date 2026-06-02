const FakeTrendPost = require("../models/FakeTrendPost");
const FTProReply = require("../models/FTProReply");
const User = require("../models/User");

function formatProReply(reply) {
	const json = reply.toJSON();
	let sourceUrls = [];
	if (json.sourceUrls) {
		try {
			sourceUrls = JSON.parse(json.sourceUrls);
		} catch (error) {
			sourceUrls = [];
		}
	}
	return {
		...json,
		sourceUrls,
		visualStance: {
			type: json.stance,
			icon:
				json.stance === "agree"
					? "thumb_up"
					: json.stance === "disagree"
						? "cross"
						: "neutral",
		},
	};
}

exports.createProReply = async (req, res) => {
	try {
		const fakeTrendPostId = req.params.postId;
		const dermatologistId = req.user.id;
		const { content, stance, sourceUrls, parentReplyId } = req.body;
		if (!content || content.trim() === "") {
			return res.status(400).json({
				message: "Reply content is required",
			});
		}
		const post = await FakeTrendPost.findByPk(fakeTrendPostId);
		if (!post) {
			return res.status(404).json({
				message: "Fake trend post not found",
			});
		}
		let parsedSources = [];
		if (sourceUrls) {
			try {
				parsedSources = JSON.parse(sourceUrls);
			} catch (error) {
				return res.status(400).json({
					message: "sourceUrls must be a valid JSON array",
				});
			}
		}
		const reply = await FTProReply.create({
			content,
			stance: stance || "neutral",
			sourceUrls: JSON.stringify(parsedSources),
			dermatologistId,
			fakeTrendPostId,
			parentReplyId: parentReplyId || null,
		});
		res.status(201).json(formatProReply(reply));
	} catch (error) {
		res.status(500).json({
			message: "Error creating professional reply",
			error: error.message,
		});
	}
};

exports.getProRepliesByPost = async (req, res) => {
	try {
		const fakeTrendPostId = req.params.postId;
		const replies = await FTProReply.findAll({
			where: { fakeTrendPostId },
			include: [
				{
					model: User,
					as: "dermatologist",
					attributes: ["id", "username", "email", "role"],
				},
				{
					model: FTProReply,
					as: "childReplies",
					include: [
						{
							model: User,
							as: "dermatologist",
							attributes: ["id", "username", "email", "role"],
						},
					],
				},
			],
			order: [["createdAt", "ASC"]],
		});
		const topLevelReplies = replies.filter((reply) => !reply.parentReplyId);
		res.json(topLevelReplies.map(formatProReply));
	} catch (error) {
		res.status(500).json({
			message: "Error fetching professional replies",
			error: error.message,
		});
	}
};

exports.updateProReply = async (req, res) => {
	try {
		const reply = await FTProReply.findByPk(req.params.replyId);
		if (!reply) {
			return res.status(404).json({
				message: "Professional reply not found",
			});
		}
		if (reply.dermatologistId !== req.user.id) {
			return res.status(403).json({
				message: "You can only edit your own professional reply",
			});
		}
		const { content, stance, sourceUrls } = req.body;
		if (content) reply.content = content;
		if (stance) reply.stance = stance;
		if (sourceUrls) {
			try {
				reply.sourceUrls = JSON.stringify(JSON.parse(sourceUrls));
			} catch (error) {
				return res.status(400).json({
					message: "sourceUrls must be a valid JSON array",
				});
			}
		}
		await reply.save();
		res.json(formatProReply(reply));
	} catch (error) {
		res.status(500).json({
			message: "Error updating professional reply",
			error: error.message,
		});
	}
};

exports.deleteProReply = async (req, res) => {
	try {
		const reply = await FTProReply.findByPk(req.params.replyId);
		if (!reply) {
			return res.status(404).json({
				message: "Professional reply not found",
			});
		}
		if (reply.dermatologistId !== req.user.id) {
			return res.status(403).json({
				message: "You can only delete your own professional reply",
			});
		}
		await reply.destroy();
		res.json({
			message: "Professional reply deleted successfully",
		});
	} catch (error) {
		res.status(500).json({
			message: "Error deleting professional reply",
			error: error.message,
		});
	}
};

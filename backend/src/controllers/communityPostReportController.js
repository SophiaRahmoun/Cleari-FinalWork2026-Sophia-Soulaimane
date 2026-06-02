const CommunityPost = require("../models/CommunityPost");

const CommunityPostReport = require("../models/CommunityPostReport");

const User = require("../models/User");

exports.reportCommunityPost = async (req, res) => {
	try {
		const postId = req.params.postId;
		const dermatologistId = req.user.id;
		const { reason, description } = req.body;
		if (!reason) {
			return res.status(400).json({ message: "Report reason is required" });
		}
		const post = await CommunityPost.findByPk(postId);
		if (!post) {
			return res.status(404).json({ message: "Community post not found" });
		}
		const report = await CommunityPostReport.create({
			postId,
			dermatologistId,
			reason,
			description,
		});
		res.status(201).json({
			message: "Community post reported successfully",
			report,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error reporting community post",
			error: error.message,
		});
	}
};

exports.getCommunityPostReports = async (req, res) => {
	try {
		const reports = await CommunityPostReport.findAll({
			include: [
				{
					model: User,
					as: "dermatologist",
					attributes: ["id", "username", "email", "role"],
				},
				{
					model: CommunityPost,
				},
			],
			order: [["createdAt", "DESC"]],
		});
		res.json(reports);
	} catch (error) {
		res.status(500).json({
			message: "Error fetching community post reports",
			error: error.message,
		});
	}
};

const FakeTrendPost = require("../models/FakeTrendPost");

const FakeTrendPostReport = require("../models/FakeTrendPostReport");

const User = require("../models/User");

exports.reportFakeTrendPost = async (req, res) => {
	try {
		const fakeTrendPostId = req.params.postId;
		const dermatologistId = req.user.id;
		const { reason, description } = req.body;
		if (!reason) {
			return res.status(400).json({ message: "Report reason is required" });
		}
		const post = await FakeTrendPost.findByPk(fakeTrendPostId);
		if (!post) {
			return res.status(404).json({ message: "Fake trend post not found" });
		}
		const report = await FakeTrendPostReport.create({
			fakeTrendPostId,
			dermatologistId,
			reason,
			description,
		});
		res.status(201).json({
			message: "Fake trend post reported successfully",
			report,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error reporting fake trend post",
			error: error.message,
		});
	}
};

exports.getFakeTrendPostReports = async (req, res) => {
	try {
		const reports = await FakeTrendPostReport.findAll({
			include: [
				{
					model: User,
					as: "dermatologist",
					attributes: ["id", "username", "email", "role"],
				},
				{
					model: FakeTrendPost,
				},
			],
			order: [["createdAt", "DESC"]],
		});
		res.json(reports);
	} catch (error) {
		res.status(500).json({
			message: "Error fetching fake trend post reports",
			error: error.message,
		});
	}
};

const { Op } = require("sequelize");
const { SkinAnalysis, Subscription } = require("../models");
const { analyzeWithYouCam } = require("../services/youcamService");
const { buildSkinInsights } = require("../utils/skinInsightsBuilder");
const uploadToCloudinary = require("../utils/uploadToCloudinary");

async function createSkinScan(req, res) {
	try {
		console.log("SCAN FILE RECEIVED:", !!req.file, req.file?.originalname);

		if (!req.file) {
			return res.status(400).json({
				success: false,
				message:
					"No image uploaded. Send multipart/form-data with field name 'image'.",
			});
		}

		// Scan limit: 1 per week
		const oneWeekAgo = new Date();
		oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
		const recentScan = await SkinAnalysis.findOne({
			where: {
				user_id: req.user.id,
				createdAt: { [Op.gte]: oneWeekAgo },
			},
		});
		if (recentScan) {
			return res.status(429).json({
				success: false,
				message: "You can only scan once per week.",
			});
		}

		const totalScans = await SkinAnalysis.count({
			where: { user_id: req.user.id },
		});
		if (totalScans >= 1) {
			const activeSubscription = await Subscription.findOne({
				where: { user_id: req.user.id, status: "active" },
			});
			if (!activeSubscription) {
				return res.status(403).json({
					success: false,
					message:
						"You have used your free scan. Subscribe to unlock more scans.",
				});
			}
		}

		const cloudinaryResult = await uploadToCloudinary(
			req.file.buffer,
			"cleari/skin-scans"
		);
		console.log("CLOUDINARY SCAN URL:", cloudinaryResult.secure_url);

		const analysis = await analyzeWithYouCam({
			buffer: req.file.buffer,
			originalname: req.file.originalname,
			mimetype: req.file.mimetype,
		});
		const insights = buildSkinInsights(analysis.simplified.scores);
		analysis.simplified.insights = insights;

		const savedAnalysis = await SkinAnalysis.create({
			user_id: req.user.id,
			image_url: cloudinaryResult.secure_url,
			result: JSON.stringify(analysis.simplified),
			raw_result_json: JSON.stringify(analysis.raw),
		});
		console.log("SCAN SAVED IMAGE URL:", savedAnalysis.image_url);

		return res.status(201).json({
			success: true,
			message: "Skin scan completed successfully",
			analysis: savedAnalysis,
			scan: analysis.simplified,
		});
	} catch (error) {
		console.error("Skin scan error:", error.response?.data || error.message);
		return res.status(500).json({
			success: false,
			message: "Skin scan failed",
			error: error.response?.data || error.message,
		});
	}
}

exports.getLatestScan = async (req, res) => {
	try {
		const latest = await SkinAnalysis.findOne({
			where: { user_id: req.user.id },
			order: [["createdAt", "DESC"]],
		});
		if (!latest) {
			return res.status(404).json({ message: "No scan found" });
		}
		return res.status(200).json({ scan: latest });
	} catch (error) {
		return res
			.status(500)
			.json({ message: "Error fetching latest scan", error: error.message });
	}
};

exports.getScanHistory = async (req, res) => {
	try {
		const scans = await SkinAnalysis.findAll({
			where: { user_id: req.user.id },
			order: [["createdAt", "DESC"]],
		});
		return res.status(200).json({ scans });
	} catch (error) {
		return res
			.status(500)
			.json({ message: "Error fetching scan history", error: error.message });
	}
};

module.exports = {
	createSkinScan,
	getLatestScan: exports.getLatestScan,
	getScanHistory: exports.getScanHistory,
};

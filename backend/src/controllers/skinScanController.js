const { SkinAnalysis } = require("../models");
const { analyzeWithYouCam } = require("../services/youcamService");

const { buildSkinInsights } = require("../utils/skinInsightsBuilder");

async function createSkinScan(req, res) {
	try {
		if (!req.file) {
			return res.status(400).json({
				success: false,
				message: "No image uploaded",
			});
		}

		const analysis = await analyzeWithYouCam(req.file);

		const insights = buildSkinInsights(analysis.simplified.scores);
		analysis.simplified.insights = insights;

		const savedAnalysis = await SkinAnalysis.create({
			user_id: req.user.id,
			image_url: req.file.path,
			result: JSON.stringify(analysis.simplified),
			raw_result_json: JSON.stringify(analysis.raw),
		});

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
			return res.status(404).json({
				message: "No scan found",
			});
		}
		return res.status(200).json({
			scan: latest,
		});
	} catch (error) {
		return res.status(500).json({
			message: "Error fetching latest scan",
			error: error.message,
		});
	}

};

exports.getScanHistory = async (req, res) => {
  try {
    const scans = await SkinAnalysis.findAll({
      where: { user_id: req.user.id },
      order: [["createdAt", "DESC"]],
    });

    return res.status(200).json({
      scans,
    });
  }catch (error) {
    return res.status(500).json({
      message: "Error fetching scan history",
      error: error.message,
    });
  }
}

module.exports = {
	createSkinScan,
	getLatestScan: exports.getLatestScan,
	getScanHistory: exports.getScanHistory,
};

const { SkinAnalysis } = require("../models");
const { analyzeWithYouCam } = require("../services/youcamService");

async function createSkinScan(req, res) {
    try {
      if (!req.file) {
        return res.status(400).json({
          success: false,
          message: "No image uploaded",
        });
      }
  
      const analysis = await analyzeWithYouCam(req.file);
  
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
  
  module.exports = {
    createSkinScan
  };
const {
    initializeFileUpload,
    uploadFileToPresignedUrl,
    createSkinAnalysisTask,
    pollSkinAnalysisResult
  } = require("../services/youcamService");
  
  const {
    simplifySkinAnalysisResults,
    buildRecommendation
  } = require("../utils/skinAnalysisMapper");
  
  async function createSkinScan(req, res) {
    try {
      if (!req.file) {
        return res.status(400).json({
          success: false,
          message: "No image uploaded"
        });
      }
  
      const mimeType = req.file.mimetype;
      const fileName = req.file.originalname || `scan-${Date.now()}.jpg`;
      const fileSize = req.file.size;
  
      const fileInitResponse = await initializeFileUpload({
        contentType: mimeType,
        fileName,
        fileSize
      });
  
      const uploadedFile = fileInitResponse?.data?.files?.[0];
  
      if (!uploadedFile) {
        throw new Error("Could not initialize upload with YouCam");
      }
  
      const uploadRequest = uploadedFile.requests?.[0];
  
      if (!uploadRequest?.url) {
        throw new Error("Missing pre-signed upload URL");
      }
  
      await uploadFileToPresignedUrl({
        url: uploadRequest.url,
        headers: uploadRequest.headers,
        fileBuffer: req.file.buffer
      });
  
      const taskResponse = await createSkinAnalysisTask({
        srcFileId: uploadedFile.file_id
      });
  
      const taskId = taskResponse?.data?.task_id;
  
      if (!taskId) {
        throw new Error("No task_id returned by YouCam");
      }
  
      const finalResult = await pollSkinAnalysisResult(taskId);
  
      const simplifiedScores = simplifySkinAnalysisResults(finalResult);
      const recommendation = buildRecommendation(simplifiedScores);
  
      return res.json({
        success: true,
        taskId,
        scan: {
          scores: simplifiedScores,
          ...recommendation
        },
        raw: finalResult
      });
    } catch (error) {
      console.error("Skin scan error:", error.response?.data || error.message);
  
      return res.status(500).json({
        success: false,
        message: "Skin scan failed",
        error: error.response?.data || error.message
      });
    }
  }
  
  module.exports = {
    createSkinScan
  };
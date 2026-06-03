const express = require("express");
const multer = require("multer");

const authMiddleware = require("../middleware/authMiddleware");
const { createSkinScan, getLatestScan, getScanHistory } = require("../controllers/skinScanController");

const router = express.Router();

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 10 * 1024 * 1024 }, // 10 MB
});

function handleUpload(req, res, next) {
  upload.single("image")(req, res, (err) => {
    if (err instanceof multer.MulterError) {
      if (err.code === "LIMIT_FILE_SIZE") {
        return res.status(413).json({
          success: false,
          message: "Image too large. Maximum size is 10MB.",
        });
      }
      if (err.code === "LIMIT_UNEXPECTED_FILE") {
        return res.status(400).json({
          success: false,
          message: "Unexpected field. Use field name 'image' in your multipart form.",
        });
      }
      return res.status(400).json({ success: false, message: err.message });
    }
    if (err) return next(err);
    next();
  });
}

router.post("/analyze", authMiddleware, handleUpload, createSkinScan);
router.get("/latest", authMiddleware, getLatestScan);
router.get("/history", authMiddleware, getScanHistory);

module.exports = router;

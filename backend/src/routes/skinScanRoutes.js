const express = require("express");
const multer = require("multer");

const authMiddleware = require("../middleware/authMiddleware");
const { createSkinScan, getLatestScan, getScanHistory } = require("../controllers/skinScanController");

const router = express.Router();

const upload = multer({
  dest: "uploads/",
  limits: {
    fileSize: 5 * 1024 * 1024,
  },
});

router.post(
  "/analyze",
  authMiddleware,
  upload.single("image"),
  createSkinScan
);

router.get("/latest", authMiddleware, getLatestScan);
router.get("/history", authMiddleware, getScanHistory);

module.exports = router;
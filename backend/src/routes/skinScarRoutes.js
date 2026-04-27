const express = require("express");
const multer = require("multer");
const { createSkinScan } = require("../controllers/skinScanController");

const router = express.Router();

const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 10 * 1024 * 1024
  }
});

router.post("/", upload.single("image"), createSkinScan);

module.exports = router;
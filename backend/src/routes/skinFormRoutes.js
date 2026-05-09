const express = require("express");
const router = express.Router();

const authMiddleware = require("../middleware/authMiddleware");
const { createSkinFormAnswer } = require("../controllers/skinFormController.js");

router.post("/", authMiddleware, createSkinFormAnswer);
//router.post("/", createSkinFormAnswer); TEST

module.exports = router;
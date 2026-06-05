const express = require("express");
const router = express.Router();

const authMiddleware = require("../middleware/authMiddleware");

const {
	getSkinGoals,
	saveSkinGoals,
} = require("../controllers/skinGoalController");

router.get("/", authMiddleware, getSkinGoals);
router.put("/", authMiddleware, saveSkinGoals);

module.exports = router;
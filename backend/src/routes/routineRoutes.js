const express = require("express");
const router = express.Router();

const authMiddleware = require("../middleware/authMiddleware");
const routineController = require("../controllers/routineController");

router.get("/", authMiddleware, routineController.getMyRoutines);
router.post("/", authMiddleware, routineController.createRoutine);
router.put("/:id", authMiddleware, routineController.updateRoutine);
router.delete("/:id", authMiddleware, routineController.deleteRoutine);

module.exports = router;
const express = require("express");
const router = express.Router();

const authController = require("../controllers/authController");
const authMiddleware = require("../middleware/authMiddleware");
const roleMiddleware = require("../middleware/roleMiddleware");

router.post("/register-user", authController.registerUser);
router.post("/register-dermatologist", authController.registerDermatologist);
router.post("/login", authController.login);

router.get("/me", authMiddleware, authController.me);
router.post("/logout", authMiddleware, authController.logout);

router.get(
  "/dermatologist-only",
  authMiddleware,
  roleMiddleware("dermatologist"),
  (req, res) => {
    res.json({
      message: "Welcome dermatologist.",
      user: req.user,
    });
  }
);

module.exports = router;
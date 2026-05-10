const express = require("express");
const router = express.Router();

const dermatologistController = require("../controllers/dermatologistController");
const authMiddleware = require("../middleware/authMiddleware");
const roleMiddleware = require("../middleware/roleMiddleware");

router.get("/verified", dermatologistController.getVerifiedDermatologists);

router.get(
  "/me",
  authMiddleware,
  roleMiddleware("dermatologist"),
  dermatologistController.getMyDermatologistProfile
);

router.get(
    "/:id/silverpages-check",
    authMiddleware,
    roleMiddleware("admin"),
    dermatologistController.getSilverpagesSearchUrl
  );

router.patch(
  "/:id/verification",
  authMiddleware,
  roleMiddleware("admin"),
  dermatologistController.updateVerificationStatus
);

module.exports = router;
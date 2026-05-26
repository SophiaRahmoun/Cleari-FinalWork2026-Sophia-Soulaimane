const express = require("express");
const router = express.Router();
const chatController = require("../controllers/chatController");
const authMiddleware = require("../middleware/authMiddleware");

router.post(
	"/conversations",
	authMiddleware,
	chatController.createConversation
);

router.get("/conversations", authMiddleware, chatController.getMyConversations);

router.get(
	"/conversations/:conversationId/messages",
	authMiddleware,
	chatController.getConversationMessages
);

router.post(
	"/conversations/:conversationId/messages",
	authMiddleware,
	chatController.sendMessage
);

router.post(
	"/conversations/:conversationId/request-appointment",
	authMiddleware,
	chatController.requestAppointmentFromChat
);

module.exports = router;

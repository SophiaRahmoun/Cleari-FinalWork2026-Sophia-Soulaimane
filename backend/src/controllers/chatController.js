const Conversation = require("../models/Conversation");
const Message = require("../models/Message");
const uploadToCloudinary = require("../utils/uploadToCloudinary");

exports.createConversation = async (req, res) => {
	try {
		const { dermatologistId, scanId, formId, firstMessage } = req.body;
		const userId = req.user.id;

		if (!dermatologistId) {
			return res.status(400).json({ message: "Dermatologist id is required." });
		}
		let conversation = await Conversation.findOne({
			where: {
				userId,
				dermatologistId,
				status: "open",
			},
		});

		if (!conversation) {
			conversation = await Conversation.create({
				userId,
				dermatologistId,
				scanId: scanId || null,
				formId: formId || null,
				lastMessageAt: new Date(),
			});
		}

		if (firstMessage && firstMessage.trim() !== "") {
			await Message.create({
				conversationId: conversation.id,

				senderId: userId,

				senderRole: "user",

				content: firstMessage,
			});

			conversation.lastMessageAt = new Date();

			await conversation.save();
		}

		res.status(201).json({
			message: "Conversation created successfully.",

			conversation,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error creating conversation.",

			error: error.message,
		});
	}
};

exports.getMyConversations = async (req, res) => {
	try {
		const user = req.user;

		const whereCondition =
			user.role === "dermatologist"
				? { dermatologistId: user.id }
				: { userId: user.id };
		const conversations = await Conversation.findAll({
			where: whereCondition,

			order: [["lastMessageAt", "DESC"]],
		});

		const { User } = require("../models");
		const userIds = [...new Set(conversations.map((c) => c.userId))];
		const patients = await User.findAll({
			where: { id: userIds },
			attributes: [
				"id",
				"username",
				"first_name",
				"last_name",
				"profile_picture_url",
			],
		});
		const patientMap = {};
		for (const p of patients) patientMap[p.id] = p;

		const result = conversations.map((c) => {
			const json = c.toJSON();
			const p = patientMap[c.userId];
			json.patient = p
				? {
						id: p.id,
						username: p.username,
						first_name: p.first_name,
						last_name: p.last_name,
						profile_picture_url: p.profile_picture_url,
					}
				: null;
			return json;
		});

		res.status(200).json(result);
	} catch (error) {
		res.status(500).json({
			message: "Error fetching conversations.",

			error: error.message,
		});
	}
};

exports.getConversationMessages = async (req, res) => {
	try {
		const { conversationId } = req.params;
		const user = req.user;
		const conversation = await Conversation.findByPk(conversationId);

		if (!conversation) {
			return res.status(404).json({ message: "Conversation not found." });
		}

		const isAllowed =
			conversation.userId === user.id ||
			conversation.dermatologistId === user.id;

		if (!isAllowed) {
			return res.status(403).json({ message: "Access denied." });
		}

		const messages = await Message.findAll({
			where: { conversationId },

			order: [["createdAt", "ASC"]],
		});

		res.status(200).json({
			conversation,

			messages,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error fetching messages.",

			error: error.message,
		});
	}
};

exports.sendMessage = async (req, res) => {
	try {
		const { conversationId } = req.params;

		const { content, messageType } = req.body;

		const user = req.user;

		if (!content || content.trim() === "") {
			return res.status(400).json({ message: "Message content is required." });
		}

		const conversation = await Conversation.findByPk(conversationId);

		if (!conversation) {
			return res.status(404).json({ message: "Conversation not found." });
		}

		const isAllowed =
			conversation.userId === user.id ||
			conversation.dermatologistId === user.id;

		if (!isAllowed) {
			return res.status(403).json({ message: "Access denied." });
		}

		const newMessage = await Message.create({
			conversationId,

			senderId: user.id,

			senderRole: user.role,

			content,

			messageType: messageType || "text",
		});

		conversation.lastMessageAt = new Date();

		await conversation.save();

		res.status(201).json({
			message: "Message sent successfully.",

			newMessage,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error sending message.",

			error: error.message,
		});
	}
};

exports.sendImageMessage = async (req, res) => {
	try {
		const { conversationId } = req.params;
		const user = req.user;

		if (!req.file) {
			return res.status(400).json({ message: "No image file provided." });
		}

		const conversation = await Conversation.findByPk(conversationId);
		if (!conversation) {
			return res.status(404).json({ message: "Conversation not found." });
		}

		const isAllowed =
			conversation.userId === user.id ||
			conversation.dermatologistId === user.id;
		if (!isAllowed) {
			return res.status(403).json({ message: "Access denied." });
		}

		const result = await uploadToCloudinary(req.file.buffer, "chat-images");

		const newMessage = await Message.create({
			conversationId,
			senderId: user.id,
			senderRole: user.role,
			content: result.secure_url,
			messageType: "image",
		});

		conversation.lastMessageAt = new Date();
		await conversation.save();

		res.status(201).json({ message: "Image sent.", newMessage });
	} catch (error) {
		res
			.status(500)
			.json({ message: "Error sending image.", error: error.message });
	}
};

exports.requestAppointmentFromChat = async (req, res) => {
	try {
		const { conversationId } = req.params;

		const user = req.user;

		if (user.role !== "dermatologist") {
			return res.status(403).json({
				message: "Only dermatologists can suggest an appointment.",
			});
		}

		const conversation = await Conversation.findByPk(conversationId);

		if (!conversation) {
			return res.status(404).json({ message: "Conversation not found." });
		}

		if (conversation.dermatologistId !== user.id) {
			return res.status(403).json({ message: "Access denied." });
		}

		const appointmentMessage = await Message.create({
			conversationId,

			senderId: user.id,

			senderRole: "dermatologist",

			content:
				"I recommend booking an appointment so we can discuss this further.",

			messageType: "appointment_request",
		});

		conversation.lastMessageAt = new Date();

		await conversation.save();

		res.status(201).json({
			message: "Appointment suggestion sent.",

			appointmentMessage,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error sending appointment suggestion.",

			error: error.message,
		});
	}
};

exports.getPatientScans = async (req, res) => {
	try {
		const { conversationId } = req.params;
		const user = req.user;

		if (user.role !== "dermatologist") {
			return res
				.status(403)
				.json({ message: "Only dermatologists can access patient scans." });
		}

		const conversation = await Conversation.findByPk(conversationId);
		if (!conversation)
			return res.status(404).json({ message: "Conversation not found." });
		if (conversation.dermatologistId !== user.id) {
			return res.status(403).json({ message: "Access denied." });
		}

		const { SkinAnalysis } = require("../models");
		const scans = await SkinAnalysis.findAll({
			where: { user_id: conversation.userId },
			order: [["createdAt", "DESC"]],
		});

		res.status(200).json({ scans });
	} catch (error) {
		res
			.status(500)
			.json({ message: "Error fetching patient scans.", error: error.message });
	}
};

exports.getPatientForm = async (req, res) => {
	try {
		const { conversationId } = req.params;
		const user = req.user;

		if (user.role !== "dermatologist") {
			return res
				.status(403)
				.json({ message: "Only dermatologists can access patient forms." });
		}

		const conversation = await Conversation.findByPk(conversationId);
		if (!conversation)
			return res.status(404).json({ message: "Conversation not found." });
		if (conversation.dermatologistId !== user.id) {
			return res.status(403).json({ message: "Access denied." });
		}

		const { SkinFormAnswer } = require("../models");
		const form = await SkinFormAnswer.findOne({
			where: { user_id: conversation.userId },
			order: [["created_at", "DESC"]],
		});

		res.status(200).json({ form: form || null });
	} catch (error) {
		res
			.status(500)
			.json({ message: "Error fetching patient form.", error: error.message });
	}
};

exports.getPatientRoutines = async (req, res) => {
	try {
		const { conversationId } = req.params;
		const user = req.user;

		if (user.role !== "dermatologist") {
			return res
				.status(403)
				.json({ message: "Only dermatologists can access patient routines." });
		}

		const conversation = await Conversation.findByPk(conversationId);
		if (!conversation)
			return res.status(404).json({ message: "Conversation not found." });
		if (conversation.dermatologistId !== user.id) {
			return res.status(403).json({ message: "Access denied." });
		}

		const { Routine } = require("../models");
		const routines = await Routine.findAll({
			where: { user_id: conversation.userId },
			order: [["createdAt", "DESC"]],
		});

		res.status(200).json({ routines });
	} catch (error) {
		res
			.status(500)
			.json({
				message: "Error fetching patient routines.",
				error: error.message,
			});
	}
};

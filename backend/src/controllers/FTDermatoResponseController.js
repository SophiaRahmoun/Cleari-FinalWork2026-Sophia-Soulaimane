const FakeTrendPost = require("../models/FakeTrendPost");
const FakeTrendDermatologistResponse = require("../models/FakeTrendDermatologistResponse");
const User = require("../models/User");

exports.createDermatologistResponse = async (req, res) => {
	try {
		const fakeTrendPostId = req.params.postId;
		const dermatologistId = req.user.id;

		const { content } = req.body;

		if (!content || content.trim() === "") {
			return res.status(400).json({
				message: "Response content is required",
			});
		}

		const post = await FakeTrendPost.findByPk(fakeTrendPostId);

		if (!post) {
			return res.status(404).json({
				message: "Fake trend post not found",
			});
		}

		const response = await FakeTrendDermatologistResponse.create({
			content,
			dermatologistId,
			fakeTrendPostId,
		});

		res.status(201).json(response);
	} catch (error) {
		res.status(500).json({
			message: "Error creating dermatologist response",
			error: error.message,
		});
	}
};

exports.getDermatologistResponsesByPost = async (req, res) => {
	try {
		const fakeTrendPostId = req.params.postId;

		const responses = await FakeTrendDermatologistResponse.findAll({
			where: { fakeTrendPostId },
			include: [
				{
					model: User,
					as: "dermatologist",
					attributes: ["id", "username", "email", "role"],
				},
			],
			order: [["createdAt", "ASC"]],
		});

		res.json(responses);
	} catch (error) {
		res.status(500).json({
			message: "Error fetching dermatologist responses",
			error: error.message,
		});
	}
};

exports.updateDermatologistResponse = async (req, res) => {
	try {
		const response = await FakeTrendDermatologistResponse.findByPk(
			req.params.responseId
		);

		if (!response) {
			return res.status(404).json({
				message: "Response not found",
			});
		}

		if (response.dermatologistId !== req.user.id) {
			return res.status(403).json({
				message: "You can only edit your own response",
			});
		}

		response.content = req.body.content || response.content;

		await response.save();

		res.json(response);
	} catch (error) {
		res.status(500).json({
			message: "Error updating dermatologist response",
			error: error.message,
		});
	}
};

exports.deleteDermatologistResponse = async (req, res) => {
	try {
		const response = await FakeTrendDermatologistResponse.findByPk(
			req.params.responseId
		);

		if (!response) {
			return res.status(404).json({
				message: "Response not found",
			});
		}

		if (response.dermatologistId !== req.user.id) {
			return res.status(403).json({
				message: "You can only delete your own response",
			});
		}

		await response.destroy();

		res.json({
			message: "Dermatologist response deleted successfully",
		});
	} catch (error) {
		res.status(500).json({
			message: "Error deleting dermatologist response",
			error: error.message,
		});
	}
};

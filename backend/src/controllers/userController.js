const { User } = require("../models");

exports.getCurrentUser = async (req, res) => {
	try {
		const user = await User.findByPk(req.user.id, {
			attributes: [
				"id",
				"username",
				"email",
				"role",
				"profile_picture_url",
				"language",
				"createdAt",
			],
		});

		if (!user) {
			return res.status(404).json({
				message: "User not found.",
			});
		}

		res.json(user);
	} catch (error) {
		res.status(500).json({
			message: "Error fetching current user.",
			error: error.message,
		});
	}
};
const bcrypt = require("bcryptjs");
const { User } = require("../models");

exports.getCurrentUser = async (req, res) => {
	try {
		const user = await User.findByPk(req.user.id, {
			attributes: [
                "id",
                "first_name",
                "last_name",
                "username",
                "email",
                "role",
                "profile_picture_url",
                "language",
                "createdAt",
                "skin_type",
				"pronouns",
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

exports.updateUsername = async (req, res) => {
    try {
        const { username } = req.body;

        if (!username || username.trim() === "") {
            return res.status(400).json({
                message: "Username is required."
            });
        }

        const existingUser = await User.findOne({
            where: { username }
        });

        if (
            existingUser &&
            existingUser.id !== req.user.id
        ) {
            return res.status(400).json({
                message: "Username already exists."
            });
        }

        const user = await User.findByPk(req.user.id);

        if (!user) {
            return res.status(404).json({
                message: "User not found."
            });
        }

        user.username = username;

        await user.save();

        res.json({
            message: "Username updated successfully.",
            username: user.username
        });

    } catch (error) {
        res.status(500).json({
            message: "Error updating username.",
            error: error.message
        });
    }
};
exports.updatePassword = async (req, res) => {
	try {
		const { currentPassword, newPassword, confirmPassword } = req.body;

		if (!currentPassword || !newPassword || !confirmPassword) {
			return res.status(400).json({
				message: "All password fields are required.",
			});
		}

		if (newPassword.length < 8) {
			return res.status(400).json({
				message: "Password must be at least 8 characters.",
			});
		}

		if (newPassword !== confirmPassword) {
			return res.status(400).json({
				message: "Passwords do not match.",
			});
		}

		const user = await User.findByPk(req.user.id);

		if (!user) {
			return res.status(404).json({
				message: "User not found.",
			});
		}

		const isCurrentPasswordValid = await bcrypt.compare(
			currentPassword,
			user.password
		);

		if (!isCurrentPasswordValid) {
			return res.status(400).json({
				message: "Current password is incorrect.",
			});
		}

		user.password = await bcrypt.hash(newPassword, 10);
		await user.save();

		res.json({
			message: "Password updated successfully.",
		});
	} catch (error) {
		res.status(500).json({
			message: "Error updating password.",
			error: error.message,
		});
	}
};
const User = require("../models/User");

const dermatoloOnlyMiddleware = async (req, res, next) => {

	try {
		const user = await User.findByPk(req.user.id);
		if (!user) {
			return res.status(404).json({ message: "User not found" });
		}
		if (user.role !== "dermatologist") {
			return res.status(403).json({
				message: "Only dermatologists can perform this action",
			});
		}
		next();
	} catch (error) {
		res.status(500).json({
			message: "Error checking dermatologist permission",
			error: error.message,
		});
	}

};

module.exports = dermatoloOnlyMiddleware;
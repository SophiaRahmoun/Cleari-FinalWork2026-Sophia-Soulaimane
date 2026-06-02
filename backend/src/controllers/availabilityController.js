const {
	DermatologistAvailability,
	DermatologistProfile,
} = require("../models");

exports.createAvailability = async (req, res) => {
	try {
		const { available_date, start_time, end_time } = req.body;

		if (!available_date || !start_time || !end_time) {
			return res.status(400).json({
				message: "Date, start time and end time are required.",
			});
		}

		const dermatologistProfile = await DermatologistProfile.findOne({
			where: { user_id: req.user.id },
		});

		if (!dermatologistProfile) {
			return res.status(404).json({
				message: "Dermatologist profile not found.",
			});
		}

		const availability = await DermatologistAvailability.create({
			dermatologist_profile_id: dermatologistProfile.id,

			available_date,

			start_time,

			end_time,

			is_booked: false,
		});

		return res.status(201).json({
			message: "Availability created successfully.",

			availability,
		});
	} catch (error) {
		return res.status(500).json({
			message: "Error while creating availability.",

			error: error.message,
		});
	}
};

exports.getAvailabilityByDermatologist = async (req, res) => {
	try {
		const dermatologist_profile_id = req.params.id;

		const availabilities = await DermatologistAvailability.findAll({
			where: {
				dermatologist_profile_id,

				is_booked: false,
			},

			order: [
				["available_date", "ASC"],

				["start_time", "ASC"],
			],
		});

		return res.status(200).json({ availabilities });
	} catch (error) {
		return res.status(500).json({
			message: "Error while fetching availability.",

			error: error.message,
		});
	}
};

exports.deleteAvailability = async (req, res) => {
	try {
		const dermatologistProfile = await DermatologistProfile.findOne({
			where: { user_id: req.user.id },
		});

		if (!dermatologistProfile) {
			return res.status(404).json({
				message: "Dermatologist profile not found.",
			});
		}

		const availability = await DermatologistAvailability.findOne({
			where: {
				id: req.params.id,

				dermatologist_profile_id: dermatologistProfile.id,
			},
		});

		if (!availability) {
			return res.status(404).json({
				message: "Availability not found.",
			});
		}

		if (availability.is_booked) {
			return res.status(400).json({
				message: "You cannot delete an already booked availability.",
			});
		}

		await availability.destroy();

		return res.status(200).json({
			message: "Availability deleted successfully.",
		});
	} catch (error) {
		return res.status(500).json({
			message: "Error while deleting availability.",

			error: error.message,
		});
	}
};

const { Appointment, DermatologistProfile, User, DermatologistAvailability } = require("../models");
const { Op } = require("sequelize");

exports.createAppointment = async (req, res) => {
	try {
		const {
			dermatologist_profile_id,
			appointment_date,
			appointment_time,
			reason,
		} = req.body;

		if (!dermatologist_profile_id || !appointment_date || !appointment_time) {
			return res.status(400).json({
				message:
					"Dermatologist, appointment date and appointment time are required.",
			});
		}

		const dermatologist = await DermatologistProfile.findByPk(
			dermatologist_profile_id
		);

		if (!dermatologist) {
			return res.status(404).json({
				message: "Dermatologist not found.",
			});
		}

		if (
			!dermatologist.verified ||
			dermatologist.verification_status !== "approved"
		) {
			return res.status(403).json({
				message:
					"You can only book an appointment with a verified dermatologist.",
			});
		}

		const existingAppointment = await Appointment.findOne({
			where: {
				dermatologist_profile_id,
				appointment_date,
				appointment_time,
				status: {
					[Op.in]: ["pending", "confirmed"],
				},
			},
		});

		if (existingAppointment) {
			return res.status(409).json({
				message: "This appointment slot is already booked.",
			});
		}
		const availability = await DermatologistAvailability.findOne({
			where: {
				dermatologist_profile_id,
				available_date: appointment_date,
				start_time: appointment_time,
				is_booked: false,
			},
		});

		if (!availability) {
			return res.status(400).json({
				message: "This dermatologist is not available at this time.",
			});
		}

		const appointment = await Appointment.create({
			user_id: req.user.id,
			dermatologist_profile_id,
			appointment_date,
			appointment_time,
			reason: reason || null,
			status: "pending",
		});
		availability.is_booked = true;
		await availability.save();

		return res.status(201).json({
			message: "Appointment created successfully.",
			appointment,
		});
	} catch (error) {
		return res.status(500).json({
			message: "Error while creating appointment.",
			error: error.message,
		});
	}
};

exports.getMyAppointments = async (req, res) => {
	try {
		const appointments = await Appointment.findAll({
			where: { user_id: req.user.id },
			include: [
				{
					model: DermatologistProfile,
					as: "dermatologistProfile",
					include: [
						{
							model: User,
							as: "user",
							attributes: ["id", "username", "email", "profile_picture_url"],
						},
					],
				},
			],
			order: [
				["appointment_date", "ASC"],
				["appointment_time", "ASC"],
			],
		});

		return res.status(200).json({ appointments });
	} catch (error) {
		return res.status(500).json({
			message: "Error while fetching appointments.",
			error: error.message,
		});
	}
};

exports.getDermatologistAppointments = async (req, res) => {
	try {
		const dermatologistProfile = await DermatologistProfile.findOne({
			where: { user_id: req.user.id },
		});

		if (!dermatologistProfile) {
			return res.status(404).json({
				message: "Dermatologist profile not found.",
			});
		}

		const appointments = await Appointment.findAll({
			where: { dermatologist_profile_id: dermatologistProfile.id },
			include: [
				{
					model: User,
					as: "user",
					attributes: ["id", "username", "email", "profile_picture_url"],
				},
			],
			order: [
				["appointment_date", "ASC"],
				["appointment_time", "ASC"],
			],
		});

		return res.status(200).json({ appointments });
	} catch (error) {
		return res.status(500).json({
			message: "Error while fetching dermatologist appointments.",
			error: error.message,
		});
	}
};

exports.updateAppointmentStatus = async (req, res) => {
	try {
		const { status } = req.body;

		if (!["pending", "confirmed", "cancelled", "completed"].includes(status)) {
			return res.status(400).json({
				message: "Invalid appointment status.",
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

		const appointment = await Appointment.findOne({
			where: {
				id: req.params.id,
				dermatologist_profile_id: dermatologistProfile.id,
			},
		});

		if (!appointment) {
			return res.status(404).json({
				message: "Appointment not found.",
			});
		}

		appointment.status = status;
		await appointment.save();

		return res.status(200).json({
			message: "Appointment status updated successfully.",
			appointment,
		});
	} catch (error) {
		return res.status(500).json({
			message: "Error while updating appointment status.",
			error: error.message,
		});
	}
};

exports.cancelMyAppointment = async (req, res) => {
	try {
		const appointment = await Appointment.findOne({
			where: {
				id: req.params.id,
				user_id: req.user.id,
			},
		});

		if (!appointment) {
			return res.status(404).json({
				message: "Appointment not found.",
			});
		}

		appointment.status = "cancelled";
		await appointment.save();

		return res.status(200).json({
			message: "Appointment cancelled successfully.",
			appointment,
		});
	} catch (error) {
		return res.status(500).json({
			message: "Error while cancelling appointment.",
			error: error.message,
		});
	}
};

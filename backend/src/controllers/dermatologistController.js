const { User, DermatologistProfile } = require("../models");

exports.getVerifiedDermatologists = async (req, res) => {
	try {
		const dermatologists = await DermatologistProfile.findAll({
			where: {
				verified: true,
				verification_status: "approved",
			},
			include: [
				{
					model: User,
					as: "user",
					attributes: ["id", "username", "email", "profile_picture_url"],
				},
			],
		});

		return res.status(200).json({ dermatologists });
	} catch (error) {
		return res.status(500).json({
			message: "Error while fetching verified dermatologists.",
			error: error.message,
		});
	}
};

exports.getMyDermatologistProfile = async (req, res) => {
	try {
		const profile = await DermatologistProfile.findOne({
			where: { user_id: req.user.id },
		});

		if (!profile) {
			return res.status(404).json({
				message: "Dermatologist profile not found.",
			});
		}

		return res.status(200).json({ profile });
	} catch (error) {
		return res.status(500).json({
			message: "Error while fetching dermatologist profile.",
			error: error.message,
		});
	}
};

exports.updateVerificationStatus = async (req, res) => {
	try {
		const { verification_status, verification_notes } = req.body;

		if (!["approved", "rejected", "pending"].includes(verification_status)) {
			return res.status(400).json({
				message: "Invalid verification status.",
			});
		}

		const profile = await DermatologistProfile.findByPk(req.params.id);

		if (!profile) {
			return res.status(404).json({
				message: "Dermatologist profile not found.",
			});
		}

		profile.verification_status = verification_status;
		profile.verified = verification_status === "approved";
		profile.verification_notes = verification_notes || null;
		profile.verified_at =
			verification_status === "approved" ? new Date() : null;
		profile.verified_by =
			verification_status === "approved" ? req.user.id : null;

		await profile.save();

		return res.status(200).json({
			message: "Dermatologist verification status updated.",
			profile,
		});
	} catch (error) {
		return res.status(500).json({
			message: "Error while updating verification status.",
			error: error.message,
		});
	}
};

exports.getSilverpagesSearchUrl = async (req, res) => {
	try {
		const profile = await DermatologistProfile.findByPk(req.params.id);

		if (!profile) {
			return res.status(404).json({
				message: "Dermatologist profile not found.",
			});
		}

		return res.status(200).json({
			message:
				"Use this information to verify the dermatologist manually on Silverpages.",
			verificationData: {
				first_name: profile.first_name,
				last_name: profile.last_name,
				inami_number: profile.inami_number,
				postal_code: profile.postal_code,
				city: profile.city,
				expectedQualification: "Dermatology / Dermatologie / Dermatoloog",
			},
			silverpagesUrl: "https://webappsa.riziv-inami.fgov.be/silverpages/",
		});
	} catch (error) {
		return res.status(500).json({
			message: "Error while preparing Silverpages verification.",
			error: error.message,
		});
	}
};

exports.getPendingDermatologists = async (req, res) => {
	try {
		const dermatologists = await DermatologistProfile.findAll({
			where: {
				verification_status: "pending",
			},
			include: [
				{
					model: User,
					as: "user",
					attributes: ["id", "username", "email"],
				},
			],
		});

		return res.status(200).json({ dermatologists });
	} catch (error) {
		return res.status(500).json({
			message: "Error while fetching pending dermatologists.",
			error: error.message,
		});
	}
};

exports.continueAsUser = async (req, res) => {
	try {
		const user = await User.findByPk(req.user.id);
		if (!user) {
			return res.status(404).json({
				message: "User not found.",
			});
		}

		user.role = "user";
		await user.save();
		return res.status(200).json({
			message: "Account converted to regular user successfully.",
			user: {
				id: user.id,
				username: user.username,
				email: user.email,
				role: user.role,
				profile_picture_url: user.profile_picture_url,
				language: user.language,
			},
		});
	} catch (error) {
		return res.status(500).json({
			message: "Error while converting account to user.",
			error: error.message,
		});
	}
};

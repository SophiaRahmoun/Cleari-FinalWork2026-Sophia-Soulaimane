const { SkinFormAnswer, User } = require("../models");

const calculateSkinType = (skinFeeling, productReaction) => {
	const feeling = skinFeeling?.toLowerCase() || "";
	const reaction = productReaction?.toLowerCase() || "";

	let baseSkinType = "Unknown";

	if (feeling.includes("dry") || feeling.includes("tight")) {
		baseSkinType = "Dry";
	} else if (feeling.includes("comfortable")) {
		baseSkinType = "Normal";
	} else if (feeling.includes("t-zone") || feeling.includes("zone")) {
		baseSkinType = "Combination";
	} else if (feeling.includes("shiny") || feeling.includes("oily")) {
		baseSkinType = "Oily";
	}

	const isSensitive =
		reaction.includes("often") ||
		reaction.includes("sometimes") ||
		reaction.includes("react");

	return isSensitive ? `${baseSkinType}, Sensitive` : baseSkinType;
};

const createSkinFormAnswer = async (req, res) => {
	try {
		const userId = req.user.id;

		const {
			skin_feeling,
			product_reaction,
			flakiness,
			diagnosed_condition,
			has_allergies,
			allergies_details,
			has_skin_issues,
			main_concern,
			wants_photo_upload,
			consent_shared,
			pronouns,
			step_completed,
		} = req.body;

		if (!step_completed) {
			return res.status(400).json({
				message: "step_completed is required",
			});
		}

		const skinType = calculateSkinType(
			skin_feeling,
			product_reaction
		);

		const formFields = {
			skin_feeling,
			product_reaction,
			flakiness,
			diagnosed_condition,
			has_allergies,
			allergies_details,
			has_skin_issues,
			main_concern,
			wants_photo_upload,
			consent_shared,
			step_completed,
		};

		// Upsert: update existing record if one already exists for this user
		const existing = await SkinFormAnswer.findOne({ where: { user_id: userId } });
		let answer;
		if (existing) {
			await existing.update(formFields);
			answer = existing;
		} else {
			answer = await SkinFormAnswer.create({ user_id: userId, ...formFields });
		}

		await User.update(
			{
				skin_type: skinType,
				pronouns,
			},
			{
				where: { id: userId },
			}
		);

		res.status(201).json({
			message: "Skin form saved successfully",
			skinType,
			data: answer,
		});
	} catch (error) {
		console.error(error);
		res.status(500).json({
			message: "Error saving skin form",
		});
	}
};

module.exports = {
	createSkinFormAnswer,
};
const { SkinGoal } = require("../models");

exports.getSkinGoals = async (req, res) => {
	try {
		const skinGoal = await SkinGoal.findOne({
			where: {
				user_id: req.user.id,
			},
		});

		if (!skinGoal) {
			return res.json({
				description: "",
				selectedGoals: [],
			});
		}

		res.json({
			description: skinGoal.description || "",
			selectedGoals: skinGoal.selected_goals
				? JSON.parse(skinGoal.selected_goals)
				: [],
		});
	} catch (error) {
		res.status(500).json({
			message: "Error fetching skin goals.",
			error: error.message,
		});
	}
};

exports.saveSkinGoals = async (req, res) => {
	try {
		const { description, selectedGoals } = req.body;

		const goalsAsJson = JSON.stringify(selectedGoals || []);

		const existingSkinGoal = await SkinGoal.findOne({
			where: {
				user_id: req.user.id,
			},
		});

		if (existingSkinGoal) {
			existingSkinGoal.description = description || "";
			existingSkinGoal.selected_goals = goalsAsJson;

			await existingSkinGoal.save();

			return res.json({
				message: "Skin goals updated successfully.",
				description: existingSkinGoal.description,
				selectedGoals: selectedGoals || [],
			});
		}

		const newSkinGoal = await SkinGoal.create({
			user_id: req.user.id,
			goal_type: "general",
			description: description || "",
			selected_goals: goalsAsJson,
		});

		res.status(201).json({
			message: "Skin goals saved successfully.",
			description: newSkinGoal.description,
			selectedGoals: selectedGoals || [],
		});
	} catch (error) {
		res.status(500).json({
			message: "Error saving skin goals.",
			error: error.message,
		});
	}
};
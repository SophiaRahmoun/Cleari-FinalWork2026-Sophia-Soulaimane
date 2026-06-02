const cloudinary = require("../config/cloudinary");
const { Routine } = require("../models");

exports.getMyRoutines = async (req, res) => {
	try {
		const routines = await Routine.findAll({
			where: {
				user_id: req.user.id,
			},
			order: [["createdAt", "DESC"]],
		});

		res.json(routines);
	} catch (error) {
		res.status(500).json({
			message: "Error fetching routines.",
			error: error.message,
		});
	}
};

exports.createRoutine = async (req, res) => {
	try {
		const {
			product_name,
			imageBase64,
			usage_time,
			notes,
		} = req.body;

		if (!product_name || product_name.trim() === "") {
			return res.status(400).json({
				message: "Product name is required.",
			});
		}

		let product_image_url = null;
		let product_image_public_id = null;

		if (imageBase64) {
			const uploadResult = await cloudinary.uploader.upload(imageBase64, {
				folder: "cleari/routines",
			});

			product_image_url = uploadResult.secure_url;
			product_image_public_id = uploadResult.public_id;
		}

		const routine = await Routine.create({
			user_id: req.user.id,
			product_name,
			product_image_url,
			product_image_public_id,
			usage_time,
			notes,
		});

		res.status(201).json({
			message: "Routine product created successfully.",
			routine,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error creating routine product.",
			error: error.message,
		});
	}
};

exports.updateRoutine = async (req, res) => {
	try {
		const { id } = req.params;
		const {
			product_name,
			imageBase64,
			usage_time,
			notes,
		} = req.body;

		const routine = await Routine.findOne({
			where: {
				id,
				user_id: req.user.id,
			},
		});

		if (!routine) {
			return res.status(404).json({
				message: "Routine product not found.",
			});
		}

		if (product_name !== undefined) {
			routine.product_name = product_name;
		}

		if (usage_time !== undefined) {
			routine.usage_time = usage_time;
		}

		if (notes !== undefined) {
			routine.notes = notes;
		}

		if (imageBase64) {
			if (routine.product_image_public_id) {
				await cloudinary.uploader.destroy(routine.product_image_public_id);
			}

			const uploadResult = await cloudinary.uploader.upload(imageBase64, {
				folder: "cleari/routines",
			});

			routine.product_image_url = uploadResult.secure_url;
			routine.product_image_public_id = uploadResult.public_id;
		}

		await routine.save();

		res.json({
			message: "Routine product updated successfully.",
			routine,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error updating routine product.",
			error: error.message,
		});
	}
};

exports.deleteRoutine = async (req, res) => {
	try {
		const { id } = req.params;

		const routine = await Routine.findOne({
			where: {
				id,
				user_id: req.user.id,
			},
		});

		if (!routine) {
			return res.status(404).json({
				message: "Routine product not found.",
			});
		}

		if (routine.product_image_public_id) {
			await cloudinary.uploader.destroy(routine.product_image_public_id);
		}

		await routine.destroy();

		res.json({
			message: "Routine product deleted successfully.",
		});
	} catch (error) {
		res.status(500).json({
			message: "Error deleting routine product.",
			error: error.message,
		});
	}
};
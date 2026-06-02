const FakeTrendPost = require("../models/FakeTrendPost");
const FakeTrendScientificSource = require("../models/FakeTrendScientificSource");

exports.addScientificSource = async (req, res) => {
	try {
		const postId = req.params.postId;
		const { title, url, sourceType, summary } = req.body;
		if (!title || !url) {
			return res.status(400).json({
				message: "title and url are required",
			});
		}
		const post = await FakeTrendPost.findByPk(postId);
		if (!post) {
			return res.status(404).json({ message: "Fake trend post not found" });
		}
		if (post.dermatologistId !== req.user.id) {
			return res.status(403).json({
				message: "You can only add sources to your own fake trend post",
			});
		}
		const source = await FakeTrendScientificSource.create({
			title,
			url,
			sourceType: sourceType || "study",
			summary,
			postId,
		});
		res.status(201).json(source);
	} catch (error) {
		res.status(500).json({
			message: "Error adding scientific source",
			error: error.message,
		});
	}
};

exports.getSourcesByPost = async (req, res) => {
	try {
		const sources = await FakeTrendScientificSource.findAll({
			where: { postId: req.params.postId },
			order: [["createdAt", "DESC"]],
		});
		res.json(sources);
	} catch (error) {
		res.status(500).json({
			message: "Error fetching scientific sources",
			error: error.message,
		});
	}
};

exports.updateScientificSource = async (req, res) => {
	try {
		const source = await FakeTrendScientificSource.findByPk(
			req.params.sourceId
		);
		if (!source) {
			return res.status(404).json({ message: "Scientific source not found" });
		}
		const post = await FakeTrendPost.findByPk(source.postId);
		if (post.dermatologistId !== req.user.id) {
			return res.status(403).json({
				message: "You can only edit sources from your own fake trend post",
			});
		}
		const { title, url, sourceType, summary } = req.body;
		source.title = title || source.title;
		source.url = url || source.url;
		source.sourceType = sourceType || source.sourceType;
		source.summary = summary || source.summary;
		await source.save();
		res.json(source);
	} catch (error) {
		res.status(500).json({
			message: "Error updating scientific source",
			error: error.message,
		});
	}
};

exports.deleteScientificSource = async (req, res) => {
	try {
		const source = await FakeTrendScientificSource.findByPk(
			req.params.sourceId
		);
		if (!source) {
			return res.status(404).json({ message: "Scientific source not found" });
		}
		const post = await FakeTrendPost.findByPk(source.postId);
		if (post.dermatologistId !== req.user.id) {
			return res.status(403).json({
				message: "You can only delete sources from your own fake trend post",
			});
		}
		await source.destroy();
		res.json({ message: "Scientific source deleted successfully" });
	} catch (error) {
		res.status(500).json({
			message: "Error deleting scientific source",
			error: error.message,
		});
	}
};

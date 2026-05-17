const CommunityPost = require("../models/CommunityPost");
const CommunityPostSave = require("../models/CommunityPostSave");

exports.savePost = async (req, res) => {
    try {
        const postId = req.params.postId;
        const userId = req.user.id;
        const post = await CommunityPost.findByPk(postId);
        if (!post) {
            return res.status(404).json({ message: "Post not found" });
        }
        const existingSave = await CommunityPostSave.findOne({
            where: { postId, userId },
        });
        if (existingSave) {
            return res.status(400).json({ message: "Post already saved" });
        }
        await CommunityPostSave.create({ postId, userId });
        res.status(201).json({
			message: "Post saved successfully",
			isSavedByCurrentUser: true,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error saving post",
			error: error.message,
		});
	}
};

exports.unsavePost = async (req, res) => {
    try {
        const postId = req.params.postId;
        const userId = req.user.id;
        const savedPost = await CommunityPostSave.findOne({
            where: { postId, userId },
        });
        if (!save) {
            return res.status(404).json({ message: "Save not found" });
        }
        await savedPost.destroy();
        res.json({

			message: "Post unsaved successfully",
			isSavedByCurrentUser: false,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error unsaving post",
			error: error.message,
		});
	}

};
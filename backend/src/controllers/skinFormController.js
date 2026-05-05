const { SkinFormAnswer } = require("../models");

const createSkinFormAnswer = async (req, res) => {
  try {
    const userId = req.user.id;
    //const userId = 1; TEST


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
      step_completed,
    } = req.body;

    // Validate required step_completed field => 1,2,3
    if (!step_completed) {
      return res.status(400).json({
        message: "step_completed is required",
      });
    }

    const newAnswer = await SkinFormAnswer.create({
      user_id: userId,
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
    });

    res.status(201).json({
      message: "Skin form saved successfully",
      data: newAnswer,
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
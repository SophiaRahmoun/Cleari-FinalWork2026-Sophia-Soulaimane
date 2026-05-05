const sequelize = require("../config/database");

const User = require("./User");
const DermatologistProfile = require("./DermatologistProfile");
const SkinAnalysis = require("./SkinAnalysis");
const SkinFormAnswer = require("./SkinFormAnswer");

User.hasOne(DermatologistProfile, {
  foreignKey: "user_id",
  as: "dermatologistProfile",
  onDelete: "CASCADE",
});

DermatologistProfile.belongsTo(User, {
  foreignKey: "user_id",
  as: "user",
});

User.hasMany(SkinAnalysis, {
  foreignKey: "user_id",
  as: "skinAnalyses",
  onDelete: "CASCADE",
});

SkinAnalysis.belongsTo(User, {
  foreignKey: "user_id",
  as: "user",
});

User.hasMany(SkinFormAnswer, {
  foreignKey: "user_id",
  as: "skinFormAnswers",
  onDelete: "CASCADE",
});

SkinFormAnswer.belongsTo(User, {
  foreignKey: "user_id",
  as: "user",
});

module.exports = {
  sequelize,
  User,
  DermatologistProfile,
  SkinAnalysis,
  SkinFormAnswer,
};
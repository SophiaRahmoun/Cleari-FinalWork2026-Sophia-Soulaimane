const sequelize = require("../config/database");

const User = require("./User");
const DermatologistProfile = require("./DermatologistProfile");

User.hasOne(DermatologistProfile, {
  foreignKey: "user_id",
  as: "dermatologistProfile",
  onDelete: "CASCADE",
});

DermatologistProfile.belongsTo(User, {
  foreignKey: "user_id",
  as: "user",
});

module.exports = {
  sequelize,
  User,
  DermatologistProfile,
};
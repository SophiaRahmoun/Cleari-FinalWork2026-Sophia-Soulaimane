const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const DermatologistProfile = sequelize.define("DermatologistProfile", {
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  user_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },

  bio: {
    type: DataTypes.TEXT,
    allowNull: true,
  },

  specialization: {
    type: DataTypes.STRING,
    allowNull: true,
  },

  license_number: {
    type: DataTypes.STRING,
    allowNull: true,
  },

  certificate_url: {
    type: DataTypes.STRING,
    allowNull: true,
  },

  verification_status: {
    type: DataTypes.ENUM("pending", "approved", "rejected"),
    allowNull: false,
    defaultValue: "pending",
  },

  verified: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: false,
  },
}, {
  tableName: "dermatologist_profiles",
  timestamps: true,
});

module.exports = DermatologistProfile;
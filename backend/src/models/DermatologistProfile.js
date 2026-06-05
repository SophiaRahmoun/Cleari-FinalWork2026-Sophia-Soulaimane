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

  first_name: {
    type: DataTypes.STRING,
    allowNull: true,
  },

  postal_code: {
    type: DataTypes.STRING,
    allowNull: true,
  },

  city: {
    type: DataTypes.STRING,
    allowNull: true,
  },

  bio: {
    type: DataTypes.TEXT,
    allowNull: true,
  },

  specialization: {
    type: DataTypes.STRING,
    allowNull: true,
  },

  inami_number: {
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
  verification_notes: {
    type: DataTypes.TEXT,
    allowNull: true,
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
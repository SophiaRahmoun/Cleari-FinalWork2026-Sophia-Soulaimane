const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const User = sequelize.define("User", {
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },

  username: {
    type: DataTypes.STRING,
    allowNull: false,
  },

  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    validate: {
      isEmail: true,
    },
  },

  password: {
    type: DataTypes.STRING,
    allowNull: false,
  },

  role: {
    type: DataTypes.ENUM("user", "dermatologist", "admin"),
    allowNull: false,
    defaultValue: "user",
  },

  profile_picture_url: {
    type: DataTypes.STRING,
    allowNull: true,
  },

  language: {
    type: DataTypes.STRING,
    allowNull: true,
    defaultValue: "en",
  },
}, {
  tableName: "users",
  timestamps: true,
});

module.exports = User;
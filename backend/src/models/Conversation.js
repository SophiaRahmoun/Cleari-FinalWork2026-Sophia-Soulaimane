const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const Conversation = sequelize.define("Conversation", {
	id: {
		type: DataTypes.INTEGER,
		autoIncrement: true,
		primaryKey: true,
	},

	userId: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},

	dermatologistId: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},

	scanId: {
		type: DataTypes.INTEGER,
		allowNull: true,
	},

	formId: {
		type: DataTypes.INTEGER,
		allowNull: true,
	},

	status: {
		type: DataTypes.ENUM("open", "closed"),
		defaultValue: "open",
	},

	lastMessageAt: {
		type: DataTypes.DATE,
		allowNull: true,
	},
});

module.exports = Conversation;

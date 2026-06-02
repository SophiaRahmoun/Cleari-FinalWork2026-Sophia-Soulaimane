const { DataTypes } = require("sequelize");

const sequelize = require("../config/database");

const Message = sequelize.define("Message", {
	id: {
		type: DataTypes.INTEGER,

		autoIncrement: true,

		primaryKey: true,
	},

	conversationId: {
		type: DataTypes.INTEGER,

		allowNull: false,
	},

	senderId: {
		type: DataTypes.INTEGER,

		allowNull: false,
	},

	senderRole: {
		type: DataTypes.ENUM("user", "dermatologist"),

		allowNull: false,
	},

	content: {
		type: DataTypes.TEXT,

		allowNull: false,
	},

	messageType: {
		type: DataTypes.ENUM("text", "appointment_request"),

		defaultValue: "text",
	},

	isRead: {
		type: DataTypes.BOOLEAN,

		defaultValue: false,
	},
});

module.exports = Message;

const { DataTypes } = require("sequelize");

const sequelize = require("../config/database");

const User = require("./User");

const CommunityPost = require("./CommunityPost");

const CommunityPostReport = sequelize.define("CommunityPostReport", {
	reason: {
		type: DataTypes.STRING,
		allowNull: false,
	},
	description: {
		type: DataTypes.TEXT,
		allowNull: true,
	},
	status: {
		type: DataTypes.ENUM("pending", "reviewed", "dismissed"),
		defaultValue: "pending",
	},
	dermatologistId: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
	postId: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
});

CommunityPostReport.belongsTo(User, {
	foreignKey: "dermatologistId",
	as: "dermatologist",
});

CommunityPostReport.belongsTo(CommunityPost, {
	foreignKey: "postId",
});

CommunityPost.hasMany(CommunityPostReport, {
	foreignKey: "postId",
});

module.exports = CommunityPostReport;

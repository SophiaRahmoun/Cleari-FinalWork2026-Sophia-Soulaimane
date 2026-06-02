const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const User = require("./User");
const FakeTrendPost = require("./FakeTrendPost");

const FTProReply = sequelize.define("FTProReply", {
	content: {
		type: DataTypes.TEXT,
		allowNull: false,
	},
	stance: {
		type: DataTypes.ENUM("agree", "disagree", "neutral"),
		defaultValue: "neutral",
	},
	sourceUrls: {
		type: DataTypes.TEXT,
		allowNull: true,
	},
	dermatologistId: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
	fakeTrendPostId: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
	parentReplyId: {
		type: DataTypes.INTEGER,
		allowNull: true,
	},
});

FTProReply.belongsTo(User, {
	foreignKey: "dermatologistId",
	as: "dermatologist",
});

User.hasMany(FTProReply, {
	foreignKey: "dermatologistId",
});

FTProReply.belongsTo(FakeTrendPost, {
	foreignKey: "fakeTrendPostId",
});

FakeTrendPost.hasMany(FTProReply, {
	foreignKey: "fakeTrendPostId",
});

FTProReply.belongsTo(FTProReply, {
	foreignKey: "parentReplyId",
	as: "parentReply",
});

FTProReply.hasMany(FTProReply, {
	foreignKey: "parentReplyId",
	as: "childReplies",
});

module.exports = FTProReply;

const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const User = require("./User");

const FakeTrendPost = sequelize.define("FakeTrendPost", {
	title: {
		type: DataTypes.STRING,
		allowNull: false,
	},
	trendName: {
		type: DataTypes.STRING,
		allowNull: false,
	},
	description: {
		type: DataTypes.TEXT,
		allowNull: false,
	},
	debunkExplanation: {
		type: DataTypes.TEXT,
		allowNull: false,
	},
	tiktokUrl: {
		type: DataTypes.STRING,
		allowNull: true,
	},
	tiktokVideoId: {
		type: DataTypes.STRING,
		allowNull: true,
	},
	videoUrl: {
		type: DataTypes.STRING,
		allowNull: true,
	},
	imageUrl: {
		type: DataTypes.STRING,
		allowNull: true,
	},
	skinConcernTag: {
		type: DataTypes.STRING,
		allowNull: true,
	},
	status: {
		type: DataTypes.ENUM("draft", "published"),
		defaultValue: "published",
	},
	dermatologistId: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
});

FakeTrendPost.belongsTo(User, {
	foreignKey: "dermatologistId",
	as: "dermatologist",
});

User.hasMany(FakeTrendPost, {
	foreignKey: "dermatologistId",
	as: "fakeTrendPosts",
});

module.exports = FakeTrendPost;

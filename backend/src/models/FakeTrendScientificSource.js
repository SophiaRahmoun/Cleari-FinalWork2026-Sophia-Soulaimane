const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const FakeTrendPost = require("./FakeTrendPost");

const FakeTrendScientificSource = sequelize.define(
	"FakeTrendScientificSource",
	{
		title: {
			type: DataTypes.STRING,
			allowNull: false,
		},
		url: {
			type: DataTypes.STRING,
			allowNull: false,
		},
		sourceType: {
			type: DataTypes.ENUM("study", "article", "official_guideline", "other"),
			defaultValue: "study",
		},
		summary: {
			type: DataTypes.TEXT,
			allowNull: true,
		},
		postId: {
			type: DataTypes.INTEGER,
			allowNull: false,
		},
	}
);

FakeTrendScientificSource.belongsTo(FakeTrendPost, { foreignKey: "postId" });
FakeTrendPost.hasMany(FakeTrendScientificSource, { foreignKey: "postId" });
module.exports = FakeTrendScientificSource;

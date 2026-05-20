const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const FakeTrendPost = require("./FakeTrendPost");

const FakeTrendSource = sequelize.define("FakeTrendSource", {
	title: {
		type: DataTypes.STRING,
		allowNull: false,
	},
	url: {
		type: DataTypes.STRING,
		allowNull: false,
	},
	sourceType: {
		type: DataTypes.ENUM("study", "article", "medical_website", "other"),
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
});

FakeTrendSource.belongsTo(FakeTrendPost, { foreignKey: "postId" });
FakeTrendPost.hasMany(FakeTrendSource, { foreignKey: "postId" });

module.exports = FakeTrendSource;

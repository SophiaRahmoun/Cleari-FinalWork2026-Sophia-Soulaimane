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
    desctipyion: {
        type: DataTypes.TEXT,
        allowNull: false,
    },
    debunkExplanation: {

		type: DataTypes.TEXT,
		allowNull: false,
	},
	videoUrl: {
		type: DataTypes.STRING,
		allowNull: true,
	},
	imageUrl: {
		type: DataTypes.STRING,
		allowNull: true,
	},
	sourceUrls: {
		type: DataTypes.TEXT,
		allowNull: true,
		// store as hson string: ["https://study1.com", "https://study2.com"]
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
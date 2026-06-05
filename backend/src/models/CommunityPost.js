const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const User = require("./User");

const CommunityPost = sequelize.define("CommunityPost", {
	content: {
		type: DataTypes.TEXT,
		allowNull: false,
	},
	imageUrl: {
		type: DataTypes.STRING,
		allowNull: true,
	},
	userId: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
});

CommunityPost.belongsTo(User, { foreignKey: "userId" });
User.hasMany(CommunityPost, { foreignKey: "userId" });

module.exports = CommunityPost;

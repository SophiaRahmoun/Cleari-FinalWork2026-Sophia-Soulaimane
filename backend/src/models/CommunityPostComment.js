const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const User = require("./User");
const CommunityPost = require("./CommunityPost");
const CommunityPostComment = sequelize.define("CommunityPostComment", {

	content: {
		type: DataTypes.TEXT,
		allowNull: false,
	},
	userId: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
	postId: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
});

CommunityPostComment.belongsTo(User, { foreignKey: "userId" });
User.hasMany(CommunityPostComment, { foreignKey: "userId" });
CommunityPostComment.belongsTo(CommunityPost, { foreignKey: "postId" });
CommunityPost.hasMany(CommunityPostComment, { foreignKey: "postId" });
module.exports = CommunityPostComment;
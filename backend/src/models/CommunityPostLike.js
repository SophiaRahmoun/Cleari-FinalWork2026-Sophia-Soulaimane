const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const User = require("./User");
const CommunityPost = require("./CommunityPost");

const CommunityPostLike = sequelize.define(
	"CommunityPostLike",
	{
		userId: {
			type: DataTypes.INTEGER,
			allowNull: false,
		},
		postId: {
			type: DataTypes.INTEGER,
			allowNull: false,
		},
	},
	{
		indexes: [
			{
				unique: true,
				fields: ["userId", "postId"],
			},
		],
	}
);

CommunityPostLike.belongsTo(User, { foreignKey: "userId" });
User.hasMany(CommunityPostLike, { foreignKey: "userId" });

CommunityPostLike.belongsTo(CommunityPost, { foreignKey: "postId" });
CommunityPost.hasMany(CommunityPostLike, { foreignKey: "postId" });

module.exports = CommunityPostLike;

const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const User = require("./User");
const FakeTrendPost = require("./FakeTrendPost");
const FakeTrendComment = sequelize.define("FakeTrendComment", {
	content: {
		type: DataTypes.TEXT,
		allowNull: false,
	},
	userId: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
	fakeTrendPostId: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
});

FakeTrendComment.belongsTo(User, { foreignKey: "userId" });
User.hasMany(FakeTrendComment, { foreignKey: "userId" });
FakeTrendComment.belongsTo(FakeTrendPost, { foreignKey: "fakeTrendPostId" });
FakeTrendPost.hasMany(FakeTrendComment, { foreignKey: "fakeTrendPostId" });
FakeTrendComment.belongsTo(FakeTrendComment, {
	foreignKey: "parentCommentId",
	as: "parentComment",
});

FakeTrendComment.hasMany(FakeTrendComment, {
	foreignKey: "parentCommentId",
	as: "childComments",
});
module.exports = FakeTrendComment;

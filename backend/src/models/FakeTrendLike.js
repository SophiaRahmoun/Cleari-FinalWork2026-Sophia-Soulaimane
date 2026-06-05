const { DataTypes } = require("sequelize");

const sequelize = require("../config/database");

const User = require("./User");

const FakeTrendPost = require("./FakeTrendPost");

const FakeTrendLike = sequelize.define(
	"FakeTrendLike",
	{
		userId: {
			type: DataTypes.INTEGER,
			allowNull: false,
		},
		fakeTrendPostId: {
			type: DataTypes.INTEGER,
			allowNull: false,
		},
	},
	{
		indexes: [
			{
				unique: true,
				fields: ["userId", "fakeTrendPostId"],
			},
		],
	}
);

FakeTrendLike.belongsTo(User, { foreignKey: "userId" });
User.hasMany(FakeTrendLike, { foreignKey: "userId" });
FakeTrendLike.belongsTo(FakeTrendPost, { foreignKey: "fakeTrendPostId" });
FakeTrendPost.hasMany(FakeTrendLike, { foreignKey: "fakeTrendPostId" });
module.exports = FakeTrendLike;

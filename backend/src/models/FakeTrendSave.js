const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const User = require("./User");
const FakeTrendPost = require("./FakeTrendPost");
const FakeTrendSave = sequelize.define(
	"FakeTrendSave",
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

FakeTrendSave.belongsTo(User, { foreignKey: "userId" });
User.hasMany(FakeTrendSave, { foreignKey: "userId" });
FakeTrendSave.belongsTo(FakeTrendPost, { foreignKey: "fakeTrendPostId" });
FakeTrendPost.hasMany(FakeTrendSave, { foreignKey: "fakeTrendPostId" });
module.exports = FakeTrendSave;

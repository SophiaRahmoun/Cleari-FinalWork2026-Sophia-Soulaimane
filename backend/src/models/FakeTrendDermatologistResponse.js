const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const User = require("./User");
const FakeTrendPost = require("./FakeTrendPost");
const FakeTrendDermatologistResponse = sequelize.define(
	"FakeTrendDermatologistResponse",
	{
		content: {
			type: DataTypes.TEXT,
			allowNull: false,
		},
		dermatologistId: {
			type: DataTypes.INTEGER,
			allowNull: false,
		},
		fakeTrendPostId: {
			type: DataTypes.INTEGER,
			allowNull: false,
		},
	}
);

FakeTrendDermatologistResponse.belongsTo(User, {
	foreignKey: "dermatologistId",
	as: "dermatologist",
});

FakeTrendDermatologistResponse.belongsTo(FakeTrendPost, {
	foreignKey: "fakeTrendPostId",
});

FakeTrendPost.hasMany(FakeTrendDermatologistResponse, {
	foreignKey: "fakeTrendPostId",
});

module.exports = FakeTrendDermatologistResponse;

const { DataTypes } = require("sequelize");

const sequelize = require("../config/database");

const User = require("./User");

const FakeTrendPost = require("./FakeTrendPost");

const FakeTrendPostReport = sequelize.define("FakeTrendPostReport", {
	reason: {
		type: DataTypes.STRING,
		allowNull: false,
	},
	description: {
		type: DataTypes.TEXT,
		allowNull: true,
	},
	status: {
		type: DataTypes.ENUM("pending", "reviewed", "dismissed"),
		defaultValue: "pending",
	},
	dermatologistId: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
	fakeTrendPostId: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
});

FakeTrendPostReport.belongsTo(User, {
	foreignKey: "dermatologistId",
	as: "dermatologist",
});

FakeTrendPostReport.belongsTo(FakeTrendPost, {
	foreignKey: "fakeTrendPostId",
});

FakeTrendPost.hasMany(FakeTrendPostReport, {
	foreignKey: "fakeTrendPostId",
});

module.exports = FakeTrendPostReport;

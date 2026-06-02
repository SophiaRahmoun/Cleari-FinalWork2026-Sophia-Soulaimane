const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const SkinGoal = sequelize.define(
	"SkinGoal",
	{
		user_id: {
			type: DataTypes.INTEGER,
			allowNull: false,
		},
		goal_type: {
			type: DataTypes.STRING,
			allowNull: true,
			defaultValue: "general",
		},
		description: {
			type: DataTypes.TEXT,
			allowNull: true,
		},
		selected_goals: {
			type: DataTypes.TEXT,
			allowNull: true,
		},
	},
	{
		tableName: "skin_goals",
		timestamps: false,
	}
);

module.exports = SkinGoal;
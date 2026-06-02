const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const User = require("./User");

const Subscription = sequelize.define(
	"Subscription",
	{
		user_id: {
			type: DataTypes.INTEGER,
			allowNull: false,
		},
		subscription_category: {
			type: DataTypes.STRING,
			allowNull: false,
		},
		start_date: {
			type: DataTypes.DATEONLY,
			allowNull: false,
		},
		end_date: {
			type: DataTypes.DATEONLY,
			allowNull: true,
		},
		status: {
			type: DataTypes.ENUM("active", "expired", "cancelled"),
			defaultValue: "active",
			allowNull: false,
		},
	},
	{
		tableName: "subscriptions",
		underscored: true,
	}
);

module.exports = Subscription;
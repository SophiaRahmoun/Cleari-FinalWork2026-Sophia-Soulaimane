const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const DermatologistAvailability = sequelize.define(
	"DermatologistAvailability",
	{
		id: {
			type: DataTypes.INTEGER,
			autoIncrement: true,
			primaryKey: true,
		},

		dermatologist_profile_id: {
			type: DataTypes.INTEGER,
			allowNull: false,
		},

		available_date: {
			type: DataTypes.DATEONLY,
			allowNull: false,
		},

		start_time: {
			type: DataTypes.TIME,
			allowNull: false,
		},

		end_time: {
			type: DataTypes.TIME,
			allowNull: false,
		},

		is_booked: {
			type: DataTypes.BOOLEAN,
			defaultValue: false,
		},
	},
	{
		tableName: "dermatologist_availabilities",
		timestamps: true,
	}
);

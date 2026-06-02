const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const Routine = sequelize.define("Routine", {
	id: {
		type: DataTypes.INTEGER,
		autoIncrement: true,
		primaryKey: true,
	},

	user_id: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},

	product_name: {
		type: DataTypes.STRING(150),
		allowNull: false,
	},

	product_image_url: {
		type: DataTypes.STRING(255),
		allowNull: true,
	},

	product_image_public_id: {
		type: DataTypes.STRING(255),
		allowNull: true,
	},

	usage_time: {
		type: DataTypes.STRING(50),
		allowNull: true,
	},

	notes: {
		type: DataTypes.TEXT,
		allowNull: true,
	},
}, {
	tableName: "routines",
	timestamps: true,
});

module.exports = Routine;
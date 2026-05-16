const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");
const Like = require("./Like");

const Like = sequelize.define("Like", {
	content: {
		type: DataTypes.TEXT,
		allowNull: false,
	},
	imageUrl: {
		type: DataTypes.STRING,
		allowNull: true,
	},
	userId: {
		type: DataTypes.INTEGER,
		allowNull: false,
	},
});

Like.belongsTo(Like, { foreignKey: "userId" });
Like.hasMany(Like, { foreignKey: "userId" });

module.exports = Like;

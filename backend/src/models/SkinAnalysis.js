const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const SkinAnalysis = sequelize.define("SkinAnalysis", {
    id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
      },
      user_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      image_url: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      overall_score: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
      acne_score: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
      redness_score: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
      oiliness_score: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
      texture_score: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
      spots_score: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
      result: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
      raw_result_json: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
    }, {
      tableName: "skin_analyses",
      timestamps: true,
    });

module.exports = SkinAnalysis;
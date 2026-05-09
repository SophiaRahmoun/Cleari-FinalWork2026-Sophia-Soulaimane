const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const SkinFormAnswer = sequelize.define(
  "SkinFormAnswer",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },

    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },

    skin_feeling: {
      type: DataTypes.STRING(50),
      allowNull: true,
    },

    product_reaction: {
      type: DataTypes.STRING(50),
      allowNull: true,
    },

    flakiness: {
      type: DataTypes.STRING(50),
      allowNull: true,
    },

    diagnosed_condition: {
      type: DataTypes.STRING(50),
      allowNull: true,
    },

    has_allergies: {
      type: DataTypes.STRING(50),
      allowNull: true,
    },

    allergies_details: {
      type: DataTypes.TEXT,
      allowNull: true,
    },

    has_skin_issues: {
      type: DataTypes.STRING(50),
      allowNull: true,
    },

    main_concern: {
      type: DataTypes.STRING(100),
      allowNull: true,
    },

    wants_photo_upload: {
      type: DataTypes.BOOLEAN,
      allowNull: true,
    },

    consent_shared: {
      type: DataTypes.BOOLEAN,
      allowNull: true,
    },

    step_completed: {
      type: DataTypes.INTEGER,
      allowNull: true,
      defaultValue: 0,
    },
  },
  {
    tableName: "skin_form_answers",
    timestamps: true,
    createdAt: "created_at",
    updatedAt: "updated_at",
  }
);

module.exports = SkinFormAnswer;
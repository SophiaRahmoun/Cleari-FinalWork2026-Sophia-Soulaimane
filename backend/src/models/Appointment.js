const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Appointment = sequelize.define('Appointment', {
    id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
      },
    
      user_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
    
      dermatologist_profile_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
    
      appointment_date: {
        type: DataTypes.DATEONLY,
        allowNull: false,
      },
    
      appointment_time: {
        type: DataTypes.TIME,
        allowNull: false,
      },
    
      reason: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
    
      status: {
        type: DataTypes.ENUM("pending", "confirmed", "cancelled", "completed"),
        allowNull: false,
        defaultValue: "pending",
      },
    
    }, {
      tableName: "appointments",
      timestamps: true,
    
    });
    
    module.exports = Appointment;
const { Sequelize } = require("sequelize");

const sequelize = new Sequelize({
  dialect: "sqlite",
  storage: "./cleari_dev.sqlite",
  logging: false,
});

module.exports = sequelize;
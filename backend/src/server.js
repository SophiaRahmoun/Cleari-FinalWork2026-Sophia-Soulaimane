const express = require("express");
const cors = require("cors");
require("dotenv").config();
const skinScanRoutes = require("./routes/skinScanRoutes");
const { sequelize } = require("./models");
const skinFormRoutes = require("./routes/skinFormRoutes");
const authRoutes = require("./routes/authRoutes");


const app = express();

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
	res.json({
		message: "Cleari backend is running.",
	});
});

app.use("/api/auth", authRoutes);
app.use("/api/skin-scan", skinScanRoutes);
app.use("/api/skin-form", skinFormRoutes);

const PORT = process.env.PORT || 4000;

const startServer = async () => {
	try {
		await sequelize.authenticate();
		console.log("Database connected successfully.");

		await sequelize.sync();
		console.log("Database synced successfully.");

		app.listen(PORT, () => {
			console.log(`Server running on port ${PORT}`);
		});
	} catch (error) {
		console.error("Unable to start server:", error);
	}
};

startServer();

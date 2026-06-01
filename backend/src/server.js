require("dotenv").config();
const express = require("express");
const cors = require("cors");
const skinScanRoutes = require("./routes/skinScanRoutes");
const { sequelize } = require("./models");
const skinFormRoutes = require("./routes/skinFormRoutes");
const authRoutes = require("./routes/authRoutes");
const dermatologistRoutes = require("./routes/dermatologistRoutes");
const appointmentRoutes = require("./routes/appointmentRoutes");
const fakeTrendPostRoutes = require("./routes/fakeTrPostRoutes");
const paymentRoutes = require("./routes/paymentRoutes");
const { handleStripeWebhook } = require("./controllers/paymentWebhookController");
const userRoutes = require("./routes/userRoutes");
const skinGoalRoutes = require("./routes/skinGoalRoutes");

const app = express();

app.use(cors());
app.post(
	"/api/payments/webhook",
	express.raw({ type: "application/json" }),
	handleStripeWebhook
);
app.use(express.json());

const availabilityRoutes = require("./routes/availabilityRoutes");
app.use("/api/availability", availabilityRoutes);

app.get("/", (req, res) => {
	res.json({
		message: "Cleari backend is running.",
	});
});

app.use("/api/auth", authRoutes);
app.use("/api/skin-scan", skinScanRoutes);
app.use("/api/skin-form", skinFormRoutes);
app.use("/api/dermatologists", dermatologistRoutes);
app.use("/api/appointments", appointmentRoutes);
app.use("/api/availability", availabilityRoutes);
const communityPostRoutes = require("./routes/communityPostRoutes");
app.use("/uploads", express.static("uploads"));
app.use("/api/community", communityPostRoutes);
app.use("/api/fake-trends", fakeTrendPostRoutes);
app.use("/api/payments", paymentRoutes);
app.use("/api/users", userRoutes);
app.use("/api/skin-goals", skinGoalRoutes);
const PORT = process.env.PORT || 4000;

const chatRoutes = require("./routes/chatRoutes");
app.use("/api/chat", chatRoutes);


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

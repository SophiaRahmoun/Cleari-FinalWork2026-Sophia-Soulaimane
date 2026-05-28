const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);

exports.handleStripeWebhook = async (req, res) => {
	const sig = req.headers["stripe-signature"];

	let event;

	try {
		event = stripe.webhooks.constructEvent(
			req.body,
			sig,
			process.env.STRIPE_WEBHOOK_SECRET
		);
	} catch (error) {
		console.log("Webhook signature error:", error.message);
		return res.status(400).send(`Webhook Error: ${error.message}`);
	}

	if (event.type === "checkout.session.completed") {
		const session = event.data.object;

		console.log("PAYMENT SUCCESS FOR USER:", session.metadata.userId);
		console.log("PLAN TYPE:", session.metadata.planType);

		// Later:
		// update user subscription_status = active
	}

	res.json({ received: true });
};
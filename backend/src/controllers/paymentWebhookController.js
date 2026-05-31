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
    
        console.log(
            "PAYMENT SUCCESS FOR USER:",
            session.metadata.userId
        );
    
        console.log(
            "PLAN TYPE:",
            session.metadata.planType
        );
    
        const { Subscription } = require("../models");
    
        await Subscription.create({
            user_id: session.metadata.userId,
            subscription_category: session.metadata.planType,
            start_date: new Date(),
            status: "active",
        });
    
        console.log("SUBSCRIPTION CREATED");
    }

	res.json({ received: true });
};
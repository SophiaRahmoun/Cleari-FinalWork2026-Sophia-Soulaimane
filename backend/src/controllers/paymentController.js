console.log("Stripe key starts with:", process.env.STRIPE_SECRET_KEY?.slice(0, 7));

const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);

exports.createCheckoutSession = async (req, res) => {
	try {
		const { planType } = req.body;

		const priceId =
			planType === "yearly"
				? process.env.STRIPE_PRICE_YEARLY
				: process.env.STRIPE_PRICE_MONTHLY;

		const session = await stripe.checkout.sessions.create({
			mode: "subscription",
			payment_method_types: ["card"],
			line_items: [
				{
					price: priceId,
					quantity: 1,
				},
			],
			success_url: process.env.CLIENT_SUCCESS_URL,
			cancel_url: process.env.CLIENT_CANCEL_URL,
			metadata: {
				userId: req.user.id,
				planType,
			},
		});

		res.json({
			checkoutUrl: session.url,
		});
	} catch (error) {
		res.status(500).json({
			message: "Error creating checkout session",
			error: error.message,
		});
	}
};


function getLevel(score) {
	if (score === null || score === undefined) return "Unknown";
	if (score < 40) return "Low";
	if (score < 70) return "Medium";
	return "High";
}

function buildSkinInsights(scores) {
	const acne = scores.acne?.uiScore ?? null;
	const redness = scores.redness?.uiScore ?? null;
	const oiliness = scores.oiliness?.uiScore ?? null;
	const texture = scores.texture?.uiScore ?? null;
	const moisture = scores.moisture?.uiScore ?? null;

	return [
		{
			key: "moisture",
			title: "Hydration Level",
			level: getLevel(moisture),
			shortText:
				moisture < 40
					? "Your skin may need more hydration today."
					: moisture < 70
						? "Your hydration level looks balanced, but could still be supported."
						: "Your skin looks well hydrated.",
			tip:
				moisture < 40
					? "Use a gentle moisturizer and avoid harsh cleansing."
					: "Keep using a simple hydrating routine.",
		},
		{
			key: "redness",
			title: "Redness",
			level: getLevel(redness),
			shortText:
				redness >= 70
					? "Some visible redness was detected."
					: redness >= 40
						? "A small amount of redness was detected."
						: "Your skin looks quite calm today.",
			tip:
				redness >= 70
					? "Try to avoid strong exfoliants and keep your routine gentle."
					: "Keep monitoring your skin and use soothing products if needed.",
		},
		{
			key: "oiliness",
			title: "Oil Production",
			level: getLevel(oiliness),
			shortText:
				oiliness >= 70
					? "Your skin seems to produce more oil today."
					: oiliness >= 40
						? "Your oil level looks moderate."
						: "Your skin does not look very oily today.",
			tip:
				oiliness >= 70
					? "Use lightweight, non-comedogenic products and avoid over-cleansing."
					: "A simple routine should be enough for now.",
		},
		{
			key: "acne",
			title: "Blemishes",
			level: getLevel(acne),
			shortText:
				acne >= 70
					? "Some blemish-prone areas were detected."
					: acne >= 40
						? "A few possible blemish-prone areas were detected."
						: "Few visible blemishes were detected.",
			tip:
				acne >= 70
					? "Avoid picking your skin and consider asking a dermatologist if it persists."
					: "Keep your routine consistent and avoid too many active ingredients at once.",
		},
		{
			key: "texture",
			title: "Skin Texture",
			level: getLevel(texture),
			shortText:
				texture >= 70
					? "Your skin texture appears a bit uneven."
					: texture >= 40
						? "Your skin texture looks mostly balanced."
						: "Your skin texture looks smooth today.",
			tip:
				texture >= 70
					? "Focus on hydration first before using strong exfoliating products."
					: "Keep following a gentle and regular routine.",
		},
	];
}

module.exports = {
	buildSkinInsights,
};

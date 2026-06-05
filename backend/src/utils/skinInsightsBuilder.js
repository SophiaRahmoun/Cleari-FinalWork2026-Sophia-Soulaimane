// Moisture: higher score = better skin hydration
function getMoistureLevel(score) {
	if (score === null || score === undefined) return "Unknown";
	if (score < 35) return "Low";
	if (score < 65) return "Moderate";
	return "Good";
}

// Redness / acne / oiliness / texture: lower score = better
function getConcernLevel(score) {
	if (score === null || score === undefined) return "Unknown";
	if (score < 35) return "Low";
	if (score < 65) return "Moderate";
	return "Elevated";
}

function buildSkinInsights(scores) {
	const acne     = scores.acne?.uiScore     ?? null;
	const redness  = scores.redness?.uiScore  ?? null;
	const oiliness = scores.oiliness?.uiScore ?? null;
	const texture  = scores.texture?.uiScore  ?? null;
	const moisture = scores.moisture?.uiScore ?? null;

	return [
		{
			key:   "moisture",
			title: "Hydration",
			score: moisture,
			level: getMoistureLevel(moisture),
			shortText:
				moisture === null ? "No data available." :
				moisture < 35     ? "Hydration reads on the lower side today." :
				moisture < 65     ? "Hydration is in a moderate range." :
				                    "Hydration looks good in this scan.",
			tip:
				moisture !== null && moisture < 35
					? "A light, fragrance-free moisturizer may help."
					: "Keep your current routine going.",
		},
		{
			key:   "redness",
			title: "Redness",
			score: redness,
			level: getConcernLevel(redness),
			shortText:
				redness === null ? "No data available." :
				redness < 35     ? "Skin tone appears even and calm." :
				redness < 65     ? "A mild variation in tone was noted." :
				                   "Some unevenness in tone was picked up.",
			tip:
				redness !== null && redness >= 65
					? "Fragrance-free, gentle products tend to work well here."
					: "No specific action needed.",
		},
		{
			key:   "oiliness",
			title: "Oil Level",
			score: oiliness,
			level: getConcernLevel(oiliness),
			shortText:
				oiliness === null ? "No data available." :
				oiliness < 35     ? "Oil production looks low today." :
				oiliness < 65     ? "Oil production is within a normal range." :
				                    "Oil level reads slightly higher in this scan.",
			tip:
				oiliness !== null && oiliness >= 65
					? "Lightweight, water-based products suit this profile well."
					: "Your current routine looks suitable.",
		},
		{
			key:   "acne",
			title: "Blemishes",
			score: acne,
			level: getConcernLevel(acne),
			shortText:
				acne === null ? "No data available." :
				acne < 35     ? "Skin surface looks clear in this scan." :
				acne < 65     ? "A few areas with minor texture variation were noted." :
				                "Some surface irregularity was picked up.",
			tip:
				acne !== null && acne >= 65
					? "A simple, consistent routine is usually the best approach."
					: "Keep your routine stable.",
		},
		{
			key:   "texture",
			title: "Texture",
			score: texture,
			level: getConcernLevel(texture),
			shortText:
				texture === null ? "No data available." :
				texture < 35     ? "Skin surface appears smooth in this scan." :
				texture < 65     ? "Texture is within a normal range." :
				                   "Some surface variation was noted.",
			tip:
				texture !== null && texture >= 65
					? "Hydration often helps with texture over time."
					: "Texture looks stable.",
		},
	];
}

module.exports = {
	buildSkinInsights,
};

function extractTikTokVideoId(url) {
	if (!url) return null;
	const match = url.match(/video\/(\d+)/);
	return match ? match[1] : null;
}

function isValidTikTokUrl(url) {
	if (!url) return true;
	return url.includes("tiktok.com");
}

module.exports = {
	extractTikTokVideoId,
	isValidTikTokUrl,
};

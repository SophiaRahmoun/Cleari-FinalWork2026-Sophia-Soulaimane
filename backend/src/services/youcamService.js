const axios = require("axios");
const fs = require("fs");
const FormData = require("form-data");

const {
	simplifySkinAnalysisResults,
	buildRecommendation,
} = require("../utils/skinAnalysisMapper");

const YOUCAM_BASE_URL = process.env.YOUCAM_BASE_URL;
const YOUCAM_API_KEY = process.env.YOUCAM_API_KEY;

const youcamClient = axios.create({
	baseURL: YOUCAM_BASE_URL,
	headers: {
		Authorization: `Bearer ${YOUCAM_API_KEY}`,
		"Content-Type": "application/json",
	},
});

async function initializeFileUpload({ contentType, fileName, fileSize }) {
	const response = await youcamClient.post("/s2s/v2.0/file/skin-analysis", {
		files: [
			{
				content_type: contentType,
				file_name: fileName,
				file_size: fileSize,
			},
		],
	});

	return response.data;
}

async function uploadFileToPresignedUrl({ url, headers, fileBuffer }) {
	await axios.put(url, fileBuffer, {
		headers: {
			...headers,
		},
		maxBodyLength: Infinity,
		maxContentLength: Infinity,
	});
}

async function createSkinAnalysisTask({ srcFileId }) {
	const response = await youcamClient.post("/s2s/v2.0/task/skin-analysis", {
		src_file_id: srcFileId,
		dst_actions: [
			"acne",
			"moisture",
			"pore",
			"texture",
			"redness",
			"dark_circle_v2",
			"firmness",
			"oiliness",
			"radiance",
			"age_spot",
			"wrinkle",
		],
		miniserver_args: {
			enable_mask_overlay: false,
		},
		format: "json",
		pf_camera_kit: false,
	});

	return response.data;
}

function sleep(ms) {
	return new Promise((resolve) => setTimeout(resolve, ms));
}

async function getSkinAnalysisTask(taskId) {
	const response = await youcamClient.get(
		`/s2s/v2.0/task/skin-analysis/${taskId}`
	);
	return response.data;
}

async function pollSkinAnalysisResult(
	taskId,
	maxAttempts = 20,
	delayMs = 3000
) {
	for (let attempt = 1; attempt <= maxAttempts; attempt++) {
		const result = await getSkinAnalysisTask(taskId);

		const taskStatus = result?.data?.task_status;

		if (taskStatus === "success") {
			return result.data;
		}

		if (taskStatus === "error") {
			throw new Error(JSON.stringify(result));
		}

		await sleep(delayMs);
	}

	throw new Error("Polling timed out before task completed");
}

async function analyzeWithYouCam(file) {
    if (process.env.USE_MOCK_SKIN_SCAN === 'true') {
        return {

            raw: { source: "mock" },
            simplified: {
              scores: {
                acne: { uiScore: 62 },
                redness: { uiScore: 38 },
                oiliness: { uiScore: 71 },
                texture: { uiScore: 55 },
                moisture: { uiScore: 44 }
              },
              recommendation: {
                skinTypeEstimate: "combination",
                recommendationLevel: "monitor",
                shortAdvice: "Moderate concerns were detected. A simple routine and a follow-up scan may be helpful."
              }
            }
          };
        }




	const fileBuffer = fs.readFileSync(file.path);

	const uploadInit = await initializeFileUpload({
		contentType: file.mimetype,
		fileName: file.originalname,
		fileSize: file.size,
	});

	const uploadData = uploadInit?.data?.files?.[0];

	if (!uploadData) {
		throw new Error("Could not initialize YouCam file upload");
	}

	await uploadFileToPresignedUrl({
		url: uploadData.requests[0].url,
		headers: uploadData.requests[0].headers,
		fileBuffer,
	});

	const task = await createSkinAnalysisTask({
		srcFileId: uploadData.file_id,
	});

	const taskId = task?.data?.task_id;

	if (!taskId) {
		throw new Error("Could not create YouCam skin analysis task");
	}

	const resultData = await pollSkinAnalysisResult(taskId);

	const scores = simplifySkinAnalysisResults(resultData);
	const recommendation = buildRecommendation(scores);

	return {
		raw: resultData,
		simplified: {
			scores,
			recommendation,
		},
	};
}

module.exports = {
	initializeFileUpload,
	uploadFileToPresignedUrl,
	createSkinAnalysisTask,
	pollSkinAnalysisResult,
    analyzeWithYouCam,
};

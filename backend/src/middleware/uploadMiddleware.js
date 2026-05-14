const multer = require("multer");
const path = require("path");

const storage = multer.diskStorage({
	destination: (req, file, cb) => {
		cb(null, "src/uploads/community");
	},

	filename: (req, file, cb) => {
		const uniqueName = Date.now() + "-" + file.originalname;
		cb(null, uniqueName);
	},
});

const upload = multer({
	storage,
	limits: { fileSize: 5 * 1024 * 1024 },
	fileFilter: (req, file, cb) => {
		const allowedTypes = /jpeg|jpg|png|webp/;
		const ext = allowedTypes.test(
			path.extname(file.originalname).toLowerCase()
		);
		const mime = allowedTypes.test(file.mimetype);
		if (ext && mime) cb(null, true);
		else cb(new Error("Only images are allowed"));
	},
});

module.exports = upload;

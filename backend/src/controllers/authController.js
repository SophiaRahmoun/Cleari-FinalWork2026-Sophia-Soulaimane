const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { User, DermatologistProfile } = require("../models");

const generateToken = (user) => {
  return jwt.sign(
    {
      id: user.id,
      role: user.role,
      email: user.email,
    },
    process.env.JWT_SECRET,
    {
      expiresIn: process.env.JWT_EXPIRES_IN || "7d",
    }
  );
};

const sanitizeUser = (user) => {
  return {
    id: user.id,
    username: user.username,
    email: user.email,
    role: user.role,
    profile_picture_url: user.profile_picture_url,
    language: user.language,
  };
};

exports.registerUser = async (req, res) => {
  try {
    const { username, email, password, language } = req.body;

    if (!username || !email || !password) {
      return res.status(400).json({
        message: "Username, email and password are required.",
      });
    }

    const existingUser = await User.findOne({ where: { email } });

    if (existingUser) {
      return res.status(409).json({
        message: "This email is already used.",
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create({
      username,
      email,
      password: hashedPassword,
      role: "user",
      language: language || "en",
    });

    const token = generateToken(user);

    return res.status(201).json({
      message: "User registered successfully.",
      token,
      user: sanitizeUser(user),
    });
  } catch (error) {
    return res.status(500).json({
      message: "Error while registering user.",
      error: error.message,
    });
  }
};

exports.registerDermatologist = async (req, res) => {
  try {
    const {
      username,
      email,
      password,
      specialization,
      license_number,
      bio,
      certificate_url,
      language,
    } = req.body;

    if (!username || !email || !password) {
      return res.status(400).json({
        message: "Username, email and password are required.",
      });
    }

    const existingUser = await User.findOne({ where: { email } });

    if (existingUser) {
      return res.status(409).json({
        message: "This email is already used.",
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create({
      username,
      email,
      password: hashedPassword,
      role: "dermatologist",
      language: language || "en",
    });

    await DermatologistProfile.create({
      user_id: user.id,
      specialization: specialization || null,
      license_number: license_number || null,
      bio: bio || null,
      certificate_url: certificate_url || null,
      verification_status: "pending",
      verified: false,
    });

    const token = generateToken(user);

    return res.status(201).json({
      message: "Dermatologist registered successfully. Verification is pending.",
      token,
      user: sanitizeUser(user),
    });
  } catch (error) {
    return res.status(500).json({
      message: "Error while registering dermatologist.",
      error: error.message,
    });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        message: "Email and password are required.",
      });
    }

    const user = await User.findOne({
      where: { email },
      include: [{ model: DermatologistProfile, as: "dermatologistProfile" }],
    });

    if (!user) {
      return res.status(401).json({
        message: "Invalid email or password.",
      });
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      return res.status(401).json({
        message: "Invalid email or password.",
      });
    }

    const token = generateToken(user);

    return res.status(200).json({
      message: "Login successful.",
      token,
      user: {
        ...sanitizeUser(user),
        dermatologistProfile: user.dermatologistProfile || null,
      },
    });
  } catch (error) {
    return res.status(500).json({
      message: "Error while logging in.",
      error: error.message,
    });
  }
};

exports.me = async (req, res) => {
  try {
    const user = await User.findByPk(req.user.id, {
      attributes: { exclude: ["password"] },
      include: [{ model: DermatologistProfile, as: "dermatologistProfile" }],
    });

    return res.status(200).json({
      user,
    });
  } catch (error) {
    return res.status(500).json({
      message: "Error while fetching profile.",
      error: error.message,
    });
  }
};

exports.logout = async (req, res) => {
  return res.status(200).json({
    message: "Logout successful. Please remove the token on the frontend.",
  });
};
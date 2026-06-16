import express from "express";
import pgclient from "../db.js";

const userRoutes = express.Router();

// POST /api/users/register
// Registers a new user (seeker or employer) and creates their profile
userRoutes.post("/register", async (req, res) => {
  const { email, password, role, full_name } = req.body;

  // Validate required fields
  if (!email || !password || !role || !full_name) {
    return res.status(400).json({ message: "All fields are required" });
  }

  // Check if email is already taken
  const existing = await pgclient.query(
    "SELECT id FROM users WHERE email = $1",
    [email]
  );
  if (existing.rows.length > 0) {
    return res.status(409).json({ message: "Email already registered" });
  }

  // Insert the new user
  const result = await pgclient.query(
    "INSERT INTO users (email, password_hash, role, full_name) VALUES ($1, $2, $3, $4) RETURNING id, email, role, full_name",
    [email, password, role, full_name]
  );

  const user = result.rows[0];

  // Create the matching profile based on role
  if (role === "seeker") {
    // Seekers get an empty seeker_profiles row
    await pgclient.query(
      "INSERT INTO seeker_profiles (user_id) VALUES ($1)",
      [user.id]
    );
  } else if (role === "employer") {
    // Employers get a companies row using their name as the company name
    await pgclient.query(
      "INSERT INTO companies (user_id, name, logo_initial) VALUES ($1, $2, $3)",
      [user.id, full_name, full_name.charAt(0).toUpperCase()]
    );
  }

  res.status(201).json({ message: "Account created", user });
});

// POST /api/users/login
// Checks credentials and returns the user object (stored in frontend localStorage)
userRoutes.post("/login", async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: "Email and password are required" });
  }

  const result = await pgclient.query(
    "SELECT id, email, role, full_name, password_hash FROM users WHERE email = $1",
    [email]
  );

  if (result.rows.length === 0) {
    return res.status(401).json({ message: "Invalid credentials" });
  }

  const user = result.rows[0];

  if (user.password_hash !== password) {
    return res.status(401).json({ message: "Invalid credentials" });
  }

  // Return the user object without the password hash
  res.json({
    message: "Login successful",
    user: {
      id: user.id,
      email: user.email,
      role: user.role,
      full_name: user.full_name,
    },
  });
});

export default userRoutes;

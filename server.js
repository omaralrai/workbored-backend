import express from "express";
import cors from "cors";
import morgan from "morgan";
import dotenv from "dotenv";

import pgclient from "./db.js";
import userRoutes from "./routes/users.js";
import jobRoutes from "./routes/jobs.js";
import companyRoutes from "./routes/companies.js";
import seekerRoutes from "./routes/seekers.js";
import applicationRoutes from "./routes/applications.js";
import errorHandler from "./middleware/errorHandler.js";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

// Best Practice: CORS lets the React frontend call this API from a different port
app.use(cors());

// Best Practice: express.json() parses incoming JSON request bodies
app.use(express.json());

// Best Practice: morgan logs every request (method, route, status, response time)
app.use(morgan("dev"));

// --- Routes ---
app.use("/api/users", userRoutes);
app.use("/api/jobs", jobRoutes);
app.use("/api/companies", companyRoutes);
app.use("/api/seekers", seekerRoutes);
app.use("/api/applications", applicationRoutes);

// --- 404 handler (catches any unmatched route) ---
app.use((req, res) => {
  res.status(404).json({ message: "Route not found" });
});

// --- Centralized error handler (Best Practice: Separation of Concerns) ---
app.use(errorHandler);

// --- Connect to PostgreSQL then start the server ---
pgclient.connect().then(() => {
  console.log("Connected to PostgreSQL");
  app.listen(PORT, () => {
    console.log(`Server running on PORT ${PORT}`);
  });
});

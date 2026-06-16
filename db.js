import pg from "pg";
import dotenv from "dotenv";

dotenv.config();

// Best Practice: create one shared client — all routes import this same instance
const pgclient = new pg.Client(process.env.DATABASE_URL);

pgclient.on("error", (err) => console.error("Database error:", err));

export default pgclient;

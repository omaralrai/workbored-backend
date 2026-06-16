import express from "express";
import pgclient from "../db.js";

const companyRoutes = express.Router();

// GET /api/companies/user/:userId — get company by user id (used when employer logs in)
companyRoutes.get("/user/:userId", async (req, res) => {
  const { userId } = req.params;
  const result = await pgclient.query(
    "SELECT * FROM companies WHERE user_id = $1",
    [userId]
  );
  if (result.rows.length === 0) return res.status(404).json({ message: "Company not found" });
  res.json(result.rows[0]);
});

// GET /api/companies/:id — get company profile by company id (public page)
companyRoutes.get("/:id", async (req, res) => {
  const { id } = req.params;
  const result = await pgclient.query(
    "SELECT * FROM companies WHERE id = $1",
    [id]
  );
  if (result.rows.length === 0) return res.status(404).json({ message: "Company not found" });
  res.json(result.rows[0]);
});

// PUT /api/companies/:id — employer updates their company profile
companyRoutes.put("/:id", async (req, res) => {
  const { id } = req.params;
  const {
    name, logo_initial, logo_color, industry,
    company_size, founded_year, website, headquarters, about,
  } = req.body;

  const result = await pgclient.query(
    `UPDATE companies SET
       name=$1, logo_initial=$2, logo_color=$3, industry=$4,
       company_size=$5, founded_year=$6, website=$7,
       headquarters=$8, about=$9, updated_at=NOW()
     WHERE id=$10
     RETURNING *`,
    [name, logo_initial, logo_color, industry, company_size, founded_year, website, headquarters, about, id]
  );
  if (result.rows.length === 0) return res.status(404).json({ message: "Company not found" });
  res.json(result.rows[0]);
});

export default companyRoutes;

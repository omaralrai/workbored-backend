import express from "express";
import pgclient from "../db.js";

const applicationRoutes = express.Router();

// GET /api/applications/company/:companyId — all applications for an employer
applicationRoutes.get("/company/:companyId", async (req, res) => {
  const { companyId } = req.params;
  const result = await pgclient.query(
    `SELECT a.*, u.full_name AS seeker_name, j.title AS job_title
     FROM applications a
     JOIN seeker_profiles sp ON a.seeker_id = sp.id
     JOIN users u ON sp.user_id = u.id
     JOIN job_posts j ON a.job_id = j.id
     WHERE j.company_id = $1
     ORDER BY a.applied_at DESC`,
    [companyId]
  );
  res.json(result.rows);
});

// GET /api/applications/seeker/:seekerId — all applications for a seeker
applicationRoutes.get("/seeker/:seekerId", async (req, res) => {
  const { seekerId } = req.params;
  const result = await pgclient.query(
    `SELECT a.*, j.title AS job_title, j.job_type, j.location, j.work_mode,
            c.name AS company_name, c.logo_initial, c.logo_color
     FROM applications a
     JOIN job_posts j ON a.job_id = j.id
     JOIN companies c ON j.company_id = c.id
     WHERE a.seeker_id = $1
     ORDER BY a.applied_at DESC`,
    [seekerId]
  );
  res.json(result.rows);
});

// POST /api/applications — seeker applies to a job
applicationRoutes.post("/", async (req, res) => {
  const { job_id, seeker_id } = req.body;

  const result = await pgclient.query(
    "INSERT INTO applications (job_id, seeker_id) VALUES ($1, $2) RETURNING *",
    [job_id, seeker_id]
  );
  res.status(201).json(result.rows[0]);
});

// PUT /api/applications/:id — employer updates status and/or adds feedback
applicationRoutes.put("/:id", async (req, res) => {
  const { id } = req.params;
  const { status, employer_feedback } = req.body;

  const result = await pgclient.query(
    `UPDATE applications
     SET status=$1, employer_feedback=$2, status_updated_at=NOW()
     WHERE id=$3
     RETURNING *`,
    [status, employer_feedback, id]
  );
  if (result.rows.length === 0) return res.status(404).json({ message: "Application not found" });
  res.json(result.rows[0]);
});

// DELETE /api/applications/:id — seeker withdraws an application
applicationRoutes.delete("/:id", async (req, res) => {
  const { id } = req.params;
  const result = await pgclient.query(
    "DELETE FROM applications WHERE id=$1 RETURNING *",
    [id]
  );
  if (result.rows.length === 0) return res.status(404).json({ message: "Application not found" });
  res.json({ message: "Application withdrawn" });
});

export default applicationRoutes;

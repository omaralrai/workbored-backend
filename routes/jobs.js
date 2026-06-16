import express from "express";
import pgclient from "../db.js";

const jobRoutes = express.Router();

// GET /api/jobs — all active jobs (public, for job seekers browsing)
jobRoutes.get("/", async (req, res) => {
  const result = await pgclient.query(`
    SELECT j.*, c.name AS company_name, c.logo_initial, c.logo_color, c.headquarters
    FROM job_posts j
    JOIN companies c ON j.company_id = c.id
    WHERE j.status = 'active'
    ORDER BY j.posted_at DESC
  `);
  res.json(result.rows);
});

// GET /api/jobs/company/:companyId — all jobs for one employer (employer dashboard)
jobRoutes.get("/company/:companyId", async (req, res) => {
  const { companyId } = req.params;
  const result = await pgclient.query(
    `SELECT j.*, COUNT(a.id)::int AS applicant_count
     FROM job_posts j
     LEFT JOIN applications a ON a.job_id = j.id
     WHERE j.company_id = $1
     GROUP BY j.id
     ORDER BY j.posted_at DESC`,
    [companyId]
  );
  res.json(result.rows);
});

// GET /api/jobs/:id — single job detail page
jobRoutes.get("/:id", async (req, res) => {
  const { id } = req.params;
  const result = await pgclient.query(
    `SELECT j.*, c.name AS company_name, c.logo_initial, c.logo_color,
            c.industry, c.company_size, c.founded_year, c.website, c.headquarters, c.about
     FROM job_posts j
     JOIN companies c ON j.company_id = c.id
     WHERE j.id = $1`,
    [id]
  );
  if (result.rows.length === 0) return res.status(404).json({ message: "Job not found" });
  res.json(result.rows[0]);
});

// POST /api/jobs — employer creates a new job post
jobRoutes.post("/", async (req, res) => {
  const {
    company_id, title, job_type, experience_level, department,
    location, work_mode, salary_min, salary_max, salary_display,
    description, responsibilities, requirements, benefits, tags, expires_at,
  } = req.body;

  const result = await pgclient.query(
    `INSERT INTO job_posts
       (company_id, title, job_type, experience_level, department, location, work_mode,
        salary_min, salary_max, salary_display, description, responsibilities,
        requirements, benefits, tags, expires_at)
     VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16)
     RETURNING *`,
    [
      company_id, title, job_type, experience_level, department, location, work_mode,
      salary_min, salary_max, salary_display, description, responsibilities,
      requirements, benefits, tags, expires_at,
    ]
  );
  res.status(201).json(result.rows[0]);
});

// PUT /api/jobs/:id — employer updates a job post
jobRoutes.put("/:id", async (req, res) => {
  const { id } = req.params;
  const {
    title, job_type, experience_level, department, location, work_mode,
    salary_min, salary_max, salary_display, description, responsibilities,
    requirements, benefits, tags, expires_at,
  } = req.body;

  const result = await pgclient.query(
    `UPDATE job_posts SET
       title=$1, job_type=$2, experience_level=$3, department=$4, location=$5,
       work_mode=$6, salary_min=$7, salary_max=$8, salary_display=$9,
       description=$10, responsibilities=$11, requirements=$12,
       benefits=$13, tags=$14, expires_at=$15
     WHERE id=$16
     RETURNING *`,
    [
      title, job_type, experience_level, department, location, work_mode,
      salary_min, salary_max, salary_display, description, responsibilities,
      requirements, benefits, tags, expires_at, id,
    ]
  );
  if (result.rows.length === 0) return res.status(404).json({ message: "Job not found" });
  res.json(result.rows[0]);
});

// PATCH /api/jobs/:id/status — pause, resume, or close a job
jobRoutes.patch("/:id/status", async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;
  const result = await pgclient.query(
    "UPDATE job_posts SET status=$1 WHERE id=$2 RETURNING *",
    [status, id]
  );
  if (result.rows.length === 0) return res.status(404).json({ message: "Job not found" });
  res.json(result.rows[0]);
});

// DELETE /api/jobs/:id — employer deletes a job post
jobRoutes.delete("/:id", async (req, res) => {
  const { id } = req.params;
  const result = await pgclient.query(
    "DELETE FROM job_posts WHERE id=$1 RETURNING *",
    [id]
  );
  if (result.rows.length === 0) return res.status(404).json({ message: "Job not found" });
  res.json({ message: "Job deleted", job: result.rows[0] });
});

export default jobRoutes;

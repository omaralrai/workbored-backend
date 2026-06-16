import express from "express";
import pgclient from "../db.js";

const seekerRoutes = express.Router();

// GET /api/seekers/user/:userId — get seeker profile by user id (used right after login)
seekerRoutes.get("/user/:userId", async (req, res) => {
  const { userId } = req.params;

  const profileResult = await pgclient.query(
    `SELECT sp.*, u.full_name, u.email
     FROM seeker_profiles sp
     JOIN users u ON sp.user_id = u.id
     WHERE sp.user_id = $1`,
    [userId]
  );
  if (profileResult.rows.length === 0) return res.status(404).json({ message: "Seeker not found" });

  const seekerId = profileResult.rows[0].id;

  const skillsResult = await pgclient.query(
    "SELECT * FROM seeker_skills WHERE seeker_id = $1",
    [seekerId]
  );

  const resumeResult = await pgclient.query(
    "SELECT * FROM seeker_resumes WHERE seeker_id = $1 ORDER BY uploaded_at DESC LIMIT 1",
    [seekerId]
  );

  res.json({
    ...profileResult.rows[0],
    skills: skillsResult.rows,
    resume: resumeResult.rows[0] || null,
  });
});

// GET /api/seekers/:id — get seeker profile by seeker id
seekerRoutes.get("/:id", async (req, res) => {
  const { id } = req.params;

  const profileResult = await pgclient.query(
    `SELECT sp.*, u.full_name, u.email
     FROM seeker_profiles sp
     JOIN users u ON sp.user_id = u.id
     WHERE sp.id = $1`,
    [id]
  );
  if (profileResult.rows.length === 0) return res.status(404).json({ message: "Seeker not found" });

  const skillsResult = await pgclient.query(
    "SELECT * FROM seeker_skills WHERE seeker_id = $1",
    [id]
  );

  const resumeResult = await pgclient.query(
    "SELECT * FROM seeker_resumes WHERE seeker_id = $1 ORDER BY uploaded_at DESC LIMIT 1",
    [id]
  );

  res.json({
    ...profileResult.rows[0],
    skills: skillsResult.rows,
    resume: resumeResult.rows[0] || null,
  });
});

// PUT /api/seekers/:id — seeker updates their profile
seekerRoutes.put("/:id", async (req, res) => {
  const { id } = req.params;
  const { job_title, phone, location, linkedin_url, professional_summary } = req.body;

  const result = await pgclient.query(
    `UPDATE seeker_profiles SET
       job_title=$1, phone=$2, location=$3,
       linkedin_url=$4, professional_summary=$5, updated_at=NOW()
     WHERE id=$6
     RETURNING *`,
    [job_title, phone, location, linkedin_url, professional_summary, id]
  );
  if (result.rows.length === 0) return res.status(404).json({ message: "Seeker not found" });
  res.json(result.rows[0]);
});

// POST /api/seekers/:id/skills — add a skill to seeker profile
seekerRoutes.post("/:id/skills", async (req, res) => {
  const { id } = req.params;
  const { skill_name } = req.body;

  const result = await pgclient.query(
    "INSERT INTO seeker_skills (seeker_id, skill_name) VALUES ($1, $2) RETURNING *",
    [id, skill_name]
  );
  res.status(201).json(result.rows[0]);
});

// DELETE /api/seekers/:id/skills/:skillId — remove a skill from seeker profile
seekerRoutes.delete("/:id/skills/:skillId", async (req, res) => {
  const { skillId } = req.params;
  await pgclient.query("DELETE FROM seeker_skills WHERE id = $1", [skillId]);
  res.json({ message: "Skill removed" });
});

export default seekerRoutes;

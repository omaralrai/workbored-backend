# WorkBored Backend (Express + PostgreSQL)

This is the **backend** for WorkBored — a full-stack job board web application built with **Express.js + Node.js + PostgreSQL**.

## Description

The API supports two types of users:

- **Job Seekers** — register, log in, browse jobs, apply, track applications, update profile, upload resume
- **Employers** — register, log in, post and manage jobs, review applicants, update company profile

Data is stored in a **PostgreSQL** database. The React frontend connects to this API on `http://localhost:5000`.

---

## Technologies

- Node.js + Express.js
- PostgreSQL (via `pg` — node-postgres)
- multer (file uploads)
- morgan (request logging)
- cors (cross-origin requests)
- dotenv (environment variables)
- nodemon (auto-restart in development)

---

## Getting Started

### 1. Install dependencies

```bash
cd workbored-backend
npm install
```

### 2. Create `.env`

```
PORT=5000
DATABASE_URL=postgresql://postgres:newpassword123@localhost:5432/workbored
```

### 3. Set up the database

Open pgAdmin, connect to the `workbored` database, and run `schema.sql`.

Or use the seed script to drop, recreate, and seed all tables at once:

```bash
node run_seed.mjs
```

### 4. Start the server

```bash
npm start
```

Server runs on `http://localhost:5000`.

---

## Seeded Test Credentials

Use these to log in and test the app after running `run_seed.mjs`.

### Employers

| Company    | Email                   | Password      |
|------------|-------------------------|---------------|
| Aramex     | admin@aramex.com        | aramex123     |
| Mawdoo3    | admin@mawdoo3.com       | mawdoo3123    |
| Optimiza   | admin@optimiza.com      | optimiza123   |
| Estarta    | admin@estarta.com       | estarta123    |
| MenaITech  | admin@menaitech.com     | menatech123   |
| Hikma      | admin@hikma.com         | hikma123      |

### Seekers

| Name           | Email                        | Password    |
|----------------|------------------------------|-------------|
| John Doe       | john.doe@university.edu      | john123     |
| Sarah Khalil   | sarah.khalil@email.com       | sarah123    |
| Omar Mansour   | omar.mansour@email.com       | omar123     |
| Lina Habash    | lina.habash@email.com        | lina123     |
| Yousef Awad    | yousef.awad@email.com        | yousef123   |
| Rana Nasser    | rana.nasser@email.com        | rana123     |
| Khaled Atiyeh  | khaled.atiyeh@email.com      | khaled123   |
| Nour Haddad    | nour.haddad@email.com        | nour123     |
| Maya Sabbagh   | maya.sabbagh@email.com       | maya123     |

> Best demo account: `john.doe@university.edu` / `john123` — has applications in every status.

---

## API Reference

Base URL: `http://localhost:5000`

---

### Auth — `/api/users`

| Method | Endpoint    | Description             |
|--------|-------------|-------------------------|
| POST   | `/register` | Register a new user     |
| POST   | `/login`    | Log in an existing user |

**POST `/api/users/register`**
```json
{
  "email": "user@example.com",
  "password": "secret123",
  "role": "seeker",
  "full_name": "Jane Smith"
}
```
Role must be `seeker` or `employer`. A profile row is automatically created in `seeker_profiles` or `companies`.

**POST `/api/users/login`**
```json
{ "email": "user@example.com", "password": "secret123" }
```
Returns `{ id, email, role, full_name }` — stored in frontend localStorage.

---

### Jobs — `/api/jobs`

| Method | Endpoint              | Description                        |
|--------|-----------------------|------------------------------------|
| GET    | `/`                   | Get all active job listings        |
| GET    | `/company/:companyId` | Get all jobs for one employer      |
| GET    | `/:id`                | Get a single job detail            |
| POST   | `/`                   | Create a new job post              |
| PUT    | `/:id`                | Update a job post                  |
| PATCH  | `/:id/status`         | Change status (active/paused/closed)|
| DELETE | `/:id`                | Delete a job post                  |

**POST `/api/jobs`**
```json
{
  "company_id": 1,
  "title": "Frontend Developer",
  "job_type": "full-time",
  "experience_level": "mid-level",
  "location": "Amman, Jordan",
  "work_mode": "hybrid",
  "salary_display": "800–1200 JOD/month",
  "description": "Build and maintain React applications.",
  "responsibilities": "...",
  "requirements": "..."
}
```

**PATCH `/api/jobs/:id/status`**
```json
{ "status": "paused" }
```

---

### Companies — `/api/companies`

| Method | Endpoint        | Description                       |
|--------|-----------------|-----------------------------------|
| GET    | `/user/:userId` | Get company by user id            |
| GET    | `/:id`          | Get company profile by company id |
| PUT    | `/:id`          | Update company profile            |

**PUT `/api/companies/:id`**
```json
{
  "name": "Aramex",
  "logo_initial": "A",
  "logo_color": "blue",
  "industry": "Logistics",
  "company_size": "5,001–10,000",
  "founded_year": 1982,
  "website": "aramex.com",
  "headquarters": "Amman, Jordan",
  "about": "Global logistics provider."
}
```

---

### Seekers — `/api/seekers`

| Method | Endpoint               | Description                     |
|--------|------------------------|---------------------------------|
| GET    | `/user/:userId`        | Get seeker profile by user id   |
| GET    | `/:id`                 | Get seeker profile by seeker id |
| PUT    | `/:id`                 | Update seeker profile           |
| POST   | `/:id/skills`          | Add a skill                     |
| DELETE | `/:id/skills/:skillId` | Remove a skill                  |
| POST   | `/:id/resume`          | Upload or replace resume file   |

**PUT `/api/seekers/:id`**
```json
{
  "job_title": "Frontend Developer",
  "phone": "+962 7x xxx xxxx",
  "location": "Amman, Jordan",
  "linkedin_url": "linkedin.com/in/username",
  "professional_summary": "..."
}
```

**POST `/api/seekers/:id/skills`**
```json
{ "skill_name": "React.js" }
```

**POST `/api/seekers/:id/resume`** — `multipart/form-data`

Send file as field name `resume`. Accepts `.pdf`, `.doc`, `.docx` (max 5 MB).
Returns the new resume record. Uploaded files are served at `/uploads/<filename>`.

---

### Applications — `/api/applications`

| Method | Endpoint              | Description                             |
|--------|-----------------------|-----------------------------------------|
| GET    | `/company/:companyId` | Get all applications for an employer    |
| GET    | `/seeker/:seekerId`   | Get all applications for a seeker       |
| POST   | `/`                   | Seeker applies to a job                 |
| PUT    | `/:id`                | Employer updates status / adds feedback |
| DELETE | `/:id`                | Seeker withdraws an application         |

**POST `/api/applications`**
```json
{ "job_id": 3, "seeker_id": 1 }
```

**PUT `/api/applications/:id`**
```json
{
  "status": "under_review",
  "employer_feedback": "Strong portfolio — reviewing with the team."
}
```

Application statuses: `pending` → `under_review` → `interview` → `approved` / `rejected`

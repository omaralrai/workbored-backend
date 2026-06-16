# 🧠 WorkBored Backend (Express + PostgreSQL)

This is the **backend** for WorkBored — a full-stack job board web application built with **Express.js + Node.js + PostgreSQL**.

## 🎯 Description

The API supports two types of users:

- 👤 **Job Seekers:**
  - Register and log in
  - Browse and apply to job listings
  - Track their application statuses
  - Manage their profile and skills

- 🏢 **Employers:**
  - Register and log in
  - Post, edit, and manage job listings
  - Review applications and update applicant statuses
  - Manage their company profile

Data is stored in a **PostgreSQL** database. The frontend connects to this API running on `http://localhost:5000`.

---

## 🔌 API Endpoints

The API runs on: `http://localhost:5000`

---

### 🔒 Auth Routes

**Base URL:** `/api/users`

| Method | Endpoint    | Description               |
| :----- | :---------- | :------------------------ |
| POST   | `/register` | Register a new user       |
| POST   | `/login`    | Log in an existing user   |

#### 🔶 POST `/api/users/register`

Registers a new user. Role must be `seeker` or `employer`. A matching profile row is automatically created in `seeker_profiles` (for seekers) or `companies` (for employers).

```json
{
  "email": "omar@example.com",
  "password": "secret123",
  "role": "seeker",
  "full_name": "Omar Al-Rai"
}
```

#### 🔶 POST `/api/users/login`

Logs in an existing user. Returns the user object stored in frontend localStorage.

```json
{
  "email": "omar@example.com",
  "password": "secret123"
}
```

---

### 📋 Jobs Routes

**Base URL:** `/api/jobs`

| Method | Endpoint              | Description                        |
| :----- | :-------------------- | :--------------------------------- |
| GET    | `/`                   | Get all active job listings        |
| GET    | `/company/:companyId` | Get all jobs for one employer      |
| GET    | `/:id`                | Get a single job detail            |
| POST   | `/`                   | Create a new job post              |
| PUT    | `/:id`                | Update a job post                  |
| PATCH  | `/:id/status`         | Change job status (active/paused/closed) |
| DELETE | `/:id`                | Delete a job post                  |

#### 🔶 POST `/api/jobs`

```json
{
  "company_id": 1,
  "title": "Frontend Developer",
  "job_type": "full-time",
  "experience_level": "mid-level",
  "location": "Amman, Jordan",
  "work_mode": "hybrid",
  "salary_display": "800 - 1200 JOD/month",
  "description": "Build and maintain React applications."
}
```

#### 🔶 PATCH `/api/jobs/:id/status`

```json
{ "status": "paused" }
```

---

### 🏢 Companies Routes

**Base URL:** `/api/companies`

| Method | Endpoint         | Description                        |
| :----- | :--------------- | :--------------------------------- |
| GET    | `/user/:userId`  | Get company by user id             |
| GET    | `/:id`           | Get company profile by company id  |
| PUT    | `/:id`           | Update company profile             |

#### 🔶 PUT `/api/companies/:id`

```json
{
  "name": "TechCorp",
  "logo_initial": "T",
  "logo_color": "blue",
  "industry": "Technology",
  "headquarters": "Amman, Jordan",
  "about": "We build great software."
}
```

---

### 👤 Seekers Routes

**Base URL:** `/api/seekers`

| Method | Endpoint                    | Description                       |
| :----- | :-------------------------- | :-------------------------------- |
| GET    | `/user/:userId`             | Get seeker profile by user id     |
| GET    | `/:id`                      | Get seeker profile by seeker id   |
| PUT    | `/:id`                      | Update seeker profile             |
| POST   | `/:id/skills`               | Add a skill                       |
| DELETE | `/:id/skills/:skillId`      | Remove a skill                    |

#### 🔶 POST `/api/seekers/:id/skills`

```json
{ "skill_name": "React.js" }
```

---

### 📨 Applications Routes

**Base URL:** `/api/applications`

| Method | Endpoint                  | Description                              |
| :----- | :------------------------ | :--------------------------------------- |
| GET    | `/company/:companyId`     | Get all applications for an employer     |
| GET    | `/seeker/:seekerId`       | Get all applications for a seeker        |
| POST   | `/`                       | Seeker applies to a job                  |
| PUT    | `/:id`                    | Employer updates status / adds feedback  |
| DELETE | `/:id`                    | Seeker withdraws an application          |

#### 🔶 POST `/api/applications`

```json
{ "job_id": 3, "seeker_id": 1 }
```

#### 🔶 PUT `/api/applications/:id`

```json
{
  "status": "under_review",
  "employer_feedback": "We liked your portfolio!"
}
```

---

## 🛠️ Technologies

- Node.js
- Express.js
- PostgreSQL (via `pg` — node-postgres)
- morgan (request logging)
- cors (cross-origin requests from React frontend)
- dotenv (environment variables)
- nodemon (auto-restart in development)

---

## 🚀 Getting Started

```bash
cd workbored-backend
npm install
```

Create a `.env` file (copy from `.env.sample`):

```
PORT=5000
DATABASE_URL=postgresql://<username>:<password>@localhost:5432/workbored
```

Run the schema in pgAdmin against the `workbored` database:

```
schema.sql
```

Start the server:

```bash
npm start
```

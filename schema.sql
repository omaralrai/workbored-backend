-- ============================================================
-- WorkBored — Database Schema
-- Run this file in pgAdmin against the "workbored" database
-- ============================================================

-- 1. Users (shared by both seekers and employers)
CREATE TABLE users (
  id            SERIAL PRIMARY KEY,
  email         VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role          VARCHAR(10)  NOT NULL CHECK (role IN ('seeker', 'employer')),
  full_name     VARCHAR(255) NOT NULL,
  created_at    TIMESTAMPTZ  DEFAULT NOW()
);

-- 2. Companies (one company per employer account)
CREATE TABLE companies (
  id           SERIAL PRIMARY KEY,
  user_id      INTEGER      UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name         VARCHAR(255) NOT NULL,
  logo_initial VARCHAR(2)   NOT NULL DEFAULT 'C',
  logo_color   VARCHAR(10)  NOT NULL DEFAULT 'blue'
               CHECK (logo_color IN ('blue', 'green', 'orange', 'red')),
  industry     VARCHAR(100),
  company_size VARCHAR(50),
  founded_year INTEGER,
  website      VARCHAR(255),
  headquarters VARCHAR(255),
  about        TEXT,
  created_at   TIMESTAMPTZ  DEFAULT NOW(),
  updated_at   TIMESTAMPTZ  DEFAULT NOW()
);

-- 3. Seeker Profiles (one profile per seeker account)
CREATE TABLE seeker_profiles (
  id                   SERIAL PRIMARY KEY,
  user_id              INTEGER UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  job_title            VARCHAR(255),
  phone                VARCHAR(50),
  location             VARCHAR(255),
  linkedin_url         VARCHAR(500),
  professional_summary TEXT,
  created_at           TIMESTAMPTZ DEFAULT NOW(),
  updated_at           TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Seeker Skills
CREATE TABLE seeker_skills (
  id         SERIAL PRIMARY KEY,
  seeker_id  INTEGER      NOT NULL REFERENCES seeker_profiles(id) ON DELETE CASCADE,
  skill_name VARCHAR(100) NOT NULL
);

-- 5. Seeker Resumes
CREATE TABLE seeker_resumes (
  id           SERIAL PRIMARY KEY,
  seeker_id    INTEGER      NOT NULL REFERENCES seeker_profiles(id) ON DELETE CASCADE,
  filename     VARCHAR(255) NOT NULL,
  file_path    VARCHAR(500) NOT NULL,
  file_size_kb INTEGER,
  uploaded_at  TIMESTAMPTZ  DEFAULT NOW()
);

-- 6. Job Posts
CREATE TABLE job_posts (
  id               SERIAL PRIMARY KEY,
  company_id       INTEGER      NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  title            VARCHAR(255) NOT NULL,
  job_type         VARCHAR(20)  NOT NULL
                   CHECK (job_type IN ('full-time', 'internship', 'part-time', 'contract')),
  experience_level VARCHAR(20)
                   CHECK (experience_level IN ('entry', 'mid-level', 'senior', 'lead')),
  department       VARCHAR(100),
  location         VARCHAR(255),
  work_mode        VARCHAR(10)
                   CHECK (work_mode IN ('on-site', 'hybrid', 'remote')),
  salary_min       INTEGER,
  salary_max       INTEGER,
  salary_display   VARCHAR(100),
  description      TEXT,
  responsibilities TEXT,
  requirements     TEXT,
  benefits         TEXT,
  tags             VARCHAR(255),
  status           VARCHAR(10)  NOT NULL DEFAULT 'active'
                   CHECK (status IN ('active', 'paused', 'closed')),
  posted_at        TIMESTAMPTZ  DEFAULT NOW(),
  expires_at       DATE
);

-- 7. Applications
CREATE TABLE applications (
  id                SERIAL PRIMARY KEY,
  job_id            INTEGER     NOT NULL REFERENCES job_posts(id) ON DELETE CASCADE,
  seeker_id         INTEGER     NOT NULL REFERENCES seeker_profiles(id) ON DELETE CASCADE,
  applied_at        TIMESTAMPTZ DEFAULT NOW(),
  status            VARCHAR(15) NOT NULL DEFAULT 'pending'
                    CHECK (status IN ('pending', 'under_review', 'interview', 'approved', 'rejected')),
  employer_feedback TEXT,
  status_updated_at TIMESTAMPTZ DEFAULT NOW(),
  is_withdrawn      BOOLEAN     DEFAULT FALSE,
  UNIQUE (job_id, seeker_id)
);

-- ============================================================
-- WorkBored — Seed Data
-- Run this AFTER schema.sql against the "workbored" database
-- Passwords are stored as plain text (no bcrypt — course project)
-- ============================================================

-- ============================================================
-- EMPLOYER ACCOUNTS & COMPANIES
-- ============================================================
-- Login credentials summary:
--   hr@zettaglobal.com        / zetta123
--   jobs@eondental.com        / dental123
--   hr@makeworkflow.com       / workflow123
--   recruit@techstream.com    / stream123
-- ============================================================

-- 1. Zetta Global
WITH u1 AS (
  INSERT INTO users (email, password_hash, role, full_name)
  VALUES ('hr@zettaglobal.com', 'zetta123', 'employer', 'Zetta Global HR')
  RETURNING id
)
INSERT INTO companies (user_id, name, logo_initial, logo_color, industry, company_size, founded_year, website, headquarters, about)
SELECT id, 'Zetta Global', 'Z', 'blue', 'Information Technology', '51-200', 2018,
       'https://zettaglobal.com', 'Houston, TX',
       'Zetta Global is a visionary IT and Consultancy company specializing in advanced technology solutions, intelligent operations, and strategic IT consulting. We deliver innovation and value to businesses worldwide by seamlessly blending creativity and technology.'
FROM u1;

-- 2. Eon Dental
WITH u2 AS (
  INSERT INTO users (email, password_hash, role, full_name)
  VALUES ('jobs@eondental.com', 'dental123', 'employer', 'Eon Dental HR')
  RETURNING id
)
INSERT INTO companies (user_id, name, logo_initial, logo_color, industry, company_size, founded_year, website, headquarters, about)
SELECT id, 'Eon Dental', 'E', 'green', 'Healthcare Technology', '11-50', 2016,
       'https://eondental.com', 'Amman, Jordan',
       'Eon Dental develops AI-powered orthodontic solutions, specializing in 3D data processing and computer vision for dental workflows. We are passionate about merging healthcare with cutting-edge technology.'
FROM u2;

-- 3. Make Work Flow
WITH u3 AS (
  INSERT INTO users (email, password_hash, role, full_name)
  VALUES ('hr@makeworkflow.com', 'workflow123', 'employer', 'MakeWorkFlow HR')
  RETURNING id
)
INSERT INTO companies (user_id, name, logo_initial, logo_color, industry, company_size, founded_year, website, headquarters, about)
SELECT id, 'Make Work Flow', 'M', 'orange', 'Manufacturing SaaS', '11-50', 2019,
       'https://makeworkflow.de', 'Hamburg, Germany',
       'Make Work Flow GmbH builds SaaS products for real-time production tracking in factories across Europe and Asia. We combine IoT, AI, and lean digitalization to modernize manufacturing operations.'
FROM u3;

-- 4. TechStream
WITH u4 AS (
  INSERT INTO users (email, password_hash, role, full_name)
  VALUES ('recruit@techstream.com', 'stream123', 'employer', 'TechStream Recruitment')
  RETURNING id
)
INSERT INTO companies (user_id, name, logo_initial, logo_color, industry, company_size, founded_year, website, headquarters, about)
SELECT id, 'TechStream', 'T', 'red', 'Media & Streaming', '51-200', 2017,
       'https://techstream.io', 'Dubai, UAE',
       'TechStream builds immersive media technology serving millions of users globally. Our revolutionary streaming platform powers real-time, high-performance video experiences. We are always looking for passionate engineers to join our Dubai team.'
FROM u4;


-- ============================================================
-- JOB POSTS (7 jobs from real JDs)
-- ============================================================

-- Job 1: AI Developer Position — Zetta Global
INSERT INTO job_posts (
  company_id, title, job_type, experience_level, department,
  location, work_mode, salary_display,
  description, responsibilities, requirements, benefits, tags, status
)
SELECT
  c.id,
  'AI Developer',
  'full-time', 'mid-level', 'Engineering',
  'Houston, TX', 'hybrid', '$60,000 – $85,000 / year',
  'Join Zetta Global where innovation, strategy, and impact converge. We are looking for a dynamic AI Developer to assist in the design, development, and implementation of AI-driven applications and systems. This is a high-impact role with exposure to leadership and key decision-makers.',
  E'Assist in designing, developing, and implementing AI-driven applications and systems\nCollaborate with senior developers to build and deploy machine learning models\nContribute to data preprocessing — cleaning, transforming, and preparing datasets\nSupport integration of AI models into production systems\nTest and validate AI models and algorithms, adjusting to improve accuracy\nMonitor model performance and optimize based on real-world data feedback\nCollaborate with cross-functional teams to define project requirements\nMaintain detailed documentation on AI systems, code, and processes',
  E'Bachelor''s degree in Computer Science, Software Engineering, or Data Science\nExperience with Python, Java, or C++ (Python preferred for AI)\nFamiliarity with TensorFlow, PyTorch, or Keras\nBasic understanding of data structures and algorithms relevant to AI\nExperience with Pandas, NumPy, or similar data manipulation libraries\nKnowledge of SQL or NoSQL databases and large dataset handling\nFamiliarity with Git for version control\nStrong analytical and problem-solving skills',
  E'Fast-growing technology firm with exciting career advancement opportunities\nHigh-impact role with direct exposure to leadership\nPotential pathway to senior AI Engineer or Chief of Staff position\nFlexible hybrid work arrangement\nCompetitive salary with performance bonuses',
  'Python,AI,Machine Learning,TensorFlow,PyTorch,Deep Learning',
  'active'
FROM companies c WHERE c.name = 'Zetta Global';

-- Job 2: Business & Venture Analyst — Zetta Global
INSERT INTO job_posts (
  company_id, title, job_type, experience_level, department,
  location, work_mode, salary_display,
  description, responsibilities, requirements, benefits, tags, status
)
SELECT
  c.id,
  'Business & Venture Analyst',
  'full-time', 'entry', 'Strategy & Finance',
  'Houston, TX', 'on-site', '$40,000 – $55,000 / year',
  'Support strategic decision making through research, data gathering, and early-stage analysis of companies, markets, and emerging opportunities. This role is ideal for a recent graduate with a background in technology and finance who wants to shape how Zetta Global grows.',
  E'Apply financial analysis, market research, and venture evaluation\nGather information on companies, markets, and industry sectors\nConduct preliminary research to identify trends, competitors, and opportunities\nInterpret basic financial statements and performance indicators\nCompile portfolio data, track KPIs, and organize insights\nAssist in preparing materials and summaries for investor calls\nMaintain organized documentation, research notes, and presentations\nSupport social media posting and communication tasks when needed',
  E'Recent graduate in a related field (this year or past year)\nStrong academic performance required\nBackground in both technology and finance is a must\nUnderstanding of investment cycles and entrepreneurship basics\nComfortable with risk and opportunity assessments\nExperience with analytics dashboards and basic data models',
  E'Direct exposure to senior leadership and investors\nFast-paced startup environment with real responsibility from day one\nCareer pathway to strategic and investment roles\nCompetitive entry-level compensation package',
  'Finance,Business Analysis,Market Research,Strategy,Venture Capital',
  'active'
FROM companies c WHERE c.name = 'Zetta Global';

-- Job 3: Computer Vision Engineer Apprenticeship — Eon Dental
INSERT INTO job_posts (
  company_id, title, job_type, experience_level, department,
  location, work_mode, salary_display,
  description, responsibilities, requirements, benefits, tags, status
)
SELECT
  c.id,
  'Computer Vision Engineer — Apprenticeship',
  'internship', 'entry', 'AI & Engineering',
  'Amman, Jordan', 'hybrid', 'Stipend · 400 JOD/month',
  '8-month HTU Apprenticeship Program at Eon Dental. You will work on computer vision for 3D data processing and mesh analysis, focusing on dental impression classification, 3D segmentation, and developing algorithm-based solutions for orthodontic workflows. Mentored by senior AI engineers.',
  E'Design and implement algorithms for classifying and segmenting 3D meshes (STL files)\nCreate and maintain pipelines for cleaning, normalizing, and preparing 3D data\nDevelop tools to enhance efficiency of 3D data processing workflows\nWork with AI engineers to integrate algorithmic solutions into production systems\nConduct extensive testing and debugging of algorithms in real-world scenarios\nMaintain detailed documentation of algorithmic designs and integration processes',
  E'Bachelor''s degree in Computer Science, Data Science, AI, Electrical or Mechanical Engineering\nStrong programming skills in Python\nProficiency in Open3D, PyMeshLab, or Trimesh for 3D data processing\nFamiliarity with machine learning frameworks (TensorFlow or PyTorch)\nBasic understanding of 3D mesh structures and STL file handling\nKnowledge of 3D mesh tools or CAD systems is a plus',
  E'Hands-on experience in Computer Vision Engineering from day one\nMentorship from Abdullah Al-Zabt (Senior AI Engineer) and Moayad AlSouqi (AI Engineer)\nExposure to orthodontic AI technology used in real clinical environments\nApprenticeship Certificate of Completion from Eon Dental\nOpportunity for full-time employment based on performance',
  'Python,Computer Vision,3D Processing,Open3D,TensorFlow,PyTorch,STL',
  'active'
FROM companies c WHERE c.name = 'Eon Dental';

-- Job 4: AI & Integration Associate — Eon Dental
INSERT INTO job_posts (
  company_id, title, job_type, experience_level, department,
  location, work_mode, salary_display,
  description, responsibilities, requirements, benefits, tags, status
)
SELECT
  c.id,
  'AI & Integration Associate',
  'full-time', 'entry', 'IT / Digital Transformation',
  'Amman, Jordan', 'on-site', '500 – 700 JOD / month',
  'The AI & Integration Associate will support the design, development, and implementation of AI-driven solutions and system integrations to enhance efficiency across departments, particularly within Odoo ERP. This entry-level role is ideal for a fresh graduate eager to work on AI automation in a healthcare technology environment.',
  E'Assist in identifying opportunities to automate repetitive tasks within Odoo ERP\nSupport training, testing, and deploying AI models (OCR, demand forecasting)\nContribute to prompt design and testing for AI chatbots\nAssist in integrating Odoo ERP with third-party platforms (e-commerce, CRM)\nSupport API development and data synchronization between systems\nHelp clean and prepare data for AI models and reporting tools\nAssist in generating periodic reports using Power BI or Odoo reporting tools\nParticipate in UAT (user acceptance testing) for new Odoo modules',
  E'Fresh graduate or entry-level candidate in Computer Science, IT, or related field\nBasic Python or JavaScript knowledge\nFamiliarity with REST APIs\nAwareness of ERP systems (Odoo knowledge is a plus)\nUnderstanding of AI and ML concepts such as supervised learning and classification\nCuriosity about pharmaceutical and healthcare operations',
  E'Structured learning program with minimum 10 hours/month on an LMS\nQuarterly performance evaluations and peer reviews\nExposure to healthcare AI and ERP integration\nClear KPIs with growth path to senior integration role',
  'Python,Odoo,ERP,AI,REST API,Power BI,Integration',
  'active'
FROM companies c WHERE c.name = 'Eon Dental';

-- Job 5: Backend Python Apprenticeship — Make Work Flow
INSERT INTO job_posts (
  company_id, title, job_type, experience_level, department,
  location, work_mode, salary_display,
  description, responsibilities, requirements, benefits, tags, status
)
SELECT
  c.id,
  'Backend & IoT Apprenticeship',
  'internship', 'entry', 'Engineering',
  'Hamburg, Germany', 'on-site', 'Stipend · €800/month',
  '8-month Apprenticeship Program at Make Work Flow GmbH in Hamburg. You will work on real SaaS products used in production factories across Europe and Asia, building backend APIs, IoT integrations, and mobile frontends. Designed for motivated students who want hands-on startup experience.',
  E'Build backend APIs and data pipelines using Python and FastAPI\nDevelop mobile and desktop apps for real-time production tracking using Flutter\nWork on IoT and AI projects connecting RFID, terminals, and sensors to SaaS platforms\nContribute to live projects supporting factories across Europe and Asia\nCollaborate with a lean, experienced engineering team in a startup environment',
  E'Student in Computer Science, Software Engineering, or a related field\nInterest in Python (FastAPI) and Flutter development\nCurious mindset eager to solve real-world manufacturing challenges\nFamiliarity with REST APIs and basic backend development concepts\nAbility to work on-site at Hamburg office for 8 months',
  E'Work on real SaaS products used in production environments from day one\nLearn from experts in cloud SaaS, IoT, and lean digitalization\nFull startup ownership, responsibility, and impact\nPotential pathway to a full-time developer role after graduation',
  'Python,FastAPI,Flutter,IoT,SaaS,REST API,Backend',
  'active'
FROM companies c WHERE c.name = 'Make Work Flow';

-- Job 6: Business Intelligence Trainee — Make Work Flow
INSERT INTO job_posts (
  company_id, title, job_type, experience_level, department,
  location, work_mode, salary_display,
  description, responsibilities, requirements, benefits, tags, status
)
SELECT
  c.id,
  'Business Intelligence Trainee',
  'internship', 'entry', 'Operations Division',
  'Hamburg, Germany', 'hybrid', 'Stipend · €700/month',
  'Support the Business Intelligence team in collecting, analyzing, and presenting operational data to improve factory efficiency. You will learn how to turn raw manufacturing data into actionable insights and contribute to process improvements across our production clients.',
  E'Assist in gathering and organizing data from different departments\nHelp create basic reports and dashboards using Excel or Power BI\nSupport the team in identifying areas for process improvement\nParticipate in testing and documenting new BI tools or systems\nLearn how to analyze data and present findings to team members\nHelp maintain documentation related to BI tools and processes\nReport data issues or inconsistencies to the team',
  E'Bachelor''s degree in Engineering, IT, or a related field (or currently pursuing)\nInterest in data analysis and business intelligence\nBasic understanding of data analysis concepts\nFamiliarity with Excel; knowledge of Power BI, SQL, or Python is a plus\nAttention to detail and willingness to learn\nGood command of English',
  E'Structured training in data analysis and BI tools\nExposure to real manufacturing and operational data\nHybrid work arrangement at Hamburg HQ\nMentor-guided learning with clear performance milestones',
  'Power BI,Excel,SQL,Python,Data Analysis,Business Intelligence',
  'active'
FROM companies c WHERE c.name = 'Make Work Flow';

-- Job 7: Backend Engineer Intern — TechStream
INSERT INTO job_posts (
  company_id, title, job_type, experience_level, department,
  location, work_mode, salary_display,
  description, responsibilities, requirements, benefits, tags, status
)
SELECT
  c.id,
  'Backend Engineer Intern',
  'internship', 'entry', 'Engineering',
  'Dubai, UAE', 'on-site', 'Stipend · $1,200/month',
  'Join TechStream''s engineering team in Dubai and contribute to building the backend of a streaming platform serving millions of users globally. You will work on scalable microservices, RESTful APIs, and real-time features. An exceptional opportunity to work on cutting-edge immersive media technology.',
  E'Develop and maintain backend services using Node.js, TypeScript, and Nest.js\nDesign and implement RESTful APIs to support mobile and web applications\nBuild scalable microservices for real-time streaming applications\nIntegrate with MongoDB and MySQL for efficient data management\nParticipate in designing backend architecture for high-performance streaming\nOptimize application performance for maximum speed and scalability\nConduct code reviews and maintain high-quality, well-documented code\nWrite unit and integration tests using modern testing frameworks',
  E'Currently enrolled in or recent graduate of Computer Science or related field\nStrong proficiency in JavaScript and TypeScript (ES6+)\nExperience with Node.js for server-side development\nHands-on knowledge of Nest.js framework\nDatabase experience with MongoDB and MySQL\nUnderstanding of RESTful API design principles\nFamiliarity with asynchronous programming (Promises, async/await)\nExperience with Express.js or other Node.js frameworks is a plus',
  E'Work on a global streaming platform serving millions of users\nHands-on experience with high-traffic production systems\nAgile development environment with sprint planning and daily standups\nNetworking opportunities within a fast-growing Dubai tech company\nPotential for full-time offer after internship',
  'Node.js,TypeScript,NestJS,MongoDB,MySQL,REST API,Microservices,Backend',
  'active'
FROM companies c WHERE c.name = 'TechStream';


-- ============================================================
-- SEEKER ACCOUNTS & PROFILES
-- ============================================================
-- Login credentials summary:
--   ahmed.khalil@gmail.com   / ahmed123
--   sara.hassan@gmail.com    / sara123
--   omar.alfarsi@gmail.com   / omar123
--   lina.saleh@gmail.com     / lina123
--   kareem.nasser@gmail.com  / kareem123
-- ============================================================

-- Seeker 1: Ahmed Khalil — CS grad, AI focus
WITH u AS (
  INSERT INTO users (email, password_hash, role, full_name)
  VALUES ('ahmed.khalil@gmail.com', 'ahmed123', 'seeker', 'Ahmed Khalil')
  RETURNING id
),
sp AS (
  INSERT INTO seeker_profiles (user_id, job_title, phone, location, linkedin_url, professional_summary)
  SELECT id,
    'Junior AI Developer',
    '+962 79 123 4567',
    'Amman, Jordan',
    'https://linkedin.com/in/ahmedkhalil',
    'Recent Computer Science graduate from HTU with a strong foundation in Python, machine learning, and data science. Passionate about building AI-driven applications and looking for an opportunity to grow within a forward-thinking tech company.'
  FROM u
  RETURNING id
)
INSERT INTO seeker_skills (seeker_id, skill_name)
SELECT id, unnest(ARRAY['Python', 'TensorFlow', 'PyTorch', 'SQL', 'Git', 'Pandas', 'NumPy', 'Machine Learning'])
FROM sp;

-- Seeker 2: Sara Hassan — CS student, backend focus
WITH u AS (
  INSERT INTO users (email, password_hash, role, full_name)
  VALUES ('sara.hassan@gmail.com', 'sara123', 'seeker', 'Sara Hassan')
  RETURNING id
),
sp AS (
  INSERT INTO seeker_profiles (user_id, job_title, phone, location, linkedin_url, professional_summary)
  SELECT id,
    'Backend Developer Intern',
    '+962 77 234 5678',
    'Amman, Jordan',
    'https://linkedin.com/in/sarahassan',
    'Third-year Software Engineering student at HTU with solid skills in Node.js, Express, and TypeScript. Built several REST APIs for university projects and looking for a backend internship to gain real-world experience in a fast-paced team.'
  FROM u
  RETURNING id
)
INSERT INTO seeker_skills (seeker_id, skill_name)
SELECT id, unnest(ARRAY['Node.js', 'TypeScript', 'Express.js', 'MongoDB', 'REST API', 'Git', 'JavaScript'])
FROM sp;

-- Seeker 3: Omar Al-Farsi — Business/Tech crossover
WITH u AS (
  INSERT INTO users (email, password_hash, role, full_name)
  VALUES ('omar.alfarsi@gmail.com', 'omar123', 'seeker', 'Omar Al-Farsi')
  RETURNING id
),
sp AS (
  INSERT INTO seeker_profiles (user_id, job_title, phone, location, linkedin_url, professional_summary)
  SELECT id,
    'Business Intelligence Analyst',
    '+962 78 345 6789',
    'Amman, Jordan',
    'https://linkedin.com/in/omaralfarsi',
    'IT graduate with a keen interest in data analysis, Power BI dashboards, and business intelligence. Strong analytical mindset and comfortable translating data into clear business insights. Looking for an entry-level BI or analyst role.'
  FROM u
  RETURNING id
)
INSERT INTO seeker_skills (seeker_id, skill_name)
SELECT id, unnest(ARRAY['Power BI', 'Excel', 'SQL', 'Python', 'Data Analysis', 'Tableau'])
FROM sp;

-- Seeker 4: Lina Saleh — AI/CV focus
WITH u AS (
  INSERT INTO users (email, password_hash, role, full_name)
  VALUES ('lina.saleh@gmail.com', 'lina123', 'seeker', 'Lina Saleh')
  RETURNING id
),
sp AS (
  INSERT INTO seeker_profiles (user_id, job_title, phone, location, linkedin_url, professional_summary)
  SELECT id,
    'Computer Vision Researcher',
    '+962 79 456 7890',
    'Amman, Jordan',
    'https://linkedin.com/in/linasaleh',
    'Final-year Computer Science student specializing in computer vision and 3D data processing. Completed a research project on point cloud segmentation using Open3D and PyTorch. Highly motivated to contribute to real-world AI applications in healthcare or manufacturing.'
  FROM u
  RETURNING id
)
INSERT INTO seeker_skills (seeker_id, skill_name)
SELECT id, unnest(ARRAY['Python', 'Open3D', 'PyTorch', 'Computer Vision', '3D Mesh Processing', 'TensorFlow', 'NumPy'])
FROM sp;

-- Seeker 5: Kareem Nasser — Full-stack, business-minded
WITH u AS (
  INSERT INTO users (email, password_hash, role, full_name)
  VALUES ('kareem.nasser@gmail.com', 'kareem123', 'seeker', 'Kareem Nasser')
  RETURNING id
),
sp AS (
  INSERT INTO seeker_profiles (user_id, job_title, phone, location, linkedin_url, professional_summary)
  SELECT id,
    'Full-Stack Developer',
    '+962 77 567 8901',
    'Amman, Jordan',
    'https://linkedin.com/in/kareemnasser',
    'Computer Science graduate with experience in full-stack development and a growing interest in business strategy. Comfortable working with React, Node.js, and SQL databases. Looking for roles that bridge technology and strategic decision-making.'
  FROM u
  RETURNING id
)
INSERT INTO seeker_skills (seeker_id, skill_name)
SELECT id, unnest(ARRAY['React', 'Node.js', 'JavaScript', 'PostgreSQL', 'REST API', 'Git', 'Business Analysis'])
FROM sp;


-- ============================================================
-- APPLICATIONS (all 5 statuses represented)
-- ============================================================
-- Each application links a seeker to a job by looking up
-- their IDs using email and job title subqueries.

-- Ahmed → AI Developer at Zetta: APPROVED ✅
INSERT INTO applications (job_id, seeker_id, status, employer_feedback, status_updated_at)
SELECT
  j.id,
  sp.id,
  'approved',
  'Ahmed stood out with his strong Python skills and clear understanding of ML pipelines. We are delighted to offer him a position. Welcome to the Zetta team!',
  NOW() - INTERVAL '2 days'
FROM job_posts j
JOIN companies c ON j.company_id = c.id
JOIN seeker_profiles sp ON TRUE
JOIN users u ON sp.user_id = u.id
WHERE j.title = 'AI Developer'
  AND c.name = 'Zetta Global'
  AND u.email = 'ahmed.khalil@gmail.com';

-- Ahmed → Computer Vision Engineer at Eon Dental: INTERVIEW 🎤
INSERT INTO applications (job_id, seeker_id, status, employer_feedback, status_updated_at)
SELECT
  j.id,
  sp.id,
  'interview',
  'We were impressed by Ahmed''s background in TensorFlow and PyTorch. We''d like to schedule a technical interview to explore his 3D processing knowledge further.',
  NOW() - INTERVAL '5 days'
FROM job_posts j
JOIN companies c ON j.company_id = c.id
JOIN seeker_profiles sp ON TRUE
JOIN users u ON sp.user_id = u.id
WHERE j.title = 'Computer Vision Engineer — Apprenticeship'
  AND c.name = 'Eon Dental'
  AND u.email = 'ahmed.khalil@gmail.com';

-- Sara → Backend Engineer Intern at TechStream: PENDING ⏳
INSERT INTO applications (job_id, seeker_id, status, status_updated_at)
SELECT
  j.id,
  sp.id,
  'pending',
  NOW() - INTERVAL '1 day'
FROM job_posts j
JOIN companies c ON j.company_id = c.id
JOIN seeker_profiles sp ON TRUE
JOIN users u ON sp.user_id = u.id
WHERE j.title = 'Backend Engineer Intern'
  AND c.name = 'TechStream'
  AND u.email = 'sara.hassan@gmail.com';

-- Sara → AI & Integration Associate at Eon Dental: UNDER REVIEW 🔍
INSERT INTO applications (job_id, seeker_id, status, employer_feedback, status_updated_at)
SELECT
  j.id,
  sp.id,
  'under_review',
  'Sara''s Node.js background and API experience look promising. The team is reviewing her application carefully.',
  NOW() - INTERVAL '3 days'
FROM job_posts j
JOIN companies c ON j.company_id = c.id
JOIN seeker_profiles sp ON TRUE
JOIN users u ON sp.user_id = u.id
WHERE j.title = 'AI & Integration Associate'
  AND c.name = 'Eon Dental'
  AND u.email = 'sara.hassan@gmail.com';

-- Sara → Backend & IoT Apprenticeship at Make Work Flow: REJECTED ❌
INSERT INTO applications (job_id, seeker_id, status, employer_feedback, status_updated_at)
SELECT
  j.id,
  sp.id,
  'rejected',
  'Thank you for applying, Sara. We were looking for candidates with Flutter experience for this specific role. We encourage you to apply again in the future.',
  NOW() - INTERVAL '7 days'
FROM job_posts j
JOIN companies c ON j.company_id = c.id
JOIN seeker_profiles sp ON TRUE
JOIN users u ON sp.user_id = u.id
WHERE j.title = 'Backend & IoT Apprenticeship'
  AND c.name = 'Make Work Flow'
  AND u.email = 'sara.hassan@gmail.com';

-- Omar → Business Intelligence Trainee at Make Work Flow: PENDING ⏳
INSERT INTO applications (job_id, seeker_id, status, status_updated_at)
SELECT
  j.id,
  sp.id,
  'pending',
  NOW() - INTERVAL '2 days'
FROM job_posts j
JOIN companies c ON j.company_id = c.id
JOIN seeker_profiles sp ON TRUE
JOIN users u ON sp.user_id = u.id
WHERE j.title = 'Business Intelligence Trainee'
  AND c.name = 'Make Work Flow'
  AND u.email = 'omar.alfarsi@gmail.com';

-- Omar → Business & Venture Analyst at Zetta: UNDER REVIEW 🔍
INSERT INTO applications (job_id, seeker_id, status, employer_feedback, status_updated_at)
SELECT
  j.id,
  sp.id,
  'under_review',
  'Omar''s finance and IT background aligns well with what we need. Currently reviewing alongside other candidates.',
  NOW() - INTERVAL '4 days'
FROM job_posts j
JOIN companies c ON j.company_id = c.id
JOIN seeker_profiles sp ON TRUE
JOIN users u ON sp.user_id = u.id
WHERE j.title = 'Business & Venture Analyst'
  AND c.name = 'Zetta Global'
  AND u.email = 'omar.alfarsi@gmail.com';

-- Lina → Computer Vision Engineer at Eon Dental: INTERVIEW 🎤
INSERT INTO applications (job_id, seeker_id, status, employer_feedback, status_updated_at)
SELECT
  j.id,
  sp.id,
  'interview',
  'Lina''s Open3D project and her research on point cloud segmentation are exactly what we need. Scheduling a technical interview with Abdullah Al-Zabt.',
  NOW() - INTERVAL '3 days'
FROM job_posts j
JOIN companies c ON j.company_id = c.id
JOIN seeker_profiles sp ON TRUE
JOIN users u ON sp.user_id = u.id
WHERE j.title = 'Computer Vision Engineer — Apprenticeship'
  AND c.name = 'Eon Dental'
  AND u.email = 'lina.saleh@gmail.com';

-- Lina → Backend & IoT Apprenticeship at Make Work Flow: APPROVED ✅
INSERT INTO applications (job_id, seeker_id, status, employer_feedback, status_updated_at)
SELECT
  j.id,
  sp.id,
  'approved',
  'Lina''s Python skills and enthusiasm for real-world manufacturing challenges make her a perfect fit for our Hamburg team. Offer letter sent!',
  NOW() - INTERVAL '6 days'
FROM job_posts j
JOIN companies c ON j.company_id = c.id
JOIN seeker_profiles sp ON TRUE
JOIN users u ON sp.user_id = u.id
WHERE j.title = 'Backend & IoT Apprenticeship'
  AND c.name = 'Make Work Flow'
  AND u.email = 'lina.saleh@gmail.com';

-- Kareem → AI Developer at Zetta: INTERVIEW 🎤
INSERT INTO applications (job_id, seeker_id, status, employer_feedback, status_updated_at)
SELECT
  j.id,
  sp.id,
  'interview',
  'Kareem''s full-stack background and business awareness caught our attention. We''d like to interview him for the AI Developer role.',
  NOW() - INTERVAL '4 days'
FROM job_posts j
JOIN companies c ON j.company_id = c.id
JOIN seeker_profiles sp ON TRUE
JOIN users u ON sp.user_id = u.id
WHERE j.title = 'AI Developer'
  AND c.name = 'Zetta Global'
  AND u.email = 'kareem.nasser@gmail.com';

-- Kareem → Backend Engineer Intern at TechStream: REJECTED ❌
INSERT INTO applications (job_id, seeker_id, status, employer_feedback, status_updated_at)
SELECT
  j.id,
  sp.id,
  'rejected',
  'Thank you for your application, Kareem. We were looking for candidates with NestJS and TypeScript-specific experience. Keep building and apply again!',
  NOW() - INTERVAL '8 days'
FROM job_posts j
JOIN companies c ON j.company_id = c.id
JOIN seeker_profiles sp ON TRUE
JOIN users u ON sp.user_id = u.id
WHERE j.title = 'Backend Engineer Intern'
  AND c.name = 'TechStream'
  AND u.email = 'kareem.nasser@gmail.com';

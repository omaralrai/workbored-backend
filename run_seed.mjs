import pg from 'pg';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import dotenv from 'dotenv';

dotenv.config();

const __dirname = dirname(fileURLToPath(import.meta.url));

// Use the original workbored-db schema (identical to our schema.sql)
const schema = readFileSync(
  'C:/Users/omarb/Desktop/SPRING 2026/Special topics in cs 1/AB/final/workbored-db/01_schema.sql',
  'utf8'
);

// Load the original seed but swap bcrypt placeholders with plain-text passwords
// so our backend (which does plain-text compare) can authenticate
let seed = readFileSync(
  'C:/Users/omarb/Desktop/SPRING 2026/Special topics in cs 1/AB/final/workbored-db/02_seed.sql',
  'utf8'
);

seed = seed
  .replace("'$2b$10$devplaceholder_aramex'",   "'aramex123'")
  .replace("'$2b$10$devplaceholder_mawdoo3'",  "'mawdoo3123'")
  .replace("'$2b$10$devplaceholder_optimiza'", "'optimiza123'")
  .replace("'$2b$10$devplaceholder_estarta'",  "'estarta123'")
  .replace("'$2b$10$devplaceholder_mena'",     "'menatech123'")
  .replace("'$2b$10$devplaceholder_hikma'",    "'hikma123'")
  .replace("'$2b$10$devplaceholder_john'",     "'john123'")
  .replace("'$2b$10$devplaceholder_sarah'",    "'sarah123'")
  .replace("'$2b$10$devplaceholder_omar'",     "'omar123'")
  .replace("'$2b$10$devplaceholder_lina'",     "'lina123'")
  .replace("'$2b$10$devplaceholder_yousef'",   "'yousef123'")
  .replace("'$2b$10$devplaceholder_rana'",     "'rana123'")
  .replace("'$2b$10$devplaceholder_khaled'",   "'khaled123'")
  .replace("'$2b$10$devplaceholder_nour'",     "'nour123'")
  .replace("'$2b$10$devplaceholder_maya'",     "'maya123'");

const client = new pg.Client(process.env.DATABASE_URL);
await client.connect();
console.log('✅ Connected:', process.env.DATABASE_URL);

try {
  // Drop everything and start clean
  console.log('\n🗑️  Dropping all existing tables...');
  await client.query(`
    DROP TABLE IF EXISTS
      applications, seeker_resumes, seeker_skills, seeker_profiles,
      job_posts, companies, users
    CASCADE
  `);

  // Recreate with correct schema
  console.log('📐 Creating tables from schema...');
  await client.query(schema);

  // Insert original seed data with plain-text passwords
  console.log('🌱 Inserting seed data...');
  await client.query(seed);

  // Verify
  const counts = await client.query(`
    SELECT
      (SELECT COUNT(*) FROM users)           AS users,
      (SELECT COUNT(*) FROM companies)       AS companies,
      (SELECT COUNT(*) FROM seeker_profiles) AS seekers,
      (SELECT COUNT(*) FROM job_posts)       AS jobs,
      (SELECT COUNT(*) FROM applications)    AS applications,
      (SELECT COUNT(*) FROM seeker_skills)   AS skills
  `);
  console.log('\n✅ Done! Record counts:');
  console.table(counts.rows[0]);

  const sample = await client.query('SELECT id, email, role FROM users ORDER BY id');
  console.log('\nAll users (IDs are integers ✓):');
  console.table(sample.rows);

  console.log('\n════════════════════════════════════════════');
  console.log(' EMPLOYER LOGINS');
  console.log('════════════════════════════════════════════');
  console.log(' admin@aramex.com      →  aramex123    (Aramex)');
  console.log(' admin@mawdoo3.com     →  mawdoo3123   (Mawdoo3)');
  console.log(' admin@optimiza.com    →  optimiza123  (Optimiza)');
  console.log(' admin@estarta.com     →  estarta123   (Estarta)');
  console.log(' admin@menaitech.com   →  menatech123  (MenaITech)');
  console.log(' admin@hikma.com       →  hikma123     (Hikma)');
  console.log('\n════════════════════════════════════════════');
  console.log(' SEEKER LOGINS');
  console.log('════════════════════════════════════════════');
  console.log(' john.doe@university.edu  →  john123   (has 7 applications — all statuses)');
  console.log(' sarah.khalil@email.com   →  sarah123');
  console.log(' omar.mansour@email.com   →  omar123');
  console.log(' lina.habash@email.com    →  lina123');
  console.log(' yousef.awad@email.com    →  yousef123');
  console.log(' rana.nasser@email.com    →  rana123');
  console.log(' khaled.atiyeh@email.com  →  khaled123');
  console.log(' nour.haddad@email.com    →  nour123');
  console.log(' maya.sabbagh@email.com   →  maya123');
  console.log('════════════════════════════════════════════\n');

} catch (err) {
  console.error('\n❌ Failed:', err.message);
} finally {
  await client.end();
}

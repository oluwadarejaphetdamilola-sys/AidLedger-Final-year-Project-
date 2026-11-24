AIDLEDGER - setup
1. DEMO (zero setup): open index.html through any host. Admin password: admin123. Data stays in that browser.
2. LIVE (real shared system):
   a. supabase.com > New project (free).
   b. SQL Editor > paste schema.sql > Run.
   c. Authentication > Users > Add user (your admin email + password).
   d. SQL Editor: insert into admins values('your-admin-email');
   e. Project Settings > API: copy Project URL + anon key into config.js.
   f. Authentication > URL Configuration: set Site URL to your deployed link. (Google login: enable provider; optional.)
3. DEPLOY: drag this whole folder onto app.netlify.com/drop, or upload to Vercel / Cloudflare Pages / GitHub Pages. No build step.

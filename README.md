"# Chemical-Register-OHTUII" 

Chem-reg chemical register is a web application, where backend runs in Supabase and site is hosted in Github pages.
These instructions will help you set up the website.

Step 0: fork this project to your self, so you have a copy of the repository in your own GitHub.

Step 1: setting up backend.

Create an account in Supabase and start a project. Read Supabase documentation for more detailed information.
From this repository, run "createTables.sql" to create tables needed, "RLS-policies.sql" to create policies for tables and "RPC-functions" to create PostgreSQL API-endpoints, which can be called from frontend Javascript.

Step 2: setting up frontend.
To connect your Supabse backend to your frontend, you need to add your projects API URL and Anon key in src/Js/supabaseClient.js. Don't worry, this is safe, because RLS-policies protect your tables from unauthorized access.

Step 3: hosting in GitHub pages.
You can host your forked repository as a website using GitHub pages (check GitHub pages documentation). 
In GitHub pages you can configure a custom domain.

Step 4: email verification.
In Supabase you can setup an email verification, when users signup to your chem-reg. Users get a verification email with link to verify the signup process.

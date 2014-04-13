# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role
role :app, %w{staging_user@app.example.com}
role :web, %w{staging_user@web.example.com}
role :db,  %w{staging_user@db.example.com}
set :deploy_to, '/www/staging.example.com/current'

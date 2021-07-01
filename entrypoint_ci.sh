#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /proglog/tmp/pids/server.pid

# # production environment's db settings(Is it needed only first time?)
bundle exec rails dbconsole << EOF
SELECT pg_terminate_backend(psa.pid)
  FROM pg_stat_activity AS psa
  WHERE psa.datname = 'Proglog' 
    AND psa.pid <> pg_backend_pid();
EOF

RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:drop

RAILS_ENV=production bundle exec rails db:create

RAILS_ENV=production bundle exec rails db:migrate
# add admin_user
RAILS_ENV=production bundle exec rails db:seed

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /proglog/tmp/pids/server.pid

# # production environment's db settings
RAILS_ENV=production bundle exec rails db:create

RAILS_ENV=production bundle exec rails db:migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

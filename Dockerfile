from migrate/migrate:latest
copy src/migrations /migrations
entrypoint ["migrate"]

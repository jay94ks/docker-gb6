@echo off

docker compose down
rm -rf ./src ./db

docker compose up -d
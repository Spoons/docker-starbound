docker run -p 0.0.0.0:21025:21025/tcp --env-file .env -v "$(pwd)/starbound_data:/steam/starbound" --name starbound-server --restart=always -d starbound:latest

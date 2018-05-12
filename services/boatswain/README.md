### Nexus-Stats Boatswain
<br>
Updates docker services when dockerhub webhooks are triggered on new releases.
Webhooks are sent to `ci.nexus-stats.com/<nexus-dockerhub-token>`/`localhost:5000`.

Requires `nexus-dockerhub-token` as a secret and the merged docker-compose.yml
as a bind mount to `/docker-compose.yml`.

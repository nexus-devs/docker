### Certbot for NexusHub
<br>
This simply uses certbot to autogenerate SSL certs for the NexusHub domains.
The certs will be stored inside the `nexus-certs` volume and requires the
`nexus-cloudflare-token` docker secret to work.

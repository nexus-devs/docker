### NexusHub Redis Server
<br>
Just a redis server. See /config for configuration. Will expose localhost:3000
to nexus-stats.com, localhost:3003 to api.nexus-stats.com and localhost:3030 to
auth.nexus-stats.com.

This image won't work without providing valid certs through the `nexus-cert-public`
and `nexus-cert-private` docker secrets.
FROM 127.0.0.1:5000/nginx

COPY config/nginx/config /etc/nginx/conf/
COPY config/nginx/certs /etc/nginx/conf/certs/

ENTRYPOINT ["nginx", "-g", "daemon off;"]
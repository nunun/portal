FROM nginx
ARG  environment
ADD  html /usr/share/nginx/html/
ADD  conf/nginx.${environment}.conf /etc/nginx/nginx.conf

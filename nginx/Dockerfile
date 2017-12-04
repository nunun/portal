FROM nginx
ARG  environment
ADD  html /usr/share/nginx/html/
ADD  conf/${environment}.conf /etc/nginx/conf.d/default.conf

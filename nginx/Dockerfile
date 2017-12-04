FROM nginx
ARG  build_environment
ADD  html /usr/share/nginx/html/
ADD  conf/${build_environment}.conf /etc/nginx/conf.d/default.conf

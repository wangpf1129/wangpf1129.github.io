FROM nginx

COPY ./public/ /usr/share/nginx/html/

COPY ./nginx.conf /etc/nginx/conf.d/blog.conf

EXPOSE 80
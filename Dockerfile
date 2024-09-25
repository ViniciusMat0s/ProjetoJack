FROM nginx:alpine

RUN adduser -D -g 'www' desafio-jack

COPY ./custom_nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/cache/nginx /var/log/nginx /var/temp/nginx /tmp/nginx && \
    chown -R desafio-jack /var/cache/nginx /var/log/nginx /var/temp/nginx /tmp/nginx

RUN chown -R desafio-jack /usr/share/nginx/html

WORKDIR /usr/share/nginx/html

USER desafio-jack

EXPOSE 8080

CMD [ "nginx", "-g", "daemon off;" ]
FROM webdevops/php-nginx:8.2-alpine

ENV WEB_DOCUMENT_ROOT=/app/public
ENV APP_ENV=production

WORKDIR /app

# Instala dependências do sistema necessárias ao Krayin
RUN apk add --no-cache git zip unzip icu-dev libzip-dev \
    && docker-php-ext-install intl zip

COPY . /app

# Instala dependências PHP
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Instala dependências Node e builda os assets
RUN apk add --no-cache nodejs npm \
    && npm install \
    && npm run build

# Permissões
RUN chown -R application:application /app \
    && chmod -R 775 /app/storage /app/bootstrap/cache

EXPOSE 80

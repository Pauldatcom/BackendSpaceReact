FROM php:8.2-cli

RUN apt-get update \
    && apt-get install -y git unzip libicu-dev libzip-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY composer.json composer.lock ./

RUN echo "===> CECI EST MON DOCKERFILE SYMFONY <==="

RUN composer install --ignore-platform-reqs --no-scripts --no-autoloader

COPY . .

# 💥 Ici on injecte une fausse valeur pour éviter l’erreur lors du cache:clear
ENV DATABASE_URL=mysql://fake:fake@127.0.0.1:3306/fake

RUN composer dump-autoload --no-scripts --optimize \
    && composer run-script post-install-cmd

CMD ["php", "-S", "0.0.0.0:8080", "-t", "public"]

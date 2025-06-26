# Utilise PHP 8.2 officiel avec Composer
FROM php:8.2-cli

# Installe les extensions nécessaires pour Symfony + MySQL
RUN apt-get update \
    && apt-get install -y git unzip libicu-dev libzip-dev \
    && docker-php-ext-install intl pdo pdo_mysql zip

# Installe Composer (officiel)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Définit le dossier de travail
WORKDIR /app

# Copie les fichiers composer d'abord (meilleur cache Docker)
COPY composer.json composer.lock ./

# Installe les dépendances PHP (désactive scripts pour la première passe)
RUN composer install --ignore-platform-reqs --no-scripts --no-autoloader

# Copie tout le reste du code
COPY . .

# (Re)génère l'autoload et exécute les scripts (optionnel mais conseillé)
RUN composer dump-autoload --no-scripts --no-dev --optimize \
    && composer run-script post-install-cmd

# Commande de démarrage (adapte si tu veux utiliser le serveur Apache ou FPM)
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]

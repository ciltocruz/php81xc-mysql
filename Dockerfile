FROM php:8.1.12-cli

# OpCache settings
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0"
ENV XDEBUG_MODE="debug,coverage"

# Install system dependencies
RUN apt-get update -y && apt-get install -y \
    git \
    curl \
    libmcrypt-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libmariadb-dev-compat \
    libmariadb-dev \
    default-mysql-client \ 
    mariadb-client \ 
    mariadb-server \
    zip \
    unzip \
    libpq-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup PHPXDebug
RUN pecl install xdebug-3.1.6 mcrypt-1.0.5

# Install PHP extensions
RUN docker-php-ext-install intl mysqli pdo pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd opcache zip \
    && docker-php-ext-enable mysqli pdo pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd xdebug mcrypt

# Get latest Composer
COPY --from=composer:1.10.26 /usr/bin/composer /usr/bin/composer

# Add custom ini files
COPY config/10-shorttag.ini \
        config/20-memory-limit.ini \
        config/30-opcache.ini \
        config/40-xdebug.ini \      
        $PHP_INI_DIR/conf.d/

# Create folder
RUN mkdir -p /data

# Trimmed from Laravel Sail's PHP 8.5 runtime (vendor/laravel/sail/runtimes/8.5).
# Only what Gym Capo uses, split into cached layers so a flaky network only
# repeats the step that failed. Add packages back as phases need them
# (e.g. ffmpeg for video analysis in Phase 6).
FROM ubuntu:24.04

LABEL maintainer="Gym Capo"

ARG WWWGROUP
ARG MYSQL_CLIENT="mysql-client"
ARG PHP_EXTENSIONS=""

WORKDIR /var/www/html

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV LANG=C.UTF-8
ENV SUPERVISOR_PHP_COMMAND="/usr/bin/php -d variables_order=EGPCS /var/www/html/artisan serve --host=0.0.0.0 --port=80"
ENV SUPERVISOR_PHP_USER="sail"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Be patient with slow or flaky mirrors.
RUN echo 'Acquire::Retries "10";' > /etc/apt/apt.conf.d/99custom && \
    echo 'Acquire::http::Timeout "60";' >> /etc/apt/apt.conf.d/99custom && \
    echo 'Acquire::https::Timeout "60";' >> /etc/apt/apt.conf.d/99custom && \
    echo 'Acquire::http::Pipeline-Depth 0;' >> /etc/apt/apt.conf.d/99custom && \
    echo 'APT::Install-Recommends "false";' >> /etc/apt/apt.conf.d/99custom

# 1) Base OS tools.
RUN apt-get update \
    && apt-get install -y ca-certificates curl gosu git zip unzip supervisor libcap2-bin \
    && rm -rf /var/lib/apt/lists/*

# 2) PHP 8.5 and the extensions the app uses.
RUN curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb \
    && dpkg -i /tmp/debsuryorg-archive-keyring.deb \
    && echo "deb [signed-by=/usr/share/keyrings/debsuryorg-archive-keyring.gpg] https://packages.sury.org/php/ noble main" > /etc/apt/sources.list.d/php.list \
    && apt-get update \
    && apt-get install -y \
        php8.5-cli \
        php8.5-mysql \
        php8.5-redis \
        php8.5-mbstring \
        php8.5-xml \
        php8.5-zip \
        php8.5-bcmath \
        php8.5-curl \
        php8.5-intl \
        php8.5-gd \
        php8.5-readline \
        php8.5-pcov \
    && rm -rf /var/lib/apt/lists/* /tmp/*

# 3) Composer and the MySQL client (for `sail mysql`).
RUN curl -sLS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer \
    && apt-get update \
    && apt-get install -y $MYSQL_CLIENT \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN if [ -n "$PHP_EXTENSIONS" ]; then \
    apt-get update \
    && apt-get install -y $(for ext in $PHP_EXTENSIONS; do echo "php8.5-$ext"; done) \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
fi

RUN setcap "cap_net_bind_service=+ep" /usr/bin/php8.5

RUN userdel -r ubuntu
RUN groupadd --force -g $WWWGROUP sail
RUN useradd -ms /bin/bash --no-user-group -g $WWWGROUP -u 1337 sail
RUN git config --global --add safe.directory /var/www/html

COPY start-container /usr/local/bin/start-container
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY php.ini /etc/php/8.5/cli/conf.d/99-sail.ini
RUN chmod +x /usr/local/bin/start-container

EXPOSE 80/tcp

ENTRYPOINT ["start-container"]

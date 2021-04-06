FROM debian:buster

# Install apache, PHP, and supplimentary programs. openssh-server, curl, and lynx-cur are for debugging the container.
ENV DEBIAN_FRONTEND=noninteractive
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends wget apache2 unzip msmtp msmtp-mta mailutils tzdata nano curl watchdog \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends lsb-release apt-transport-https ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.4.list

# hadolint ignore=DL3008
RUN apt-get update && apt-get -y --no-install-recommends install php7.4 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# hadolint ignore=DL3008
RUN apt-get update && apt-get -y --no-install-recommends install php7.4-cli php7.4-fpm php7.4-json php7.4-pdo php7.4-ldap php7.4-mysql php7.4-zip php7.4-gd  php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath php7.4-json \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends libapache2-mod-php7.4 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends nfs-common cifs-utils \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash redcap
RUN usermod -g www-data redcap

COPY code /code

RUN mkdir /var/www/site/ && \
    mkdir /etc/mail && \
    mv /code/redcap/* /var/www/site/ && \
    mv /code/database.php /var/www/site/database.php && \
    mv /code/apache-config.conf /etc/apache2/sites-enabled/000-default.conf && \
    mv /code/php.ini /etc/php/7.4/apache2/php.ini && \
    mv /code/envvars /etc/apache2/envvars && \
    mv /code/apache2.conf /etc/apache2/apache2.conf && \
    mv /code/sendmail.cf /etc/mail/sendmail.cf && \
    mv /code/msmtprc /etc/msmtprc && \
    mv /code/ldap_config.php /var/www/site/webtools2/ldap/ldap_config.php  && \
    mv /code/TERENA_b64.crt /usr/local/share/ca-certificates/TERENA_b64.crt

RUN update-ca-certificates
RUN chown -R redcap:www-data /var/www/site
RUN ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime

# Pour la persistence des documents
RUN mkdir /remoteedocs

# Expose apache.
EXPOSE 80

# By default start up apache in the foreground, override with /bin/bash for interative.
CMD ["/usr/sbin/apache2ctl","-D","FOREGROUND"]

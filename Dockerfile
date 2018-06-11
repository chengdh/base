FROM debian:jessie
MAINTAINER Odoo S.A. <info@odoo.com>

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            build-essential \
            ca-certificates \
            curl \
            node-less \
            python-pip \
            python-dev \
            python-renderpm \
            python-support \
            python-watchdog \
            libpq-dev \
            libxml2-dev \
            libxslt1-dev \
            libjpeg-dev \
            libsasl2-dev \
            libldap2-dev \
            libssl-dev \
        # && curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb \
        # && echo '40e8b906de658a2221b15e4e8cd82565a47d7ee8 wkhtmltox.deb' | sha1sum -c - \
        # && dpkg --force-depends -i wkhtmltox.deb \
        # && apt-get -y install -f --no-install-recommends \
        # && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        # && rm -rf /var/lib/apt/lists/* wkhtmltox.deb \
        && pip install psycogreen==1.0


RUN mkdir -p gooderp

WORKDIR gooderp

# install gooderp
COPY ./entrypoint.sh ./
COPY ./odoo.conf ./


COPY ./odoo-bin ./
COPY ./requirements.txt ./
COPY ./odoo ./
RUN pip install -r requirements.txt

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
RUN mkdir -p /mnt/extra-addons
VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV ODOO_RC ./odoo.conf


ENTRYPOINT ["./entrypoint.sh"]
CMD ["odoo-bin"]

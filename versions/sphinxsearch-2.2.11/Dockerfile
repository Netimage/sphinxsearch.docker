# Sphinxsearch
#
# @version 	latest (2.2.11)
# @author 	leodido <leodidonato@gmail.com> (@leodido)
FROM debian:bookworm-slim
#MAINTAINER Leonardo Di Donato <leodidonato@gmail.com> @leodido

# runtime dependencies
RUN apt-get update && apt-get install -y unixodbc-dev libexpat-dev python3-pip python3-venv

# place sphinxsearch installation in place
ADD /sphinxsearch.tar.gz /usr/local/
ADD dicts /var/diz/sphinx

RUN groupadd -g 1000 sphinx && useradd -u 1000 -g 1000 -M -d /rotator -s /usr/sbin/nologin sphinx

# Directory to place sphinx.conf in. ###DB_*### variables will be replaced by setup_and_run.sh before use.
RUN mkdir -p /app/frontend/var /var/idx/sphinx /var/log/sphinx /var/lib/sphinx /var/run/sphinx \
    && touch /usr/local/etc/sphinx.conf \
    && chown -R 1000:1000 /app/frontend/var /var/idx/sphinx /var/log/sphinx /var/lib/sphinx /var/run/sphinx /usr/local/etc/sphinx.conf

# Our main script:
ADD setup_and_run.sh  /

ENV DB_HOST=MustBeProvided
ENV DB_NAME=MustBeProvided
ENV DB_USER=MustBeProvided
# DB_PASSWORD and SPHINX_VERIFY must be provided at runtime (e.g. from a Kubernetes secret).

# Install the sphinxrotator app
RUN mkdir /rotator
ADD app.py /rotator/
RUN cd /rotator/ && python3 -m venv .venv && . .venv/bin/activate && pip install Flask

# expose ports
EXPOSE 9312 9306 9001

# expose directories
VOLUME ["/app/frontend/var", "/var/idx/sphinx", "/var/log/sphinx", "/var/lib/sphinx", "/var/run/sphinx", "/var/diz/sphinx"]

USER 1000:1000

ENTRYPOINT ["/setup_and_run.sh"]

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

# Directory to place sphinx.conf in. ###DB_*### variables will be replaced by setup_and_run.sh before use.
RUN mkdir -p /app/frontend/var

# Our main script:
ADD setup_and_run.sh  /

ENV DB_HOST=MustBeProvided
ENV DB_NAME=MustBeProvided
ENV DB_USER=MustBeProvided
ENV DB_PASSWORD=MustBeProvided
ENV SPHINX_VERIFY=MustBeProvided

# Install the sphinxrotator app
RUN mkdir /rotator
ADD app.py /rotator/
RUN cd /rotator/ && python3 -m venv .venv && . .venv/bin/activate && pip install Flask

# expose ports
EXPOSE 9312 9306 9001

# expose directories
VOLUME ["/app/frontend/var", "/var/idx/sphinx", "/var/log/sphinx", "/var/lib/sphinx", "/var/run/sphinx", "/var/diz/sphinx"]

ENTRYPOINT ["/setup_and_run.sh"]
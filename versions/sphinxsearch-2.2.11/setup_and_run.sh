#!/bin/bash

# Exit on errors and unset variables
set -o errexit
set -o nounset
set -o pipefail

SRC_FILE=/app/frontend/var/sphinx.conf

# Wait for config file to exist and be more than 0 bytes
if [ ! -s $SRC_FILE ]; then
    echo "Waiting for file $SRC_FILE..."
    while [ ! -s $SRC_FILE ]; do
        sleep 3
    done
    echo "File $SRC_FILE now exists."
fi

echo "Substituting DB-info into config file..."
cat $SRC_FILE | sed \
    -e s/###DB_HOST###/$DB_HOST/ \
    -e s/###DB_USER###/$DB_USER/ \
    -e s/###DB_PASSWORD###/$DB_PASSWORD/ \
    -e s/###DB_NAME###/$DB_NAME/ \
    > /usr/local/etc/sphinx.conf


echo "Running indexer..."
indexer --all

echo "Starting sphinxrotator app on port 9001..."
cd /rotator
. .venv/bin/activate
flask --app app run --host=0.0.0.0 --port=9001 &

echo "Starting searchd..."
cd /
searchd --nodetach

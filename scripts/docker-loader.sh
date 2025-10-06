#!/bin/bash
################################################################################
# Task:         Load Backup into Docker and Postgres
# Description:  This script primes the connection to the local OSF database
#               using Docker and Postgres.
################################################################################

# Parse arguments
DIR_BACKUP=${1-"${HOME}/osfdata/pg"}
DIR_CODEBASE=${2-"${HOME}/osf.io"}

# Set constants
INITIAL_WAIT=300  #5 minutes
INCREMENT_WAIT=60 #1 minute
MAX_WAIT=1800 #30 minutes


CURRENT_DIR=$(pwd)

# Activate environment
cd $DIR_CODEBASE
pyenv activate osf  #TODO: generalize this
sleep 2

# Setup Docker and Postgres
echo "Starting Docker..."
open -a Docker
sleep 10

echo "Starting Postgres container..."
docker compose up -d postgres


# Initial waiting period
echo "Waiting for Postgres to start..."
echo "Begin initial waiting period of $(($INITIAL_WAIT/60)) minutes..."
sleep $INITIAL_WAIT
total_wait=$INITIAL_WAIT

echo "Checking if Postgres is ready..."
result=$(docker compose logs | tail -n 10 | grep "database system is ready to accept")

# Loop until Postgres is ready or timeout
while [ -z "$result" ]; do
    echo "Waiting another $INCREMENT_WAIT seconds..."
    sleep $INCREMENT_WAIT
    result=$(docker compose logs | tail -n 5 | grep "database system is ready to accept")
    total_wait=$((total_wait + INCREMENT_WAIT))
    if ([ $total_wait -ge $MAX_WAIT ]); then
        echo "Postgres did not start within $(($MAX_WAIT/60)) minutes."
        cd $CURRENT_DIR
        exit 1
    fi
done

cd $CURRENT_DIR
echo "Postgres is ready!"
exit 0
#!/bin/bash

# Parameters
NTH_RECENT=${1:-1}
DATADIR=${2:-"${HOME}/osfdata"}
CODEDIR=${3:-"${HOME}/osf.io"}

PGDIR=${DATADIR}/pg  # Postgres location (defaults to ./pg subdirectory)


# Set which switches to run in pipeline
RUN_GET=1
RUN_PREP=1
RUN_LOAD=1


# PIPELINE ---------------------------------------------------------------------
if [ $RUN_GET == 1 ]; then
	echo "Downloading and extracting backup..."
    ./scripts/get-backup.sh ${NTH_RECENT} ${DATADIR}
fi

if [ $RUN_PREP == 1 ]; then
    echo "Preparing backup for local use..."
    ./scripts/prep-backup.sh $PGDIR ${CODEDIR}
fi

if [ $RUN_LOAD == 1 ]; then
    echo "Loading data into database..."
    ./scripts/docker-loader.sh $$PGDIR ${CODEDIR}
fi
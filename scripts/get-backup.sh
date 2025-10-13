#!/bin/bash
################################################################################
# Task:         Fetch OSF Backup from GCS
# Description:  This script downloads and extracts the latest backup of the OSF
#               database from Google Cloud Storage.  Previous backups will be
#               deleted to save space.
################################################################################

# Parse arguments
LAG=${1:-1}                      #number of most recent backups to download
DATADIR=${2:-"${HOME}/osfdata"}  #data directory


# Manage Directories -----------------------------------------------------------
# Cleanup old backups
if [ -d $DATADIR/pg ]; then
    rm -rf $DATADIR/pg
fi

if [ -d $DATADIR/compressed ]; then
    #keep the most recent 2 compressed backups
    ls $DATADIR/compressed | sort -r | tail -n +3 | \
        xargs -I {} rm $DATADIR/compressed/{}
fi

# Create directories if needed
mkdir -p $DATADIR/compressed
mkdir -p $DATADIR/pg


# Download and extract backup --------------------------------------------------
backup_uri=$( \
    gcloud storage ls 'gs://cos-data-analytics-restricted/*tar.gz' | \
    tail -$LAG | head -n 1)  #the `n`th most recent backup from $LAG
filename=$(basename $backup_uri)

if [ ! -f $DATADIR/compressed/$filename ]; then
    gcloud storage cp $backup_uri $DATADIR/compressed
fi

echo "Extracting $filename..."
sleep 10
tar -xzf $DATADIR/compressed/$filename -C $DATADIR/pg
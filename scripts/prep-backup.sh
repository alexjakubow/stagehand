#!/bin/bash
################################################################################
# Task:         Prepare OSF Backup for Local Use
# Description:  This script clones a fresh copy of the OSF codebase from GitHub
#               and modifies the codebase and database files for local use.
################################################################################

# Parse arguments
PGDIR=${1:-"${HOME}/osfdata/pg"}  # Postgres location
CODEDIR=${2:-"${HOME}/osf.io"}    # Codebase location
REPLACEMENTS=${3:-"pgfiles"}      # Location of replacement files

# Define constants
URL=https://github.com/CenterForOpenScience/osf.io.git


# MODIFY DATABASE FILES --------------------------------------------------------
# Remove files
rm -f $PGDIR/postgresql.auto.conf

# Replace files
cp $REPLACEMENTS/pg_hba.conf $PGDIR/pg_hba.conf
cp $REPLACEMENTS/postgresql.conf $PGDIR/postgresql.conf

# Replace missing files if necessary
if [ ! -f $PGDIR/pg_ident.conf ]; then
    cp $REPLACEMENTS/pg_ident.conf $PGDIR/pg_ident.conf
fi

if [ ! -d $PGDIR/pg_commit ]; then
    mkdir $PGDIR/pg_commit
fi


# MODIFY CODEBASE --------------------------------------------------------------
# Clone/Update osf.io
if [ ! -d $CODEDIR ]; then
    git clone $URL $CODEDIR
else
    git -C $CODEDIR pull
fi

# Modify files
cp $CODEDIR/website/settings/local-dist.py $CODEDIR/website/settings/local.py
cp $CODEDIR/api/base/settings/local-dist.py $CODEDIR/api/base/settings/local.py

# Apply patch
fullpath=$(pwd)
git -C $CODEDIR apply $fullpath/$REPLACEMENTS/encrypt-patch.diff
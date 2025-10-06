# stagehand

The `stagehand` pipeline helps automate the weekly drudgery of downloading, extracting, and modifying the latest backup of the OSF database for local use...

## Pre-requisites

1. The `gcloud` command line tool installed and configured for your COS Google account.
2. A properly staged data science environment for local use (see this [confluence page](https://openscience.atlassian.net/wiki/spaces/DS1/pages/3114762241/Create+data+science+environment) for details)

## Usage

### Basic Usage

`./run.sh` will run the entire pipeline.  Please verify the default parameters defined at the top of the script are correct before running.  Specifically:

- `NTH_RECENT`: Which backup to download and extract, defined as the `n`th most recent backup.  The default is to download the latest backup (`NTH_RECENT = 1`).
- `DATADIR`: The top-level directory for all data and backups.  The default is to use the `osfdata` directory in your home directory (`DATADIR = "${HOME}/osfdata"`).
- `CODEDIR`: The top-level directory for the codebase.  The default is to use the `osf.io` directory in your home directory (`CODEDIR = "${HOME}/osf.io"`).

By default, `./run.sh` will download and extract the backup, prepare the database for local use, and load the data into Docker.  Each phase is governed by a boolean flag, which can be set to `0` to skip that phase.

### Customization
To simplify execution of the pipeline, you can set an alias in your `~/.zshrc` file:

```bash
alias stagehand="cd <path/to/stagehand> && ./run.sh <NTH_RECENT> <DATADIR> <CODEDIR>"
```

This will allow you to execute the pipeline from any directory by simply typing `stagehand` and passing in the arguments.
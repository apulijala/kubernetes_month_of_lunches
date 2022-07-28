#!/bin/bash -eux 

BUCKET="s3://jenkinslogsinforma/logs/"
DIRECTORY="/opt/backup/"

# check if directory /opt/backup exists or create one. 
echo "Creating directory $DIRECTORY"
[ -d "$DIRECTORY" ] &&  echo directory $DIRECTORY exists || mkdir -pv $DIRECTORY 

# Move the directory to /opt/backup here. 
echo "Clearing the $DIRECTORY"

find /opt/reports/ -maxdepth  1  \( -name 100  -o -name 1000 \) -mtime +90   -exec mv '{}' "$DIRECTORY" \;

# Tar all the directories after moving to /opt/backup.  create the tar file with date and time stamp. 
echo "Creating the tar directory $TAR_DIR"
TAR_DIR="/tmp/jenkins_$(date +%F).tar.gz"
cd "$DIRECTORY" && tar czvf "$TAR_DIR" . > /dev/null
ls -l "$TAR_DIR"

# Copy the tar file to the s3 bucket. 
echo "Copying the $TAR_DIR  to $BUCKET"
/usr/local/aws-cli/v2/2.7.18/dist/aws s3  cp "$TAR_DIR" "$BUCKET"
echo "Removing directory $TAR_DIR"
rm -f "$TAR_DIR"

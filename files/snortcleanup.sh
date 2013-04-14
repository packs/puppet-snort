#!/bin/bash
# Clean up unified2 logs older than current day.

DIR=/var/log/snort
AGE=0

/usr/bin/find ${DIR} -type f -iname snort_unified.log\* -mtime +${AGE} -exec rm {} \;

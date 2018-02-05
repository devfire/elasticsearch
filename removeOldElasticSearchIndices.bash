#!/usr/bin/env bash
#
#################################Description###############################################
#This script deletes an old ElasticSearch index.
#It computes the current date - N days. The index format must be YYYY.MM.DD
###########################################################################################
#
#exit in case a command fails
set -o errexit

#make sure all variables are declared ahead of time
set -o nounset

#this constructs the proper YYYY.MM.DD date format,
#minus N days.
#dateToDelete=`date +%Y.%m.%d -d "15 days ago"`
dateToDelete=`date +%Y%m%d -d "5 days ago"`

#the ElasticSearch URL endpoint
esURL="http://es-nonprod.net"

#make sure curl is present
#Use command -v to make the check POSIX compliant;
#since "which" return codes are not guaranteed!
command -v curl >/dev/null || { echo "ERROR: curl is not in the $PATH. Exiting."; exit 1; }


#this loops through all indices matching the date specified and grabs the 3rd column,
#which is the index name. -s makes curl "silent" suppressing the progress bar.
#the grep regexp is to match all lines that follow this pattern: word-YYYY.MM.DD
for index in `curl -s "$esURL"/_cat/indices | awk '{print $3}' | grep -E '^\w+-[0-9]{4}.[0-9]{2}.[0-9]{2}'`
do
        #this is to strip . from the YYYY.MM.DD format, for numbers comparison
        indexDateToDelete=$(echo $index | awk -F\- '{print $2}' | tr -d ".")

        #this compares the cutoff date with the index date
        #if the index date is LESS THAN the cutoff date, delete it
        if [ $indexDateToDelete -lt $dateToDelete ];
        then
                curl -XDELETE "$esURL"/"$index" || { echo "ERROR: $index is not found. Exiting."; exit 1; }
        fi
done

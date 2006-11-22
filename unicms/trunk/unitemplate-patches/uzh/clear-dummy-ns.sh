#! /bin/sh

#------
#
# filenamme: clear-dummy-ns.sh
#
#    22.11.2006(trd): script for clearing dummy namespace when installing the xsl files of the uzh publication 
#
#------

#------
# you have to set the execute permission for this script!
# 
# set path to your uzh publication (that is being patched) accordingly
#------

find /path/to/lenya-src/build/lenya/webapp/lenya/pubs/uzh/xslt/doctypes -type f -name '*.xsl' -print | while read i
do
  sed 's/xmlns\:xsl=\"http\:\/\/www\.unizh\.ch\/dummy-ns\/\"//g' $i > $i.tmp && mv $i.tmp $i
done

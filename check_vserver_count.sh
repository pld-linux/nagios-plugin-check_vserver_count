#!/bin/sh
shouldrun=$(grep . /etc/vservers/*/apps/init/mark |wc -l)
running=$(awk '/Active/{ print $2 }' /proc/virtual/status)

if [ $shouldrun = $running ]
then
	echo "OK: running $running out of $shouldrun vservers"
	exit 0
else
	echo "CRITICAL: running $running out of $shouldrun vservers"
	exit 2
fi

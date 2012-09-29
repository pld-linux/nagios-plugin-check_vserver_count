#!/bin/sh

[ -n "$UTIL_VSERVER_VARS" ] || {
	UTIL_VSERVER_VARS=/usr/lib64/util-vserver/util-vserver-vars
	[ -e "$UTIL_VSERVER_VARS" ] || UTIL_VSERVER_VARS=/usr/lib/util-vserver/util-vserver-vars
}
if [ ! -e "$UTIL_VSERVER_VARS" ] ; then
	echo "Can not find util-vserver installation (the file '$UTIL_VSERVER_VARS' would be expected); aborting..." >&2
	exit 1
fi
. "$UTIL_VSERVER_VARS"

shouldrun=$(grep . $__CONFDIR/*/apps/init/mark | wc -l)
running=$(awk '/Active/{ print $2 }' /proc/virtual/status)

if [ $shouldrun = $running ]; then
	echo "OK: running $running out of $shouldrun vservers"
	exit 0
else
	echo "CRITICAL: running $running out of $shouldrun vservers"
	exit 2
fi

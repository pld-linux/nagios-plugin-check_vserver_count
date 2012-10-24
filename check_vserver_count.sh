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

# check files so that we are able to understand permission errors
errors=""
shouldrun=0
for markfile in $(ls -1 $__CONFDIR/*/apps/init/mark 2>/dev/null); do
	vs=${markfile%/apps/init/mark}
	vs=${vs#$__CONFDIR/}
	marked=$(grep . $markfile)
	if [ $? != 0 -a $? != 1 ]; then
		errors="$errors $vs"
	else
		shouldrun=$((shouldrun + 1))
	fi
	marks="$marks $markfile"
done
errors=${errors# }

running=$(awk '/Active/{ print $2 }' /proc/virtual/status)

rc=0
status=OK

if [ $running -lt $shouldrun ]; then
	rc=2
	status="CRITICAL"
elif [ $running != $shouldrun ]; then
	rc=1
	status="WARNING"
fi

echo "$status: running $running out of $shouldrun vservers.${errors:+ (Error checking vservers: $errors)}"
exit $rc

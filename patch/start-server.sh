#!/bin/bash
#
###############################################################################
#
# Edit memory option -Xmx in ProjectZomboid64.json for 64bit servers (common)
#
############

INSTDIR="`dirname $0`" ; cd "${INSTDIR}" ; INSTDIR="`pwd`"

if "${INSTDIR}/jre64/bin/java" -version > /dev/null 2>&1; then
	export PATH="${INSTDIR}/jre64/bin:$PATH"
	export LD_LIBRARY_PATH="${INSTDIR}/linux64:${INSTDIR}:${INSTDIR}/jre64/lib/amd64:${LD_LIBRARY_PATH}"
	JSIG="libjsig.so"
	LD_PRELOAD="${LD_PRELOAD}:${JSIG}" ./ProjectZomboid64 -nosteam -cachedir=/data -servername pz-server "$@"
else
	echo "Only 64bit is supported"
fi
exit 0

#
# EOF
#
###############################################################################


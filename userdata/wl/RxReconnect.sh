################################################################################
#                                                                  Date:10/2012
#                                 PRESENTATION
#
#         Copyright 2012 TCL Communication Technology Holdings Limited.
#
# This material is company confidential, cannot be reproduced in any form
# without the written permission of TCL Communication Technology Holdings
# Limited.
#
# -----------------------------------------------------------------------------
#  Author :  Chen Ji
#  Email  :  Ji.Chen@tcl-mobile.com
#  Role   :
#  Reference documents : refer bugID200662/161302
# -----------------------------------------------------------------------------
#  Comments :
#  File     : development/apps/WLANTestMode/wl
#  Labels   :
# -----------------------------------------------------------------------------
# =============================================================================
#      Modifications on Features list / Changes Request / Problems Report
# -----------------------------------------------------------------------------
#    date   |        author        |         Key          |      comment
# ----------|----------------------|----------------------|--------------------
# 10/22/2012|Chen Ji               |bugID321787           |scripts are excuted
#           |                      |                      |for WLANTest
# ----------|----------------------|----------------------|--------------------
################################################################################

echo "#*************************************************"
echo "# Script usage:"
echo "# $0 <channel #> <bg_rate> <Tx power>"
echo "#"
echo "# Example: test TX with channel 1, 54Mbps, 5db"
echo "# $0 1 54 5"
echo "#*************************************************"

LOG_TAG="qcom-wifi"
LOG_NAME="${0}:"
logi ()
{
  /system/bin/log -t $LOG_TAG -p i "$LOG_NAME $@"
}
logi "RxReconnect.sh"
logi "$1 $2"
/data/wl/wlarm disassoc
sleep 2
/data/wl/wlarm scansuppress 0
sleep 2
/data/wl/wlarm scan
sleep 2
/data/wl/wlarm scanresults
sleep 2
/data/wl/wlarm join $1
sleep 2
ifconfig wlan0 $2 up
sleep 2
/data/wl/wlarm scansuppress 1
sleep 2
/data/wl/wlarm PM 0
sleep 2
/data/wl/wlarm assoc

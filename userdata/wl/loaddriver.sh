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
# 11/30/2012|Chen Ji               |bugID329061           |scripts are excuted
#           |                      |                      |for WLANTest
# ----------|----------------------|----------------------|--------------------
# ----------|----------------------|----------------------|--------------------
# 23/12/1015| Liu Ruili            |bugID 1209820         |Upgrade WLANTestMode
#           |                      |                      |APK
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


echo 5 > /sys/module/wlan/parameters/con_mode
sleep 1
ftmdaemon -n -dd
logi "Script end."

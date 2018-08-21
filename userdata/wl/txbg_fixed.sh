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
logi "enter txbg.sh"
logi "$1 $2 $3"
logi "ifconfig wlan0 up"
echo "ifconfig wlan0 up"
ifconfig wlan0 up
sleep 1
logi "#start TX99 test mode with channel set to $1, data rate set to $2, and --tgtpwr"
echo "#start TX99 test mode with channel set to $1, data rate set to $2, and --tgtpwr"
iwpriv wlan0 set_channel $1
iwpriv wlan0 set_txrate $2
iwpriv wlan0 set_txpower $3
iwpriv wlan0 tx 1
logi "Script end."
echo "Script end."

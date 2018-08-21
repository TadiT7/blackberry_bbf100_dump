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
echo "# $0 <Channel> <Digital Gain> and <RF Gain>"
echo "#"
echo "# Example: test TX with channel 1 digital gain 20,rf gain 23"
echo "# $0 1 20 23"
echo "#*************************************************"

LOG_TAG="qcom-wifi"
LOG_NAME="${0}:"

logi ()
{
  /system/bin/log -t $LOG_TAG -p i "$LOG_NAME $@"
}
logi "enter wavegenerator.sh"
logi "$1 $2 $3"
sleep 1
logi "#start WLAN wave generator test mode with channel $1, digital gain $2, and RF gain $3"
echo "#start WLAN wave generator test mode with channel $1, digital gain $2, and RF gain $3"
myftm -M 0 -a 1 -f $1 -t 1
logi "Script end."
echo "Script end."

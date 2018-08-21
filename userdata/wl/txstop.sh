#!/system/bin/sh
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
echo "# tx"
echo "#"
echo "# Example: to stop tx"
echo "# tx"
echo "#*************************************************"

echo "#stop TX mode "
echo "./athtestcmd -i wlan0 --tx off "

LOG_TAG="qcom-wifi"
LOG_NAME="${0}:"

logi ()
{
  /system/bin/log -t $LOG_TAG -p i "$LOG_NAME $@"
}

logi "enter txstop.sh"
#iwpriv wlan0 ftm 0
echo "Script end."

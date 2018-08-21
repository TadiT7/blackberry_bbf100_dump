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
echo "# $0 <channel #> <msc index>"
echo "#"
echo "# Example: test RX with channel 1, mcs 7"
echo "# $0 1 7"
echo "# Note: mcs value range=0~7"
echo "# Note: Please have an adhoc(name:test) network ready."
echo "#*************************************************"
LOG_TAG="qcom-wifi"
LOG_NAME="${0}:"

logi ()
{
  /system/bin/log -t $LOG_TAG -p i "$LOG_NAME $@"
}
logi "enter rxn.sh"
  channel=$(cat /data/wl/channel)
echo $channel
  rate=$(cat /data/wl/rate)
echo $rate
  power=$(cat /data/wl/power)
echo $power
logi "$channel $rate $power"
logi "$1 $2 "
logi "./wlarm disassoc"
echo "./wlarm disassoc"
./wlarm disassoc
sleep 1
logi "./wlarm mpc 0"
echo "./wlarm mpc 0"
./wlarm mpc 0
logi "./wlarm PM 0"
echo "./wlarm PM 0"
./wlarm PM 0
logi "./wlarm down"
echo "./wlarm down"
./wlarm down
sleep 1
logi "./wlarm up"
echo "./wlarm up"
./wlarm up
sleep 1
logi "./wlarm chanspec -c $1 -b 2 -w 20 -s 0"
echo "./wlarm chanspec -c $1 -b 2 -w 20 -s 0"
./wlarm chanspec -c $1 -b 2 -w 20 -s 0
sleep 1
logi "./wlarm bi 50000"
echo "./wlarm bi 50000"
./wlarm bi 50000
sleep 1
logi "Connect to wlan name: test with adhoc mode"
echo "Connect to wlan name: test with adhoc mode"
logi "./wlarm join test imode adhoc"
echo "./wlarm join test imode adhoc"
./wlarm join test imode adhoc
sleep 2
logi "./wlarm nrate -m $2 "
echo "./wlarm nrate -m $2 "
./wlarm nrate -m $2
sleep 1
logi "./wlarm counters"
echo "./wlarm counters"
./wlarm counters
logi "Script end."
echo "Script end."

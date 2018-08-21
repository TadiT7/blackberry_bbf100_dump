#!/system/bin/sh
# Copyright (c) 2012-2016, The Linux Foundation. All rights reserved.
# Copyright (c) 2016, BlackBerry Limited
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
chown -h root.system /sys/devices/platform/msm_hsusb/gadget/wakeup
chmod -h 220 /sys/devices/platform/msm_hsusb/gadget/wakeup

# Set platform variables
if [ -f /sys/devices/soc0/hw_platform ]; then
    soc_hwplatform=`cat /sys/devices/soc0/hw_platform` 2> /dev/null
else
    soc_hwplatform=`cat /sys/devices/system/soc/soc0/hw_platform` 2> /dev/null
fi

# Get hardware revision
if [ -f /sys/devices/soc0/revision ]; then
    soc_revision=`cat /sys/devices/soc0/revision` 2> /dev/null
else
    soc_revision=`cat /sys/devices/system/soc/soc0/revision` 2> /dev/null
fi

target=`getprop ro.board.platform`

#
# Check ESOC for external MDM
#
# Note: currently only a single MDM is supported
#
if [ -d /sys/bus/esoc/devices ]; then
for f in /sys/bus/esoc/devices/*; do
    if [ -d $f ]; then
        if [ `grep "^MDM" $f/esoc_name` ]; then
            esoc_link=`cat $f/esoc_link`
            break
        fi
    fi
done
fi

#
# Allow USB enumeration with default PID/VID
#
imagetype=`getprop ro.boot.imagetype`
case "$imagetype" in
    "mfi") # Set default config for mfi regardless of debug,eng or user
        setprop persist.sys.usb.config adb
        setprop sys.usb.config adb
    ;;
    *)
        usb_config=`getprop persist.sys.usb.config`
        image_type=`getprop ro.build.type`
        adb_mode=`getprop ro.boot.adb.mode`
        inproduction=`getprop ro.boot.inproductionflag`
        case "$inproduction" in
            "true") # SFI in production needs to use mtp,adb mode
                #setprop persist.sys.usb.config diag,serial_smd,serial_tty,rmnet_ipa,mass_storage,adb
                #setprop sys.usb.config diag,serial_smd,serial_tty,rmnet_ipa,mass_storage,adb
                setprop persist.sys.usb.config diag,adb
                setprop sys.usb.config diag,adb
            ;;
            *)
                case "$usb_config" in
                    "" | "adb" | "none" | "charging") # USB persist config not set or we're coming out of charger screen, select default config
                        case "$image_type" in
                            "eng" | "userdebug") #Debug, eng, for sfi, enable ADB by default
                                setprop persist.sys.usb.config mtp,adb
                                setprop sys.usb.config mtp,adb
                            ;;
                            *)
                                case "$adb_mode" in
                                    "enable")
                                        setprop persist.sys.usb.config mtp,adb
                                        setprop sys.usb.config mtp,adb
                                        ;;
                                    *)
                                        setprop persist.sys.usb.config mtp
                                        setprop sys.usb.config mtp
                                        ;;
                                esac
                            ;;
                        esac
                    ;;
                    * )
                    ;; # USB persist config exists, do nothing
                esac
            ;;
        esac
    ;;
esac

# set USB controller's device node
case "$target" in
    "msm8996")
        setprop sys.usb.controller "6a00000.dwc3"
	;;
    "msmcobalt")
        setprop sys.usb.controller "a800000.dwc3"
	;;
    *)
	;;
esac

# check configfs is mounted or not
if [ -d /config/usb_gadget ]; then
	setprop sys.usb.configfs 1
fi

#
# Do target specific things
#
case "$target" in
    "msm8974")
# Select USB BAM - 2.0 or 3.0
        echo ssusb > /sys/bus/platform/devices/usb_bam/enable
    ;;
    "apq8084")
	if [ "$baseband" == "apq" ]; then
		echo "msm_hsic_host" > /sys/bus/platform/drivers/xhci_msm_hsic/unbind
	fi
    ;;
    "msm8226")
         if [ -e /sys/bus/platform/drivers/msm_hsic_host ]; then
             if [ ! -L /sys/bus/usb/devices/1-1 ]; then
                 echo msm_hsic_host > /sys/bus/platform/drivers/msm_hsic_host/unbind
             fi
         fi
    ;;
    "msm8994" | "msm8992" | "msm8996" | "msm8953")
        echo BAM2BAM_IPA > /sys/class/android_usb/android0/f_rndis_qc/rndis_transports
        # echo 131072 > /sys/module/g_android/parameters/mtp_tx_req_len
        # echo 131072 > /sys/module/g_android/parameters/mtp_rx_req_len
    ;;
esac

#
# set module params for embedded rmnet devices
#
rmnetmux=`getprop persist.rmnet.mux`
case "$baseband" in
    "mdm" | "dsda" | "sglte2")
        case "$rmnetmux" in
            "enabled")
                    echo 1 > /sys/module/rmnet_usb/parameters/mux_enabled
                    echo 8 > /sys/module/rmnet_usb/parameters/no_fwd_rmnet_links
                    echo 17 > /sys/module/rmnet_usb/parameters/no_rmnet_insts_per_dev
            ;;
        esac
        echo 1 > /sys/module/rmnet_usb/parameters/rmnet_data_init
        # Allow QMUX daemon to assign port open wait time
        chown -h radio.radio /sys/devices/virtual/hsicctl/hsicctl0/modem_wait
    ;;
    "dsda2")
          echo 2 > /sys/module/rmnet_usb/parameters/no_rmnet_devs
          echo hsicctl,hsusbctl > /sys/module/rmnet_usb/parameters/rmnet_dev_names
          case "$rmnetmux" in
               "enabled") #mux is neabled on both mdms
                      echo 3 > /sys/module/rmnet_usb/parameters/mux_enabled
                      echo 8 > /sys/module/rmnet_usb/parameters/no_fwd_rmnet_links
                      echo 17 > write /sys/module/rmnet_usb/parameters/no_rmnet_insts_per_dev
               ;;
               "enabled_hsic") #mux is enabled on hsic mdm
                      echo 1 > /sys/module/rmnet_usb/parameters/mux_enabled
                      echo 8 > /sys/module/rmnet_usb/parameters/no_fwd_rmnet_links
                      echo 17 > /sys/module/rmnet_usb/parameters/no_rmnet_insts_per_dev
               ;;
               "enabled_hsusb") #mux is enabled on hsusb mdm
                      echo 2 > /sys/module/rmnet_usb/parameters/mux_enabled
                      echo 8 > /sys/module/rmnet_usb/parameters/no_fwd_rmnet_links
                      echo 17 > /sys/module/rmnet_usb/parameters/no_rmnet_insts_per_dev
               ;;
          esac
          echo 1 > /sys/module/rmnet_usb/parameters/rmnet_data_init
          # Allow QMUX daemon to assign port open wait time
          chown -h radio.radio /sys/devices/virtual/hsicctl/hsicctl0/modem_wait
    ;;
esac

#
# Initialize RNDIS Diag option. If unset, set it to 'none'.
#
diag_extra=`getprop persist.sys.usb.config.extra`
if [ "$diag_extra" == "" ]; then
	setprop persist.sys.usb.config.extra none
fi

# soc_ids for 8937
if [ -f /sys/devices/soc0/soc_id ]; then
	soc_id=`cat /sys/devices/soc0/soc_id`
else
	soc_id=`cat /sys/devices/system/soc/soc0/id`
fi

# enable rps cpus on msm8937 target
setprop sys.usb.rps_mask 0
case "$soc_id" in
	"294" | "295")
		setprop sys.usb.rps_mask 40
	;;
esac

#!/system/bin/sh
#
# Install the recovery image
#
# Copyright (c) 2018 by BlackBerry Limited. All Rights Reserved.
# BlackBerry Limited does not grant any rights,
# including the accompanying associated documentation,
# (the Software) for any purpose whatsoever, including without limitation
# any rights to copy, use or distribute the Software. Your rights to use the
# Software shall be only as set forth in any separate license between you and
# BlackBerry Limited.

copy_partition() {
	result=$(md5sum $1 $2)
	if [ $? -ne 0 ]; then
		log -t recovery "Error in getting md5sum for $1 and $2"
		return 1
	fi

	# The result is in the format "<md5sum> <path>". We only need the md5sum portion.
	set -A md5_sums ${result}

	src_md5=${md5_sums[0]}
	target_md5=${md5_sums[2]}

	if [ "${src_md5}" != "${target_md5}" ]; then
		log -t recovery "Installing $2 ..."
		dd if=$1 of=$2 bs=${BLOCK_SIZE}
		if [ $? -ne 0 ]; then
			log -t recovery "Installing $2: failed"
			return 1
		else
			log -t recovery "Installing $2: succeeded"
		fi
	else
		log -t recovery "$2 already installed"
	fi

	return 0
}

get_md5sum() {
	md5sum_result=$(dd if=$1 bs=${BLOCK_SIZE} count=$2 | md5sum)
	if [ $? -ne 0 ]; then
		log -t recovery "Error in getting md5sum for $1"
		return 1
	fi

	# The result is in the format "<md5sum> <path>". We only need the md5sum portion.
	set -A md5_sums ${md5sum_result}

	echo ${md5_sums[0]}
}

copy_partition_blocks() {
	src_md5=$(get_md5sum $1 $3)
	target_md5=$(get_md5sum $2 $3)

	if [ "${src_md5}" != "${target_md5}" ]; then
		log -t recovery "Installing $2 ..."
		dd if=$1 of=$2 bs=${BLOCK_SIZE} count=$3
		if [ $? -ne 0 ]; then
			log -t recovery "Installing $2: failed"
			return 1
		else
			log -t recovery "Installing $2: succeeded"
		fi
	else
		log -t recovery "$2 already installed"
	fi

	return 0
}


PATH_ROOT=/dev/block/bootdevice/by-name
BOOT_PATH=${PATH_ROOT}/boot
BOOT_SIG_PATH=${PATH_ROOT}/bootsig
RECOVERY_PATH=${PATH_ROOT}/recovery
RECOVERY_SIG_PATH=${PATH_ROOT}/recoverysig

# For  Athena, the boot partition is 65536KB and recovery partition is 65532KB
# We can only copy 65532KB from boot to recovery, i.e. 16383 blocks (block=4KB)
NUM_OF_BLOCKS="16383"
BLOCK_SIZE="4096"

copy_partition_blocks ${BOOT_PATH} ${RECOVERY_PATH} ${NUM_OF_BLOCKS}
copy_partition ${BOOT_SIG_PATH} ${RECOVERY_SIG_PATH}

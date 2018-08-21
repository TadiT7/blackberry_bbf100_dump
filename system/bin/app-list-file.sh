#!/system/bin/sh

echo "app-list-file starting"

TEMP_INFO_FILE_PATH="/carrier/persist/applist/temp_info_file"
#TEMP_INFO_FILE_PATH="datafile"
TEMP_FILE_CONTENT_PATH="/carrier/persist/applist/temp_content_file"
#TEMP_FILE_CONTENT_PATH="temp_content_file"
TEMP_OLD_INFO_FILE_PATH="/carrier/persist/applist/temp_old_info_file"
#TEMP_OLD_INFO_FILE_PATH="temp_old_info_file"
TEMP_LOG_FILE_PATH="/dev/kmsg"

if [ -f ${TEMP_INFO_FILE_PATH} ]; then 
	echo "founded app-list-file" > ${TEMP_LOG_FILE_PATH}
else 
	echo "app-list-file not found temp_file" > ${TEMP_LOG_FILE_PATH}
	echo "setprop persist.file.update.flag 0" > ${TEMP_LOG_FILE_PATH}
	setprop persist.file.update.flag 0
	exit 0
fi

remove_old_file=$(grep '^remove_old_file=' ${TEMP_INFO_FILE_PATH})
remove_old_file=${remove_old_file#*=}
echo "remove_old_file ${remove_old_file}" > ${TEMP_LOG_FILE_PATH}

if [ -f ${TEMP_OLD_INFO_FILE_PATH} ]; then
	old_file_path=$(grep '^old_file_path=' ${TEMP_OLD_INFO_FILE_PATH})
	old_file_path=${old_file_path#*=}
	echo "old_file_path ${old_file_path}" > ${TEMP_LOG_FILE_PATH}

	if [ -n "${remove_old_file}" ]; then
		if [ -n "${old_file_path}" ]; then
			rm ${old_file_path}
			rm ${TEMP_OLD_INFO_FILE_PATH}
			echo "rm ${old_file_path} rm ${TEMP_OLD_INFO_FILE_PATH}" > ${TEMP_LOG_FILE_PATH}
		fi
	fi
fi

new_file_user=$(grep '^new_file_user=' ${TEMP_INFO_FILE_PATH})
new_file_user=${new_file_user#*=}
new_file_group=$(grep '^new_file_group=' ${TEMP_INFO_FILE_PATH})
new_file_group=${new_file_group#*=}
new_file_permission=$(grep '^new_file_permission=' ${TEMP_INFO_FILE_PATH})
new_file_permission=${new_file_permission#*=}
new_file_name=$(grep '^new_file_name=' ${TEMP_INFO_FILE_PATH})
new_file_name=${new_file_name#*=}
new_file_path=$(grep '^new_file_path=' ${TEMP_INFO_FILE_PATH})
new_file_path=${new_file_path#*=}
new_file_new=$(grep '^new_file_new=' ${TEMP_INFO_FILE_PATH})
new_file_new=${new_file_new#*=}
new_file_delete=$(grep '^new_file_delete=' ${TEMP_INFO_FILE_PATH})
new_file_delete=${new_file_delete#*=}

echo "new_file_user ${new_file_user}" > ${TEMP_LOG_FILE_PATH}
echo "new_file_group ${new_file_group}" > ${TEMP_LOG_FILE_PATH}
echo "new_file_permission ${new_file_permission}" > ${TEMP_LOG_FILE_PATH}
echo "new_file_name ${new_file_name}" > ${TEMP_LOG_FILE_PATH}
echo "new_file_path ${new_file_path}" > ${TEMP_LOG_FILE_PATH}
echo "new_file_new ${new_file_new}" > ${TEMP_LOG_FILE_PATH}
echo "new_file_delete ${new_file_delete}" > ${TEMP_LOG_FILE_PATH}

if [ -n "${new_file_name}" ]; then
	echo "mark -1 check new file name" > ${TEMP_LOG_FILE_PATH}
	if [ -n "${new_file_path}" ]; then
		echo "mark 0 check new file path ${new_file_path}" > ${TEMP_LOG_FILE_PATH}

		if [ ! -d "${new_file_path}" ]; then
			echo "mark 1 create new file path directory ${new_file_path}" > ${TEMP_LOG_FILE_PATH}
			mkdir -p ${new_file_path}
		fi
		
		if [ -f "${new_file_path}${new_file_name}" ]; then
				echo "mark 2 rm ${new_file_path}${new_file_name}" > ${TEMP_LOG_FILE_PATH}
				rm ${new_file_path}${new_file_name}
		fi

		if [ -f "${TEMP_FILE_CONTENT_PATH}" ]; then
			echo "found ${TEMP_FILE_CONTENT_PATH} mv ${TEMP_FILE_CONTENT_PATH} ${new_file_path}${new_file_name}" > ${TEMP_LOG_FILE_PATH}
			mv ${TEMP_FILE_CONTENT_PATH} ${new_file_path}${new_file_name}
			echo "old_file_path=${new_file_path}${new_file_name}" > ${TEMP_OLD_INFO_FILE_PATH}
		else
			echo "not found ${TEMP_FILE_CONTENT_PATH}" > ${TEMP_LOG_FILE_PATH}
			if [ "${new_file_new}" = "1" ]; then
				echo "touch ${new_file_path}${new_file_name}" > ${TEMP_LOG_FILE_PATH}
				touch ${new_file_path}${new_file_name}
				echo "old_file_path=${new_file_path}${new_file_name}" > ${TEMP_OLD_INFO_FILE_PATH}
			fi
		fi
		
	fi
fi

if [ -n "${new_file_user}" ]; then
	if [ -n "${new_file_group}" ]; then
		echo "chown ${new_file_user}:${new_file_group} ${new_file_path}${new_file_name}" > ${TEMP_LOG_FILE_PATH}
               #[BugFix]Add-Begin by hewei, 2015/5/7, PR-933971 [Chameleon]chameleon framework: ensure file attribute of group
		chown ${new_file_user}:${new_file_group} ${new_file_path}${new_file_name}
               #[BugFix]Add-End by hewei, 2015/5/7, PR-933971 [Chameleon]chameleon framework: ensure file attribute of group
	fi
fi

if [ -n "${new_file_permission}" ]; then
	echo "chmod ${new_file_permission} ${new_file_path}${new_file_name}" > ${TEMP_LOG_FILE_PATH}
	chmod ${new_file_permission} ${new_file_path}${new_file_name}
fi

if [ "${new_file_delete}" = "1" ]; then
	echo "rm ${new_file_path}${new_file_name}" > ${TEMP_LOG_FILE_PATH}
	rm ${new_file_path}${new_file_name}
fi

if [ -f "${TEMP_FILE_CONTENT_PATH}" ]; then
	echo "error here rm ${TEMP_FILE_CONTENT_PATH}" > ${TEMP_LOG_FILE_PATH}
	rm ${TEMP_FILE_CONTENT_PATH}
fi

if [ -f "${TEMP_INFO_FILE_PATH}" ]; then
	echo "rm ${TEMP_INFO_FILE_PATH}" > ${TEMP_LOG_FILE_PATH}
	rm ${TEMP_INFO_FILE_PATH}
fi

##make sure temp_old_info_file remebered file is exist. if not, delete it.
if [ -f ${TEMP_OLD_INFO_FILE_PATH} ]; then
	old_file_path=$(grep '^old_file_path=' ${TEMP_OLD_INFO_FILE_PATH})
	old_file_path=${old_file_path#*=}
	echo "old_file_path ${old_file_path}" > ${TEMP_LOG_FILE_PATH}
	if [ -n "${old_file_path}" ]; then
		if [ -f "${old_file_path}" ]; then
			echo "old_file_path ${old_file_path} exist" > ${TEMP_LOG_FILE_PATH}
		else
			echo "old_file_path ${old_file_path} not exist & delete ${TEMP_OLD_INFO_FILE_PATH}" > ${TEMP_LOG_FILE_PATH}
			rm ${TEMP_OLD_INFO_FILE_PATH}
		fi
	fi
fi

echo "setprop persist.file.update.flag 0" > ${TEMP_LOG_FILE_PATH}
setprop persist.file.update.flag 0

exit 0

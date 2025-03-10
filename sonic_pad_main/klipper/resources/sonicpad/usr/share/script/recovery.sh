#!/bin/ash

#第一版作者：Mr.chen
#创建于20210319，制定了恢复出厂设置的方案
#修改者：Mr.liu
#修改于20210422，优化了回复出厂设置后，MAC地址变化的问题

#备份的路径
backup_path=/mnt/UDISK/.crealityprint/
#还原的路径
original_path=/overlay/upper/etc/wifi/

backup_wpa_supplicant_file=${backup_path}/wpa_supplicant.conf
backup_xr_wifi_file=${backup_path}/xr_wifi.conf

original_wpa_supplicant_file=${original_path}/wpa_supplicant.conf
original_xr_wifi_file=${original_path}/xr_wifi.conf

#用户目录
user_path=/mnt/UDISK/
#系统目录
system_path=/overlay/

writeLog(){
	echo `date` " : " $1 >> /tmp/recovery.log
}

backup_MAC_Addr(){
	#先判断文件是否存在
	if [ ! -f ${original_xr_wifi_file} ]
	then
		writeLog "the file ${original_xr_wifi_file} is NULL."
		return 0
	fi

	#如果备份的路径不存在，则先创建
	if [ ! -d ${backup_path} ]
	then
		mkdir -p ${backup_path}
	fi

	cp ${original_xr_wifi_file} ${backup_path}

	sync
}

backup_WIFI_Conf(){
	#先判断文件是否存在
	if [ ! -f ${original_wpa_supplicant_file} ]
	then
		writeLog "the file ${original_wpa_supplicant_file} is NULL."
		return 0
	fi

	#如果备份的路径不存在，则先创建
	if [ ! -d ${backup_path} ]
	then
		mkdir -p ${backup_path}
	fi

	cp ${original_wpa_supplicant_file} ${backup_path}

	sync
}

recovery_MAC_Addr(){
	#先判断要还原的文件是否存在
	if [ ! -f ${backup_xr_wifi_file} ]
	then
		writeLog "the file ${backup_xr_wifi_file} is NULL."
		return 0
	fi

	#如果还原的路径不存在，则创建
	if [ ! -d ${original_path} ]
	then
		mkdir -p ${original_path}
	fi

	mv ${backup_xr_wifi_file} ${original_path}

	sync
}

recovery_WIFI_Conf(){
	#先判断要还原的文件是否存在
	if [ ! -f ${backup_wpa_supplicant_file} ]
	then
		writeLog "the file ${backup_wpa_supplicant_file} is NULL."
		return 0
	fi

	#如果还原的路径不存在，则创建
	if [ ! -d ${original_path} ]
	then
		mkdir -p ${original_path}
	fi

	mv ${backup_wpa_supplicant_file} ${original_path}

	sync
}

del_system_file(){
	rm -rf ${system_path}/*
	writeLog "rm -rf ${system_path}"
}

del_user_file(){
	rm -rf ${user_path}/*
	writeLog "rm -rf ${user_path}"

	#清空可能之前存在的备份文件
	rm -rf ${backup_path}
	writeLog "rm -rf ${backup_path}"
}

create_unbind_flag(){
	if [ ! -d ${backup_path} ]
	then
		mkdir -p ${backup_path}
	fi

	touch ${backup_path}/unbind_users.yaml
	sync
}

if [ $# = 0 ]
then
	echo "##############recovery backup_file##############"
else
	case $1 in
		"all")
			#还原出厂设置(还原用户数据、系统数据)
			writeLog "###############recovery all(system & user data)#################"
			#删除用户数据
			del_user_file
			#在删除系统数据前，先保存MAC地址(当前的MAC地址由文本存放，所以需要提前保存备份)
			#后续如果使用正常的生产烧录MAC动作，则可以不用此功能函数
			backup_MAC_Addr
			#删除系统文件
			del_system_file
			#还原MAC地址
			recovery_MAC_Addr
			create_unbind_flag
			sync && reboot -f
			;;
		"part")
			#还原系统设置(只还原系统数据，保留用户数据)
			writeLog "###############recovery system data#################"
			#保存MAC地址以及wifi配置文件
			backup_MAC_Addr
			backup_WIFI_Conf
			#删除系统文件
			del_system_file
			#还原MAC地址以及wifi配置文件
			recovery_MAC_Addr
			recovery_WIFI_Conf
			#强制重启
			sync && reboot -f
			;;
	esac
fi


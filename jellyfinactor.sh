#!/bin/bash

oldIFS=$IFS
IFS=$'\n'

TARGET_FOLDER="/var/lib/jellyfin/metadata/People/"

# 复制演员图片到指定文件夹
copyActorImage() {
    # 文件名
    fileName=$(echo $(basename $1) | cut -d . -f1)
    # 首字母
    firstAlphabet=${fileName:0:1}
    # 文件夹名
    folderName=${fileName//_/\ }
    # 目标路径
    targetFolder=${TARGET_FOLDER}/${firstAlphabet}/${folderName}
    filePath=${targetFolder}/folder.jpg
	filePathp=${targetFolder}/poster.jpg

    if [ ! -d "${filePath}" ]; then
        echo ${1}" -----> "${filePath}
        mkdir -p "${targetFolder}" && cp ${1} "${filePath}"
		mkdir -p "${targetFolder}" && cp ${1} "${filePathp}"
    else
        echo ${filePath}" is existed."
#        rm -rf ${1}
    fi
}

copyActor(){
	echo $1
	find $1 -name '.actors' | while read -r item_folder; do
		for item_file in $(ls "${item_folder}"); do
		copyActorImage ${item_folder}/${item_file}
		done
#		rm -rf ${item_folder}
	done
}

listFiles() {
    #1st param, the dir name
    #2nd param, the aligning space
    for file in `ls $1`;
	do
        if [ -d "$1/$file" ]; then
        	echo "$2$file"
#			listFiles "$1/$file" "   $2"
			copyActor "$1/$file"
		else
#			echo "$2$file"
			echo ""
		fi
	done
}


# 遍历.actor文件夹


listFiles  /mnt/nas/data/media/firm


echo "Move Finished"

IFS=$oldIFS
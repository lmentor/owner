#!/bin/bash

if [ $1 ]; then
	mkdir -p $1/strm 2>/dev/null
	touch $1/strm.txt
	echo "编辑 $1/strm.txt 文件，格式如下："
	echo "docker_address=http://192.168.1.8:5678"
	echo "scan_path=/每日更新/电视剧/卢森堡"
	echo "username=xxx"
	echo "password=yyy"
	echo "============================================="
	if [ -s $1/strm.txt ]; then
		local_sha=$(docker inspect --format='{{index .RepoDigests 0}}' xiaoyaliu/glue:python  |cut -f2 -d:)
		#remote_sha=$(curl --ipv4 -s "https://hub.docker.com/v2/repositories/xiaoyaliu/glue/tags/python"|grep -o '"digest":"[^"]*' | grep -o '[^"]*$' |tail -n1 |cut -f2 -d:)
		remote_sha=$(curl --ipv4 -s "https://hub.docker.com/v2/repositories/xiaoyaliu/glue/tags/python"|grep -o '"digest":"[^"]*' | grep -o '[^"]*$'  |tail -n1 |cut -f2 -d:)
		if [ ! "$local_sha" == "$remote_sha" ]; then
			docker rmi xiaoyaliu/glue:python
		fi
		if [[ $2 ]] && [[ "$2" == "pic=no" ]]; then
			docker create --rm -v $1:/media -v $1/strm.txt:/strm.txt -e LANG=C.UTF-8  xiaoyaliu/glue:python /init2.sh
		else	
			docker create --name=strm -v $1:/media -v $1/strm.txt:/strm.txt -e LANG=C.UTF-8  xiaoyaliu/glue:python /init3.sh
		fi	
	else
		echo "$1/strm.txt 为空文件，请编辑后重试"
		exit
	fi	
else
	echo "请在命令后输入 -s /媒体库目录 再重试"
	exit
fi

#!/bin/bash

file=AppStoreEnv.rb

if [ ! -f "$file" ]; then
	url=https://raw.githubusercontent.com/chaichai9323/ToolKit/main/AppStoreEnv.rb
	curl -fsSL ${url} -o $file
fi

if [ ! -f "$file" ]; then
	echo -e "\033[31m执行脚本出错了，请检查网络，然后重新执行\033[0m"; exit 0
fi


comstr="if File.exist?('./AppStoreEnv.rb');eval File.read('./$file');end"
if [[ `cat Podfile` =~ "$comstr" ]]; then
	echo -e "\033[32m工程环境配置完成\033[0m"
	exit 0
fi

line=""
for f in `find . -name "Podfile"`; do
  for row in `grep -n -E "\btarget\b\s+\S+\s+do\S{0}$" $f | cut -f1 -d:`; do
   		line=$row
   		break;
  done 
done

if [[ ${#line} < 1 ]]; then
	echo -e "\033[31m没有在Podfile文件中查找到 target 'oog' do 这样的内容，请检查Podfile文件内容 \033[0m"
	exit 0
fi

sed -i "" $line"a \\
  $comstr
" Podfile

echo -e "\033[32m工程环境配置完成\033[0m"
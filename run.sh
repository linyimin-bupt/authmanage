#!/bin/bash
#========================
# create by WangJun
# date 2014-11-06
# email wangjuntytl@163.com
#
# =============================
#
# 描述：构建脚本
#
# 如果你的开发平台是window，需要手动执行以下步骤
#   1. git clone https://github.com/WangJunTYTL/peaceful-basic-platform.git
#   2. 进入peaceful-basic-platform 目录 ，先执行 mvn install f peaceful-parent/pom.xml -Dmaven.test.skip=true 然后在执行 mvn install  -Dmaven.test.skip=true
#   3. 跳出进入authmanage 目录，执行 mvn install  -Dmaven.test.skip=true
#   4. 切入到auth-web 执行 mvn jetty:run [注意请先配置你的数据库]
#   5，访问 127.0.0.1:8888
#==================================

source /etc/profile
ENV=$1
[ "x${ENV}" == "x" ] && ENV='dev' # dev test product
echo '----------------------------------------------'
echo "构建环境：${ENV}"
echo '----------------------------------------------'
echo "构建工具git、mvn 安装检测"

cmd_is_exist(){
    echo "check $1 cmd is install ... "
    _r=`which $1`
    if [ $? == 0 ];then
        echo "OK"
    else
        echo "请先安装$1，并添加$1到PATH变量中" && exit 1
    fi
}

cmd_is_exist "mvn"
cmd_is_exist "git"
echo '----------------------------------------------'

git clone https://github.com/linyimin-bupt/peaceful-basic-platform.git

echo "准备下载依赖包并开始构建 ..."

cd peaceful-basic-platform
bash build.sh
cd ..
wait

mvn -f pom.xml -P${ENV} install -Dmaven.test.skip=true || exit 1

cd auth-web
mvn jetty:run -o -Dmaven.test.skip=true



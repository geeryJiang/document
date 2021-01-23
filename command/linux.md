ifconfig	查看服务器ip等信息

su root		进入root权限
su 用户名	进入用户

top	实时查看系统的整体运行情况

netstat(选项)		打印Linux中网络系统的状态信息
netstat -a		列出所有端口
netstat -l		只显示监听端口
netstat -c		持续(每秒)输出网络信息

cat /etc/issue	查看Linux系统版本

df -h 	查看磁盘剩余空间

du -s	仅显示总计，只列出最后加总的值
du -sh *

ls -l ==>ll	列出文件和文件夹的详细信息。
ls -lh		列出可读文件和文件夹详细信息。
ls -lt		按时间列出文件和文件夹详细信息。
ls -ltr		按修改时间列出文件和文件夹详细信息。

help <命令名称>	查看某命令的帮助文档

命令 --help	查看某命令的帮助文档

env|grep JAVA

ps -ef | grep []	查看某个应用的进程状态
lsof -i :6379	查看某端口占用情况
ps	用于报告当前系统的进程状态

kill -9 PID		强制杀死进程

date -R 查看当前时区

cat	

===========================搜索操作==========================

“|”（管通符）
	命令1 | 命令2		命令1的正确输出作为命令2的操作对象
	
xrags	给其他命令传递参数的一个过滤器；用作替换工具，读取输入数据重新格式化后输出

uname	打印当前系统相关信息

grep	文本搜索工具
	grep "" -A3 file_name		显示匹配某个结果之后的3行
	grep "" -B3 file_name		显示匹配某个结果之前的3行
	grep "" -C3 file_name		显示匹配某个结果前后的3行
	grep -r "" -l				显示包含某个字符串的所有文件名

find	在指定目录下查找文件
	find -name "*.log"			在当前目录及其子目录下的所有以.log结尾的文件
	find /user -name "*.log"	在user目录下查找以.log结尾的文件
	find | xargs grep -ri ""	查询当前文件目录下的所有文件中是否有某个字符串
	find | xargs grep -ri "" -l	查询当前文件目录下的所有文件中是否有某个字符串,只显示文件名

安装telnet 
yum install telnet

telnet(选项)(参数)		登录远程主机对远程主机进行管理
telnet [ip] [端口]		登录远程主机

clear		清屏，显示页向后翻一页
reset		完全刷新终端页面

=============================================================

===========================文本操作==========================

mkdir				创建目录
mkdir -m<目标属性>	创建目录的同时设置目录的权限

rm -f		强制删除文件或目录
rm -i		删除已有文件或目录之前询问用户
rm -r或-R	递归处理，将制定目录下的所有文件与子目录一并处理
rm -v		显示指令的详细执行过程

chmod		变更文件或目录的权限
	u-文件拥有者
	g-文件所属群主
	o-除以上两种的其他用户
	a-所有用户
	r-读取权限
	w-写入权限
	x-执行或切换权限
chmod u=rwx,g=rw,o=r filename	为filename文件的u用户设置读写执行权限，g用户设置读写权限，o用户设置度权限
chmod u+x filename				为filename文件的u用户增加执行权限

=============================================================

===========================压缩包操作========================

zip -r mydata.zip mydata	压缩mydata目录为mydata.zip

unzip mydata.zip -d mydatabak	解压mydata.zip到mydatabak目录下

zip -r abc123.zip abc 123.txt	把abc文件夹和123.txt压缩成abc123.zip

unzip 123.zip	解压123.zip到当前目录下

unzip *.zip	将当前目录下的所有zip解压到当前目录下

unzip -v 123.zip	查看123.zip里面的内容

unzip -t 123.zip	验证123.zip是否完整

tar -cvf <tar包路径及名称> <被打包的文件名>	为文件或目录创建档案（备份文件）
tar -zxvf fileName.tar.gz	解压tar包

jar -xvf fileName.jar	解压jar包
jar -cvfM0 filename.jar	把当前目录下的所有文件打包成filename.jar


=============================================================

===========================拷贝操作========================

cp [可选参数] source dest
cp -r source dest	若给出的源文件是一个目录文件，此时将复制该目录下所有的子目录和文件
cp -p source dest	保留原文件的修改时间，访问时间和访问权限
cp -f source dest	覆盖已经存在的目标文件而不给出提示
cp -i source dest	覆盖已经存在的目标文件之前给出提示
cp ../test.txt .	将test.txt文件复制到当前目录下
cp test.txt /home/../test1.txt	将test.txt 文件复制到/home/../下，并将名称改为test1.txt

scp [可选参数] file_source file_target ==> scp [可选参数] [[user@]host1:]file1 [...] [[user@]host2:]file2

scp /home/test/test.txt root@127.0.0.1:/home/test/test	从本地复制到远程

scp root@/127.0.0.1:/home/root/test.txt /home/test	从远程复制到本地

scp -r file_source file_target	递归复制整个目录

scp -p file_source file_target	保留原文件的修改时间，访问时间和访问权限

scp -P port	file_source file_target 指定数据传输用到的端口号

=============================================================

ssh	[-l user][-p port][user@]hostname	远程登录指定服务器

more fileName	显示文本文件的内容，支持vi中的关键字定位操作
less -l fileName	与more命令相似，允许用户向前或向后浏览文件，-l：搜索时忽略大小写的差异

===============================抓包命令==============================

tcpdump tcp -i any port xxx -w a.cap

tcpdump dst host 172.16.7.206 and port 80 -w /tmp/xxx.cap
dst 用于指定目标路径
src 用于指定源路径

tcpdump tcp -i eth1 -t -s 0 -c 100 and dst port ! 22 and src net 192.168.1.0/24 -w ./target.cap

(1)tcp: ip icmp arp rarp 和 tcp、udp、icmp这些选项等都要放到第一个参数的位置，用来过滤数据报的类型
(2)-i eth1 : 只抓经过接口eth1的包
(3)-t : 不显示时间戳
(4)-s 0 : 抓取数据包时默认抓取长度为68字节。加上-S 0 后可以抓到完整的数据包
(5)-c 100 : 只抓取100个数据包
(6)dst port ! 22 : 不抓取目标端口是22的数据包
(7)src net 192.168.1.0/24 : 数据包的源网络地址为192.168.1.0/24
(8)-w ./target.cap : 保存成cap文件，方便用ethereal(即wireshark)分析


在AIX环境抓包
iptrace -d 10.1.10.56 -p 8080 -b trace.log
ipreport trace.log >t.log
vi t.log

=============================================================


===============================sftp命令==============================
远程连接
sftp -Oport=22 用户名@IP

下载文件
get -r filename

=============================================================

===============================docker命令==============================

7以上版本设置防火墙开放端口
firewall-cmd --zone=public --add-port=8888/tcp --permanent
firewall-cmd --reload
firewall-cmd --list-port

7以上版本修改网络设置
nmtui
vim ifcfg-ens33
service network restart

docker安装相关
uname -r
yum install docker
systemctl start docker
docker -v
systemctl enable docker
systemctl stop docker
systemctl start docker

docker镜像加速相关
vim daemon.json
systemctl daemon-reload
systemctl restart docker

docker images
docker ps
docker ps -a
docker logs tomcat
docker search mysql
docker start 5d155d713312
docker stop 5d155d713312
docker rm 5d155d713312
docker restart 5d155d713312

docker pull tomcat:7.0.104-jdk8-adoptopenjdk-openj9
docker run --name mytomcat -d -p 8080:8080 tomcat:7.0.104-jdk8-adoptopenjdk-open9

docker pull mysql:5.6.48
docker run --name mysql01 -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.6.48

docker pull docker.io/redis
docker run -d -p 6379:6379 --name myRedis docker.io/redis

docker pull docker.io/elasticsearch:2.4.6
docker run -e ES_JAVA_OPTS="-Xms256m -Xmx256m" -d -p 9200:9200 -p 9300:9300 --name ES01 elasticsearch:2.4.6

docker pull docker.io/zookeeper
docker run --name zk01 -p 2181:2181 --restart always -d zookeeper

// 修改应用的系统参数，以mysql为例
docker exec -it 468bfb5e0cd8 /bin/bash
cd /etc/mysql
apt-get update
apt-get install vim
如果要退出bash有2种操作：1）Ctrl + d 退出并停止容器；2）Ctrl + p + q 退出并在后台运行容器；

=============================================================



==============================vi命令===============================

------------ 移动光标命令 -------------

[n]h	光标向左移动n个字符
[n]j	光标向下移动n个字符
[n]k	光标向上移动n个字符
[n]l	光标向右移动n个字符

w,b     移动到下/上一个单词

ctrl + b	屏幕向上移动一页
ctrl + f	屏幕向下移动一页

0	移动到行首
$	移动到行末
H	光标移动到屏幕的最上方一行
L	光标移动到屏幕的最下方一行
gg	光标移动到首行
G	光标移动到最后一行

[n]Enter	光标向下移动n行

-----------------------------------------

------------ 搜寻与取代命令 -------------

/word	向光标之下寻找一个字符串名称为word的字符串
?word	向光标之上寻找一个字符串名称为word的字符串

n	重复前一个搜寻动作
N	反向进行前一个搜寻动作

:n1,n2s/word1/word2/g	在第n1与n2行之间寻找word1这个字符串，并将该字符串取代为word2
:1,$s/word1/word2/g	在第一行与最后一行之间寻找word1这个字符串，并将该字符串取代为word2
:1,$s/word1/word2/gc	在第一行与最后一行之间寻找word1这个字符串，并将该字符串取代为word2,且在取代之前确认是否需要取代

-----------------------------------------

------------ 删除，复制，粘贴命令 -------------

x	向后删除一个字符
X	向前删除一个字符

dd	删除光标所在的那一整行
ndd	删除光标所在的向下n行
d1G	删除光标所在行到第一行的所有数据
dG	删除光标所在行到最后一行的所有数据
d0	删除光标所在处(不包括),到该行最前面一个字符
d$	删除光标所在处(包括),到该行的最后一个字符

yy	复制游标所在的那一行
[n]yy	复制游标所在的向下n行
y1G	复制光标所在行到第一行的所有数据
yG	复制光标所在行到最后一行的所有数据
y0	复制光标所在处(不包括),到该行最前面一个字符
y$	复制光标所在处(包括),到该行的最后一个字符

p	将已复制的数据在光标下一行粘贴
P	将已复制的数据在光标上一行粘贴

u	撤销前一个动作
U	行撤销，撤销所有在前一个编辑行上的操作
ctrl + r	重做前一个动作
.	重复前一个动作

-----------------------------------------

------------ 进入编辑模式 -------------

i	在当前字符前插入文本
I	在行首插入文本

r	取代光标所在的那个字符
R	一直取代光标所在的字符

a       在光标后插入编辑

o，O    在当前行后/前插入一个新行      

cw      删除一个单词，同时进入插入模式

Esc	退出编辑模式

-----------------------------------------

------------ 指令行命令模式 -------------

:w	将编辑的数据写入硬盘档案中(保存)
:w!	强制写入该档案(强制保存)
:q	离开vi
:q!	强制离开vi(不保存修改)
:wq	保存后离开
:wq!	强制保存后离开
ZZ	若档案没有更改，则不存储离开;若有更改，则储存后离开
:w[filename]	将编辑的数据储存成另一个档案
:r[filename]	将[filename]这个档案内容加到游标所在行后面
:n1,n2 w [filename] 将n1到n2的内容储存成filename这个档案
:! command	暂时离开vi到指令模式下执行command的显示结果，[:! ls /home] 即可在vi当中查看 /home 底下以ls输出的档案信息

:set all	查看所有的环境参数
:set nu	显示行号
:set nonu	取消行号

------------ vim -------------

v	字符选择，会将光标经过的地方反白选择
V	行选择，会将光标经过的行反白选择
ctrl+v	区块选择，可以用长方形的方式选择资料
y	将反白的地方复制
d	将反白的地方删除

:n [filename]	编辑下一个档案
:N [filename]	编辑上一个档案
:files	列出目前这个vim开启的所有档案

:sp [filename]	开启一个新窗口，如果有filename,表示在新窗口开启一个新档案，否则表示两个窗口为内容(同步显示)
ctrl + wj	光标移动到下方的窗口
ctrl + wk	光标移动到上方的窗口
ctrl + wq	保存并退出当前窗口

dos2unix [-kn] file [newfile]	将dos格式的档案转换成linux格式
unix2dos [-kn] file [newfile]	将linux格式的档案转换成dos格式
-k	保留该档案原本的mtime时间格式
-n	保留原本的旧档，将转换后的内容输出到新档案

=============================================================



==============================java 相关===============================

生成dump文件

jmap -dump:format=b,file=jamp_core_\`hostname\`.log  \`ps -ef | grep java | grep -v grep | awk {print $2}\`



=============================================================
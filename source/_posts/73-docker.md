---
title: 给自己写的docker文档 
index_img: /img/dockerLogo.png
date: 2022-07-01 15:33:00
tags: [Docker]
categories: [Docker]
---

# Docker学习笔记

## docker的基本组成

> 镜像（image）

-   docker镜像类似一个模板，可以通过这个模板来创建容器服务。
-   如： node镜像 ===》 run ===》 node001容器（用来提供服务）
-   通过这个node镜像可以创建多个容器，最终服务会运行在容器中。

> 容器（container）

-   docker利用容器技术，独立运行一个或一组应用，通过镜像创建
-   包含 启动、停止、删除等基本命令
-   可以把容器理解为一个简易的 linux系统

> 仓库（repository）

-   存放镜像的地方
-   仓库可分为 公共仓库 和 私有仓库
-   比如 Docker Hub 、 阿里云、腾讯云等等...

## docker 安装

默认是在linux上演示,以我的阿里云1G2核服务器,**CentOS8**为例。

> 查看系统内核：

-   我的内核版本为 4.18.0

```
[root@wangpf ~]# uname -r
4.18.0-193.28.1.el8_2.x86_64
```

> 查看系统配置： (注意docker在centos上需要在版本7以上！)

-   cat /etc/os-release

```
[root@wangpf ~]# cat /etc/os-release 
NAME="CentOS Linux"
VERSION="8 (Core)"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="8"
PLATFORM_ID="platform:el8"
PRETTY_NAME="CentOS Linux 8 (Core)"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:centos:centos:8"
HOME_URL="https://www.centos.org/"
BUG_REPORT_URL="https://bugs.centos.org/"
​
CENTOS_MANTISBT_PROJECT="CentOS-8"
CENTOS_MANTISBT_PROJECT_VERSION="8"
REDHAT_SUPPORT_PRODUCT="centos"
REDHAT_SUPPORT_PRODUCT_VERSION="8"
```

### 安装步骤：

官网文档：["Install Docker Engine on CentOS"](https://docs.docker.com/engine/install/centos/)

#### 1. 如果有旧版docker，需要先卸载旧的

```
 sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
```

#### 2. 下载docker需要的安装包

```
  sudo yum install -y yum-utils    
```

#### 3. 设置镜像仓库

```
 // 注意这个源是在国外，若没有开代理会很慢。
 sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```

#### 4. 更新yum软件包索引

```
yum makecache fast
​
// 注 centos 8以上要去掉fast
```

#### 5. 安装docker相关设置

`注： docker-ce 是社区版 docker-ee是企业版`

```
yum install docker-ce docker-ce-cli containerd.io
```

#### 6. 启动 docker

```
systemctl start docker
# 查看当前版本号， 是否启动成功
docker version
# 设置开机自启动
systemctl enbale docker
```

下载 hello-world 测试一下

```
docker run hello-world 
```

`注：没有安装的话，会自动去dockerHub上面找并拉取最新版本`

#### 7. 查看 hello-world 的镜像

```
docker images
```

```
[root@wangpf ~]# docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
hello-world   latest    feb5d9fea6a5   2 months ago   13.3kB
```

### 卸载docker

文档链接： [uninstall-docker-engine](https://docs.docker.com/engine/install/centos/#uninstall-docker-engine)

### 配置国内加速

> 镜像加速源

| 镜像加速器         | 镜像加速器地址                                 |
| ------------- | --------------------------------------- |
| Docker 中国官方镜像 | <https://registry.docker-cn.com>        |
| DaoCloud 镜像站  | <http://f1361db2.m.daocloud.io>         |
| Azure 中国镜像    | <https://dockerhub.azk8s.cn>            |
| 科大镜像站         | <https://docker.mirrors.ustc.edu.cn>    |
| 阿里云           | https://<your_code>.mirror.aliyuncs.com |
| 七牛云           | <https://reg-mirror.qiniu.com>          |
| 网易云           | <https://hub-mirror.c.163.com>          |
| 腾讯云           | <https://mirror.ccs.tencentyun.com>     |

## docker 基本命令

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c8c958f2b4f24befaa3644904b6f577b~tplv-k3u1fbpfcp-watermark.image?)
### 帮助命令

```
# docker 的版本信息
docker version 
# docker 的系统信息，包括镜像和容器的数量
docker info

# 帮助命令
docker xxx --help
```

官方文档命令指南：[docker command line](https://docs.docker.com/engine/reference/commandline/cli/)

个人还是很喜欢用命令行来帮助自己快速熟知具体命令，主要是因为是快且方便（因为文档是在国外）

### 镜像基本命令

docker images 查看本地主机上的镜像

```
[root@wangpf ~]# docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
hello-world   latest    feb5d9fea6a5   2 months ago   13.3kB

# 可选项
[root@wangpf ~]# docker images --help

Usage:  docker images [OPTIONS] [REPOSITORY[:TAG]]

List images

Options:
  -a, --all             Show all images (default hides intermediate images)
      --digests         Show digests
  -f, --filter filter   Filter output based on conditions provided
      --format string   Pretty-print images using a Go template
      --no-trunc        Don't truncate output
  -q, --quiet           Only show image IDs
```

#### 1. 搜索镜像

```
docker search 镜像名
```

比如：`docker search node`

```
[root@wangpf ~]# docker search node
NAME                                   DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
node                                   Node.js is a JavaScript-based platform for s…   10852     [OK]
mongo-express                          Web-based MongoDB admin interface, written w…   1092      [OK]
nodered/node-red                       Low-code programming for event-driven applic…   387
nodered/node-red-docker                Deprecated - older Node-RED Docker images.      353                  [OK]
prom/node-exporter                                                                     266                  [OK]
selenium/node-chrome                                                                   228                  [OK]
....
```

或者去 docker Hub上去找：[docker Hub 官网](https://hub.docker.com/)

#### 2. 下载镜像

```
docker pull 镜像名   # 默认下载最新版本

docker pull 镜像名:<version>  # 下载指定版本
```

举例： 下载node

```
[root@wangpf ~]# docker pull node
Using default tag: latest
latest: Pulling from library/node
5e0b432e8ba9: Pull complete
a84cfd68b5ce: Pull complete
e8b8f2315954: Pull complete
0598fa43a7e7: Pull complete
83098237b6d3: Pull complete
ddb281e9d102: Pull complete
f2395e503032: Pull complete
923ae81df72f: Pull complete
e398359b21ac: Pull complete
Digest: sha256:13621aa823b6b92572d19c08a75f7b1a061633089f37873f8b5bedb5e900e657
Status: Downloaded newer image for node:latest
docker.io/library/node:latest
```

> 注： docker pull node === docker pull docker.io/library/node:latest

下载某个具体版本 `注意：该版本必须是在dockerHub上存在的版本才行。`

```
[root@wangpf ~]# docker pull node:14.18.2-alpine
14.18.2-alpine: Pulling from library/node
97518928ae5f: Pull complete
23182d7a473a: Pull complete
c006eebfdd13: Pull complete
a3c2ac39ae5d: Pull complete
Digest: sha256:7bcf853eeb97a25465cb385b015606c22e926f548cbd117f85b7196df8aa0d29
Status: Downloaded newer image for node:14.18.2-alpine
docker.io/library/node:14.18.2-alpine
```

#### 3. 删除镜像

```
docker rmi    # 注意 i 代表的是镜像
```

骚操作：

```
docker rmi -f $(docker images -aq)   # 强制删除所有的镜像
```

### 容器基本命令

> 有了镜像才可以创建容器

#### 1. 创建容器并启动

docker run --help 发现有太多参数了，举出常用的几个。

```
docker run [可选参数] image

# 参数说明
--name string                    Assign a name to the container (容器名字，用来区分容器)
-d, --detach                     Run container in background and print container ID（后台方式运行）
-it															 使用交互方式运行，进入容器内查看
-p, --publish list               Publish a container's port(s) to the host （指定一个容器端口）
-P, --publish-all                Publish all exposed ports to random ports  (随机指定端口)
--rm                             Automatically remove the container when it exits
```

**测试一下： 比如下载个centos镜像并创建容器并进入容器中**

```
docker pull centos
docker run -it centos /bin/bash
```

```
[root@wangpf ~]# docker run -it centos /bin/bash
[root@3bcf93dd0c56 /]# ls
bin  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
[root@3bcf93dd0c56 /]#
```

#### 2. 列出所有容器

常用参数

```
# docker ps  列出当前正在运行的容器
-a, --all             Show all containers (default shows just running)   列出所有运行过的容器
-n, --last int        Show n last created containers (includes all states) (default -1)  显示最近创建的容器
-q, --quiet           Only display container IDs  显示容器编号
```

#### 3. 退出容器

在容器内如何退出？

-   exit 退出并停止运行 (若不是用run命令进入的容器则只会退出)
-   control + p control + q 只退出

#### 4. 启动和停止容器操作

```
docker start [container id]     # 启动容器  （启动后，用 `docker attach [container id] 可进入该容器`）
docker restart [container id]   # 重启容器
docker stop [container id]      # 停止当前正在运行的容器
docker kill [container id]      # 强制停止当前容器
```

#### 5. 删除容器

```
docker rm [container id]       		# 删除指定容器，（不能删除正在运行的容器，如果要强制删除 rm -f）
docker rm -f $(docker ps -aq)     # 删除所有容器
docker ps -a -q|xargs docker rm   # 删除所有容器
```

### 其他常用命令

#### 1. 后台启动容器

```
docker run -d centos
```

注意有坑：

0.  当你启动 centos时， 用 docker ps 查看发现并没有容器启动 （原因是因为docker发现该容器没有服务，docker自动将其停止了）
0.  所以当 容器使用后台运行时，需要有一个前台进程

#### 2. 查看日志

```
docker logs -tf --tail string 容器id

# 参数说明
-t   # 显示时间戳
-f   # 保留打印窗口,持续打印（即实时显示）
--tail string  # 记得加参数 ，如 --tail 10 显示最后10行日志
```

#### 3. 查看容器中进程信息

`docker top 容器id`

```
[root@wangpf ~]# docker top --help

Usage:  docker top CONTAINER [ps OPTIONS]

Display the running processes of a container
```

```
# 测试
[root@wangpf ~]# docker top b4f5ff60ef4a
UID              PID              PPID             C           STIME            TTY              TIME             CMD
root             7596             7576             2           21:39            pts/0            00:00:00         /bin/bash
```

#### 4. 查看镜像源数据

`docker inspect 容器id`

```
# 测试
[root@wangpf ~]# docker inspect  b4f5ff60ef4a
[
    {
        "Id": "b4f5ff60ef4abf47c47f751bb38433a807c14460b741331e02dfbc31aa767ae3",
        "Created": "2021-12-12T13:07:00.10041237Z",
        "Path": "/bin/bash",
        "Args": [],
        "State": {
            "Status": "exited",
            "Running": false,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 0,
            "ExitCode": 137,
            "Error": "",
            "StartedAt": "2021-12-12T13:07:00.684590947Z",
            "FinishedAt": "2021-12-12T13:08:15.423516148Z"
        },
        "Image": "sha256:5d0da3dc976460b72c77d94c8a1ad043720b0416bfc16c52c45d4847e53fadb6",
        "ResolvConfPath": "/var/lib/docker/containers/b4f5ff60ef4abf47c47f751bb38433a807c14460b741331e02dfbc31aa767ae3/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/b4f5ff60ef4abf47c47f751bb38433a807c14460b741331e02dfbc31aa767ae3/hostname",
        "HostsPath": "/var/lib/docker/containers/b4f5ff60ef4abf47c47f751bb38433a807c14460b741331e02dfbc31aa767ae3/hosts",
        "LogPath": "/var/lib/docker/containers/b4f5ff60ef4abf47c47f751bb38433a807c14460b741331e02dfbc31aa767ae3/b4f5ff60ef4abf47c47f751bb38433a807c14460b741331e02dfbc31aa767ae3-json.log",
        "Name": "/amazing_gagarin",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": null,
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {},
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "CgroupnsMode": "host",
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "private",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "ConsoleSize": [
                0,
                0
            ],
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "KernelMemory": 0,
            "KernelMemoryTCP": 0,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": false,
            "PidsLimit": null,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/4498c608a3e6193a4996a1b12695d57df26404240df5401efc246539cdb12bac-init/diff:/var/lib/docker/overlay2/503aefb56de70e6b2b9b20df1dd037818d2f6959f4ab6b7d6d6e80e7fe877e2e/diff",
                "MergedDir": "/var/lib/docker/overlay2/4498c608a3e6193a4996a1b12695d57df26404240df5401efc246539cdb12bac/merged",
                "UpperDir": "/var/lib/docker/overlay2/4498c608a3e6193a4996a1b12695d57df26404240df5401efc246539cdb12bac/diff",
                "WorkDir": "/var/lib/docker/overlay2/4498c608a3e6193a4996a1b12695d57df26404240df5401efc246539cdb12bac/work"
            },
            "Name": "overlay2"
        },
        "SizeRw": 0,
        "SizeRootFs": 231268856,
        "Mounts": [],
        "Config": {
            "Hostname": "b4f5ff60ef4a",
            "Domainname": "",
            "User": "",
            "AttachStdin": true,
            "AttachStdout": true,
            "AttachStderr": true,
            "Tty": true,
            "OpenStdin": true,
            "StdinOnce": true,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
            ],
            "Cmd": [
                "/bin/bash"
            ],
            "Image": "centos",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": null,
            "OnBuild": null,
            "Labels": {
                "org.label-schema.build-date": "20210915",
                "org.label-schema.license": "GPLv2",
                "org.label-schema.name": "CentOS Base Image",
                "org.label-schema.schema-version": "1.0",
                "org.label-schema.vendor": "CentOS"
            }
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "f9ae31473be3e2c21b44e903369feec8a35eeff1512890051c9cce637d6752fe",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {},
            "SandboxKey": "/var/run/docker/netns/f9ae31473be3",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "",
            "Gateway": "",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "",
            "IPPrefixLen": 0,
            "IPv6Gateway": "",
            "MacAddress": "",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "cde6e70f65eb81bfcc2d15eeef56a70d9f0ee51b43817c15c200c48aec8bceb4",
                    "EndpointID": "",
                    "Gateway": "",
                    "IPAddress": "",
                    "IPPrefixLen": 0,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "",
                    "DriverOpts": null
                }
            }
        }
    }
]
```

#### 5. 进入当前正在运行的容器

通常容器都是使用后台方式运行的，如需要进入容器，修改一些配置可以以下几种方式

**方式一：`docker exec -it 容器id`**

**方式二：`docker attach 容器id`**

区别：

-   docker exec 进入容器后会开启一个新的终端，可以在里面操(常用)
-   docker attach 进入容器正在执行的终端，不会启动新的进程

#### 6. 从容器中拷贝文件到本地

```
docker cp 容器id:path 本地path
```

```
# 测试
[root@wangpf home]# docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED             STATUS          PORTS     NAMES
b4f5ff60ef4a   centos    "/bin/bash"   About an hour ago   Up 13 minutes             amazing_gagarin
[root@wangpf home]# docker exec -it b4f5ff60ef4a /bin/bash
[root@b4f5ff60ef4a /]# touch /home/text.html
[root@b4f5ff60ef4a /]# cd /home/
[root@b4f5ff60ef4a home]# ls
text.html
[root@b4f5ff60ef4a home]# exit
exit
[root@wangpf home]# docker cp b4f5ff60ef4a:/home/text.html .
[root@wangpf home]# ls
text.html
```

## docker 镜像

### commit 镜像

> 由于从官方下载的一些镜像，有些不满足我们的需求，我们需要在该镜像上添加一些常用功能。这时我们就可以提交一个镜像，以后使用我们提交的这个镜像使得效率大大提高，要不然每次都需要在官方默认的镜像中添加我们常用的功能就很麻烦

```
docker commit 提交容器成功一个镜像

# 命令和git类似
docker commit -m='提交的信息' -a='作者名' 容器id 目标镜像名
```

**实战测试tomcat**

步骤：

0.  启动一个默认的tomcat
0.  发现这个默认的tomcat 是没有webapps应用，这是镜像的原因，官方的镜像默认 webapps 下是没有文件的
0.  拷贝基本的文件到webapps目录
0.  最后我们将操作过的容器通过commit提交为一个镜像，之后我们就使用提交过的镜像即可

## 数据卷 (**volumes**)

使用数据集实现容器的持久化和同步操作（容器间也可以实现数据共享）

[Docker vloumes 描述](https://docs.docker.com/get-started/05_persisting_data/)

[Use volumes | Docker Documentation](https://docs.docker.com/storage/volumes/)

### 常用命令

```
➜  /wangpf docker volume --help 

Usage:  docker volume COMMAND

Manage volumes

Commands:
  create      Create a volume
  inspect     Display detailed information on one or more volumes
  ls          List volumes
  prune       Remove all unused local volumes
  rm          Remove one or more volumes

Run 'docker volume COMMAND --help' for more information on a command.
```

### 使用数据卷

> 方式一： 直接使用命令来挂载 -v （和 -p 一样， -v 主机目录:容器内目录）

**数据同步:**

```
docker run -it -v /wangpf/test:/home centos /bin/bash 

test docker inspect f5df5f 
        "Mounts": [
            {
                "Type": "bind",          
                "Source": "/wangpf/test",  // 主机目录
                "Destination": "/home",   //  容器目录
                "Mode": "",
                "RW": true,
                "Propagation": "rprivate"
            }
        ],
        
# 使用数据卷技术，不管是修改主机还是容器内的目录的文件，相对的一方都会发生改变，实现了同步操作（即双向绑定）
```

当容器已经和本地映射后，当关掉容器后，即使在本地目录修改文件内容，再次启动容器时，依旧会同步

![image-20211221183213087]()

**数据持久化：** 即使把容器给删掉了，本地的文件依旧会有

### 具名挂载和匿名挂载

#### 匿名挂载

```
# -v 容器内路径 (以 nginx 举例, 只写容器内的路径，不写容器外的路径)
docker run -d -P --name nginx-demo1 -v /etc/nginx nginx 

# 匿名挂载时 默认存放位置
➜  /wangpf docker volume ls    （c查看所有 volume 情况）
DRIVER    VOLUME NAME
local     141cad1da9e2c26a3f2ba4ada3ce1f84ccdbd5d0b9e13b753a4e13a947d5e17b
➜  /wangpf docker volume inspect 141cad1da9e2c26a3f2ba4ada3ce1f84ccdbd5d0b9e13b753a4e13a947d5e17b  （查看该卷的详细信息） 
[
    {
        "CreatedAt": "2021-12-26T16:50:09+08:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/141cad1da9e2c26a3f2ba4ada3ce1f84ccdbd5d0b9e13b753a4e13a947d5e17b/_data",
        "Name": "141cad1da9e2c26a3f2ba4ada3ce1f84ccdbd5d0b9e13b753a4e13a947d5e17b",
        "Options": null,
        "Scope": "local"
    }
]


# 默认存放地址：  "/var/lib/docker/volumes/141cad1da9e2c26a3f2ba4ada3ce1f84ccdbd5d0b9e13b753a4e13a947d5e17b/_data",
```

#### 具名挂载

```
# -v 名字：容器内名字 （注意 具名时不能用 / ，要不会被认为是绝对路径）
➜  /wangpf docker run -d -P --name nginx-demo3 -v juming-nginx:/etc/nginx nginx 
9c0f1222328b25c5e58160d08627bca437dca99ee58ae90b53533b72a9e71686
➜  /wangpf docker volume ls                                                     
DRIVER    VOLUME NAME
local     141cad1da9e2c26a3f2ba4ada3ce1f84ccdbd5d0b9e13b753a4e13a947d5e17b
local     juming-nginx
➜  /wangpf docker volume inspect juming-nginx                                                               
[
    {
        "CreatedAt": "2021-12-26T16:58:49+08:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/juming-nginx/_data",
        "Name": "juming-nginx",
        "Options": null,
        "Scope": "local"
    }
]

# 存放地址：  "/var/lib/docker/volumes/juming-nginx/_data",
```

### 总结

所有的docker容器内的数据卷，没有指定目的情况下都是默认在 `/var/lib/docker/volumes/[匿名随机名/具名名字]/_data"` 下的

我们通过具名可以方便的找到我们的卷，大多数情况使用的是`具名挂载`

```
-v 容器内路径             ## 匿名挂载
-v 卷名:容器内路径        ## 具名挂载  （注意: 不要带 / ）
-v /宿主机路径:容器内路径  ## 指定路径挂载
```

### 拓展

```
通过 -v 容器内路径:[ro/rw] 来改变读写权限 , 默认为 rw
```

如下面俩条命令

```
 docker run -d -P --name nginx-demo3 -v juming-nginx:/etc/nginx:ro nginx 
 docker run -d -P --name nginx-demo3 -v juming-nginx:/etc/nginx:rw nginx 
```

区别在与 `ro` 和 `rw`

顾名思义：

-   `ro` 即 `read only` 只读
-   `rw` 即 `read write` 可读写

### 数据卷容器

先略过

## Dockerfile

> dockerfile 用来构建 docker镜像的构建文件 命令参数脚本

构建步骤:

0.  编写 dockerfile 文件
0.  docker build 构建为一个镜像
0.  docker run 运行镜像
0.  docker push 发布镜像 (Docker Hub 、 阿里云镜像仓库等等)

### Dockerfile 构建过程

基础知识：

0.  每个保留关键字(指令)都必须是大写字母
0.  从上到下顺序执行
0.  `#` 表示注释
0.  每一个指令都创建提交一个新的镜像层，并提交

### Dockerfile 常用命令

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/11ab92915bc94e52aac63bf7e2dce357~tplv-k3u1fbpfcp-watermark.image?)


```
FORM            # 基础镜像，一切从这里开始构建
MAINTAINER      # 描述该镜像是谁写的， 姓名+邮箱 (已弃用)
LABEL           # 介绍该镜像
RUN             # 镜像构建时候需要运行的命令
ADD             # 步骤 如: 添加tomcat镜像， 添加内容
WORKDIR         # 镜像的工作目录
VOLUME          # 挂载的目录
EXPOSE          # 暴露端口  类似与 -p
CMD             # 指定这个容器启动时候需要运行的命令，
ENTRYPOINT      # 同上， 和上者有区别。会在下文说到
ONBUILD         # 当构建一个被继承 dockerfile， 这个时候会运行 ONBUILD 的指令， 触发指令
COPY            # 类似ADD ， 将文件拷贝到镜像中
ENV             # 设置环境变量  如：设置mysql的用户名密码...
```

测试：

创建一个简单的centos加强版， 默认镜像里是没有 vim ifconfig 等命令的

```
# 1. 编写 dockerfile 文件
➜  dockerfile-demo cat dockerfile-centos-test 
FROM centos

LABEL version="1.0"
LABEL description="This test demo"

ENV PATH /usr/local

WORKDIR $PATH

RUN yum -y install vim
RUN yum -y install net-tools

EXPOSE 3333

CMD echo $PATH
CMD echo '-----end-------'
CMD /bin/bash


# 2 通过这个文件构建镜像
# 命令 docker builf -f dockerfile-centos-test -t centos-test01:1.0 .
```

### CMD 和 ENTRYPOINT 的区别

> CMD # 制定这个容器启动的时候运行的命令，只有最后一个会生效，可被替代 ENTRYPOINT # 指定这个容器启动的时候要运行的命令，可以追加命令

#### 测试 CMD

```
# 编写dockerfile文件
➜  dockerfile-demo cat dockerfile-cmd-test                
FROM centos

CMD ["ls","-a"]


# 构建写的镜像
➜  dockerfile-demo docker build -f dockerfile-cmd-test -t test-cmd .           
Sending build context to Docker daemon  4.096kB
Step 1/2 : FROM centos
 ---> 5d0da3dc9764
Step 2/2 : CMD ["ls","-a"]
 ---> Running in c90cf1ce0209
Removing intermediate container c90cf1ce0209
 ---> f5e299a19206
Successfully built f5e299a19206
Successfully tagged test-cmd:latest

# 运行刚刚写的镜像生产的容器
➜  dockerfile-demo docker run -it f5e299a19206           
.   .dockerenv  dev  home  lib64       media  opt   root  sbin  sys  usr
..  bin         etc  lib   lost+found  mnt    proc  run   srv   tmp  var


# 但如果想在后边追加命令就会报错  （-l 想变成 ls -al 不行！）
➜  dockerfile-demo docker run -it f5e299a19206 -l
docker: Error response from daemon: OCI runtime create failed: container_linux.go:380: starting container process caused: exec: "-l": executable file not found in $PATH: unknown.
ERRO[0000] error waiting for container: context canceled 

# 原因在于
由于使用的 CMD   CMD ["ls","-a"] 命令 被替换成了 -l ， 而 -l 不是命令所以报错
```

#### 测试 ENTRYPOINT

```
# 编写dockerfile文件
➜  dockerfile-demo cat dockerfile-entrypoint-test  
FROM centos

ENTRYPOINT ["ls","-a"]


# 构建镜像
➜  dockerfile-demo docker build -f dockerfile-entrypoint-test -t entrypoint-test . 
Sending build context to Docker daemon   5.12kB
Step 1/2 : FROM centos
 ---> 5d0da3dc9764
Step 2/2 : ENTRYPOINT ["ls","-a"]
 ---> Running in 3085bdc9deb8
Removing intermediate container 3085bdc9deb8
 ---> 4b4e041eb4da
Successfully built 4b4e041eb4da
Successfully tagged entrypoint-test:latest

# 运行容器
➜  dockerfile-demo docker run -it 4b4e041eb4da                                      
.   .dockerenv  dev  home  lib64       media  opt   root  sbin  sys  usr
..  bin         etc  lib   lost+found  mnt    proc  run   srv   tmp  var

# 追加命令
➜  dockerfile-demo docker run -it 4b4e041eb4da -l
total 56
drwxr-xr-x   1 root root 4096 Dec 28 10:39 .
drwxr-xr-x   1 root root 4096 Dec 28 10:39 ..
-rwxr-xr-x   1 root root    0 Dec 28 10:39 .dockerenv
lrwxrwxrwx   1 root root    7 Nov  3  2020 bin -> usr/bin
drwxr-xr-x   5 root root  360 Dec 28 10:39 dev
drwxr-xr-x   1 root root 4096 Dec 28 10:39 etc
drwxr-xr-x   2 root root 4096 Nov  3  2020 home
lrwxrwxrwx   1 root root    7 Nov  3  2020 lib -> usr/lib
lrwxrwxrwx   1 root root    9 Nov  3  2020 lib64 -> usr/lib64
drwx------   2 root root 4096 Sep 15 14:17 lost+found
drwxr-xr-x   2 root root 4096 Nov  3  2020 media
drwxr-xr-x   2 root root 4096 Nov  3  2020 mnt
drwxr-xr-x   2 root root 4096 Nov  3  2020 opt
dr-xr-xr-x 131 root root    0 Dec 28 10:39 proc
dr-xr-x---   2 root root 4096 Sep 15 14:17 root
drwxr-xr-x  11 root root 4096 Sep 15 14:17 run
lrwxrwxrwx   1 root root    8 Nov  3  2020 sbin -> usr/sbin
drwxr-xr-x   2 root root 4096 Nov  3  2020 srv
dr-xr-xr-x  13 root root    0 Dec 28 10:39 sys
drwxrwxrwt   7 root root 4096 Sep 15 14:17 tmp
drwxr-xr-x  12 root root 4096 Sep 15 14:17 usr
drwxr-xr-x  20 root root 4096 Sep 15 14:17 var

# 发现 entrypoint 是可以追加命令的
```

## Docker 网络

```
➜  /wangpf ip addr    
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 52:54:00:cb:06:fb brd ff:ff:ff:ff:ff:ff
    inet 10.0.24.9/22 brd 10.0.27.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fecb:6fb/64 scope link 
       valid_lft forever preferred_lft forever
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:9d:ae:9f:aa brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:9dff:feae:9faa/64 scope link 
       valid_lft forever preferred_lft forever
```

lo: 本机回环地址

eth0: 服务器内网地址

docker0: docker内地址

### docker 是如何处理容器网络访问的？

```
# 查看容器内部网络地址 ip addr
# 如果找不到 ip 这个命令 需要进入容器内部 执行 apt-get update && apt-get install -y iproute2

➜  /wangpf docker exec -it tomcat01 ip addr  
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
82: eth0@if83: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:ac:11:00:03 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.17.0.3/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
       
 # 这时会发现有个  eth0@if83 的ip地址， 是docker给容器配的
```

思考： 宿主机（linux）是否可以 ping 同 docker容器内部的ip

```
Q: 是可以的
➜  /wangpf ping 172.17.0.3
PING 172.17.0.3 (172.17.0.3) 56(84) bytes of data.
64 bytes from 172.17.0.3: icmp_seq=1 ttl=64 time=0.047 ms
64 bytes from 172.17.0.3: icmp_seq=2 ttl=64 time=0.055 ms
64 bytes from 172.17.0.3: icmp_seq=3 ttl=64 time=0.048 ms
^C
--- 172.17.0.3 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 1999ms
rtt min/avg/max/mdev = 0.047/0.050/0.055/0.003 ms
```

我们每启动一个docker容器，docker就会给docker容器分配一个ip，我们只要装了 docker，就会有一个网卡：docker0

docker网络是用的 桥接模式， 使用技术是 **veth-pair** 技术

再次测试 ip addr

```
➜  /wangpf ip addr 
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 52:54:00:cb:06:fb brd ff:ff:ff:ff:ff:ff
    inet 10.0.24.9/22 brd 10.0.27.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fecb:6fb/64 scope link 
       valid_lft forever preferred_lft forever
3: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:9d:ae:9f:aa brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:9dff:feae:9faa/64 scope link 
       valid_lft forever preferred_lft forever
75: veth72b0f32@if74: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default 
    link/ether 26:ca:1f:86:15:f0 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::24ca:1fff:fe86:15f0/64 scope link 
       valid_lft forever preferred_lft forever
83: veth1597a88@if82: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default 
    link/ether 3e:51:59:a8:18:14 brd ff:ff:ff:ff:ff:ff link-netnsid 1
    inet6 fe80::3c51:59ff:fea8:1814/64 scope link 
       valid_lft forever preferred_lft forever
```

#### 结论

发现: 83: veth1597a88@if82 竟然和 内部容器ip地址：82: eth0@if83 是有联系的，

每产生一个容器，就会生产一对，

这其实就是 **veth-pair** 技术 ，即 一对的虚拟设备即可，它们都是成对出现的，一端连接着协议，一端彼此相连

正因为这个特性， **veth-pair** 充当一个桥梁，连接各种虚拟网络设备

### 容器互联

```
➜  /wangpf docker network ls        
NETWORK ID     NAME      DRIVER    SCOPE
6fc08493ee6d   bridge    bridge    local
d60b6ea897f9   host      host      local
d35f61e167a9   none      null      local
```

网络模式：

-   bridge : docker默认桥接网络
-   host : 主机网络，可以使用宿主机的网络栈，共享宿主机网络
-   none : 不配置网络

测试：

```
# 直接启动的命令，默认是自带 --net bridge 这个就是docker0
docker run -d -P --name tomcat01 tomcat
等价于
docker run -d -P --name tomcat01 --net bridge tomcat 
```

#### 自定义网络

```
# --dirver bridge (默认就是这个)
# --subnet 192.168.0.0/24  (子网掩码)
# --gateway 192.168.0.1  （网关）
```

测试

```
➜  /wangpf docker network create --driver bridge --subnet 192.168.0.0/24 --gateway 192.168.0.1  mynet 
cbf69e5ae412b8636e29f060c9a00ad769851a2d37e1036a344e50d17128ed82
➜  /wangpf docker network ls                                                                          
NETWORK ID     NAME      DRIVER    SCOPE
6fc08493ee6d   bridge    bridge    local
d60b6ea897f9   host      host      local
cbf69e5ae412   mynet     bridge    local
d35f61e167a9   none      null      local
➜  /wangpf docker network inspect mynet
[
    {
        "Name": "mynet",
        "Id": "cbf69e5ae412b8636e29f060c9a00ad769851a2d37e1036a344e50d17128ed82",
        "Created": "2021-12-29T16:18:51.071995435+08:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [           // 注意这里！！
                {
                    "Subnet": "192.168.0.0/24",
                    "Gateway": "192.168.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]
```

```
# 连接网络
➜  /wangpf docker run -d -P --name tomca-nett01 --net mynet tomcat:9.0
3d690e942aa7ab13c0b41f020a5f834b807ce28e591d83a893f3ca3cecec2b09
➜  /wangpf docker run -d -P --name tomca-nett02 --net mynet tomcat:9.0
51ac52f3a129808d0210310f8607f3712332202c13c8bce63808af36e526552a

# 再次查看 mynet 详细信息
➜  /wangpf docker network inspect mynet                               
[
    {
        "Name": "mynet",
        "Id": "cbf69e5ae412b8636e29f060c9a00ad769851a2d37e1036a344e50d17128ed82",
        "Created": "2021-12-29T16:18:51.071995435+08:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "192.168.0.0/24",
                    "Gateway": "192.168.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {    // 刚刚俩个连接的容器 ！！
            "3d690e942aa7ab13c0b41f020a5f834b807ce28e591d83a893f3ca3cecec2b09": {
                "Name": "tomca-nett01",
                "EndpointID": "f9cf82205338298aee158eeb43e8ddc56959254fe8040ab88dcb17f403a35a13",
                "MacAddress": "02:42:c0:a8:00:02",
                "IPv4Address": "192.168.0.2/24",
                "IPv6Address": ""
            },
            "51ac52f3a129808d0210310f8607f3712332202c13c8bce63808af36e526552a": {
                "Name": "tomca-nett02",
                "EndpointID": "d34235570f8c2ea3ca9814d61d21c3be7bf9c70071f3161ed897bdf346b5611d",
                "MacAddress": "02:42:c0:a8:00:03",
                "IPv4Address": "192.168.0.3/24",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```

为什么使用自定义网络的原因:

0.  主要是因为 docker0 的方式（无法直接通过容器名来连接， 当然配置 --link 也可以，不过这个不推荐了），
0.  自定义容器可以将俩个容器都放在一个局域网内，使得这个俩个容器，使用容器名就可以通信了

测试

```
# 用容器  tomcat-net01 是可以 ping 通  tomcat-net02 的！

root@44d12fd7d79f:/usr/local/tomcat# ping tomcat-net02
PING tomcat-net02 (192.168.0.3) 56(84) bytes of data.
64 bytes from tomcat-net02.mynet (192.168.0.3): icmp_seq=1 ttl=64 time=0.045 ms
64 bytes from tomcat-net02.mynet (192.168.0.3): icmp_seq=2 ttl=64 time=0.059 ms
^C
--- tomcat-net02 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 0.045/0.052/0.059/0.007 ms
```

#### 网络连通

> docker network connect

测试

```
#  以 docker0 网卡 起个容器
docker run -d -P --name tomcat01 tomcat:9.0

# 这时肯定是 ping 不通 mynet 网卡上的容器的
docker exec -it tomcat01 ping tomcat-net01
ping: tomcat-net01: Name or service not known

# 使用 docker network connect

➜  /wangpf docker network connect mynet tomcat01
➜  /wangpf docker network inspect mynet          
        "Containers": {
            "44d12fd7d79f61e3b1da1cbd491d880bb5a69ff18d7da0008031381796c34087": {
                "Name": "tomcat-net01",
                "EndpointID": "2770cd7186061615abbceb79846b196ad01f8e7bfb3e2c0d7855d38f05f17206",
                "MacAddress": "02:42:c0:a8:00:02",
                "IPv4Address": "192.168.0.2/24",
                "IPv6Address": ""
            },
            "a750eb7d5a21afd1f2662a2be3e846f224c731939bc2b3995ca578ca79cfc78a": {
                "Name": "tomcat-net02",
                "EndpointID": "a4f26995539029c65a5df222c8590765b262d635c9375d1b348836b36b8b10f9",
                "MacAddress": "02:42:c0:a8:00:03",
                "IPv4Address": "192.168.0.3/24",
                "IPv6Address": ""
            },
            "a92d70533b64f56f879e66b7d9080a963cf9427e61c016a7e4856bae645c6e87": {
                "Name": "tomcat01",
                "EndpointID": "4c6a4a54a0d3ac85ed8854ef4bd47ca700270b75ce0e0a41aad396389bd2744c",
                "MacAddress": "02:42:c0:a8:00:04",
                "IPv4Address": "192.168.0.4/24",
                "IPv6Address": ""
            }
        },
        
# 发现 tomcat01 容器 已经存放在了 mynet下了， 即 一个容器俩个ip地址

# 成化打通！！
➜  /wangpf docker exec -it tomcat01 ping tomcat-net01
PING tomcat-net01 (192.168.0.2) 56(84) bytes of data.
64 bytes from tomcat-net01.mynet (192.168.0.2): icmp_seq=1 ttl=64 time=0.064 ms
64 bytes from tomcat-net01.mynet (192.168.0.2): icmp_seq=2 ttl=64 time=0.051 ms
64 bytes from tomcat-net01.mynet (192.168.0.2): icmp_seq=3 ttl=64 time=0.056 ms
```

## docker compose

官方文档：[compose](https://docs.docker.com/compose/)

> Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application’s services. Then, with a single command, you create and start all the services from your configuration. To learn more about all the features of Compose, see [the list of features](https://docs.docker.com/compose/#features).
>
> Compose works in all environments: production, staging, development, testing, as well as CI workflows. You can learn more about each case in [Common Use Cases](https://docs.docker.com/compose/#common-use-cases).
>
> Using Compose is basically a three-step process:
>
> 0.  Define your app’s environment with a `Dockerfile` so it can be reproduced anywhere.
> 0.  Define the services that make up your app in `docker-compose.yml` so they can be run together in an isolated environment.
> 0.  Run `docker compose up` and the [Docker compose command](https://docs.docker.com/compose/cli-command/) starts and runs your entire app. You can alternatively run `docker-compose up` using the docker-compose binary.

注意： `compose` 是docker 的开源项目，需要去安装的！

### 安装 compose

官方文档：[compose install](https://docs.docker.com/compose/install/)

```
# 第一步 使用github actions 把打包后的代码公共自动化来传到 docker hub 上
# 第二步 在actions 中 登录服务器，并从 docker hub 把镜像拉下来并运行
```
未完...

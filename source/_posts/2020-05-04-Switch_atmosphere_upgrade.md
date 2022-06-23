---
title: Hexo Blog plugins test field
date: 2018-07-23 16:56:41
categories:
- [硬件相关,Switch]
tags: 
- CHN
- Nintendo Switch
---
![授权转载](https://kivinsae-blog.oss-accelerate.aliyuncs.com/blog_images/harukoNX-fs8.png)
<font color=Red><b>特别提醒:本人反对任何形式通过破解 Switch 侵害游戏公司利益的行为</b></font>

## **阅前须知**
- 本文由 `HarukoNX` 本人授权，任何其他平台和个人不得无端转载，本人和 `HarukuNX` 保留相关解释权。
- 原讨论串链接地址详见：**[GBATemp/HarukoNX - Latest FS and Acid Patches for Kosmos](https://gbatemp.net/threads/latest-fs-and-acid-patches-for-kosmos.562915/)**

## **前言**
近期任天堂发布了 `Nintend Switch` 最新版本的系统固件，固件版本 `10.0.2`。笔者之前出于存档备份和 `EdiZon` 研究需求，入手了一台**大气层裸板**，并手动重做影子系统至 `FW 9.2.0`。因此想尝试在 `10.0.2` 懒人包发布前自己手动撸一遍升级，顺便也为其他有需要的人提供一个踩坑的思路。

---

## **前期准备**
升级的前期准备其实也是老调重谈，需要的内容并不多，具体如下：
1. 一台支持 `Atmosphere` 破解的 `Nintendo Switch`（已 `Hetake`）
2. 最新版本的 `Kosmos` 引导包
    - `Atmosphere` 项目地址：[AtlasNX/Kosmos](https://github.com/AtlasNX/Kosmos/releases)
    - 需要注意的是该整合包内已包含 `hekate` 引导工具，如果不清楚什么是 `hekate`，请往下看。
3. 最新版本的 `Sigpatch-Installer`（此处为坑）
    - `Sigpatch-Installer` 项目地址：[HarukoNX/Sigpatch-Installer](https://github.com/HarukoNX/Sigpatch-Installer/releases)
4. 最新版本的 `ES patches`。
    - 适配 `10.0.0+ firmware` 的 `ES Patches` 整合包下载地址为：[HarukoNX/Fusee.zip](https://gbatemp.net/attachments/fusee-zip.207215/)
    - 感谢 `HarukoNX` 大神在 `Gbatemp` 整合的 `Sigpatch` 包`
5. 固件升级工具ChoiDujourNX
    - 下载地址：[ChoiDujourNX](https://switchtools.sshnuke.net/)
    - 注意别下载错了，是带 `NX` 的那个
6. 最新的 `Switch 10.0.2 Firmware`：
    - 下载地址：[Firmware 10.0.2](https://t00y.com/file/11753764-440642954)
    - 解压密码 `shipengliang`。固件下载原帖详见：[时鹏亮：Switch FW整合](https://shipengliang.com/download/switch/switch-firmware-%E5%9B%BA%E4%BB%B6%E4%B8%8B%E8%BD%BD.html)

## **操作步骤**

#### **一、备份当前 `Switch` 虚拟系统**
任何一个没有透彻理解 `Atmosphere` 的工作原理以及通读 `Atmosphere` 文档的玩家，我都建议在任何关于系统级的升级或补丁修复操作前，对整个系统进行完整的备份。如果系统过大，可以酌情考虑仅备份 `atmosphere`, `bootloader`, `sept` 这三个文件夹。

#### **二、拷贝最新的 Firmware 文件夹到SD卡根目录**
解压下载到的 `Firmware 10.0.2` 文件，获取到一个名字为 `Firmware 10.0.2` 的目录。复制该目录到 `Switch` 的 SD 卡根目录下，可以用 `nxtemp` 或者 `tinfoil` 来实现。

#### **三、更新最新版本的 `Kosmos`**
删除Switch SD卡中的 `atmosphere`, `bootloader`, `sept` 三个文件夹，此处我默认你已经做好了相关的备份。然后复制整个最新版 `Kosmos` 引导包中的**所有文件**，并拷贝到 **Switch** 的 SD 卡目录下。

#### **四、使用 `ChoiDujourNX` 升级系统固件至最新版本**
使用方法详见：
- [ChoiDujourNX使用方法视频](https://www.youtube.com/watch?v=n5odwq8m0A0)
- [ChoiDujourNX使用方法图文](http://www.ns-atmosphere.com/zh/tutorials/update801/)
- 升级后系统会进行重启，之后使用 `hekate` 正常引导 `EMUMMC` 的时候可能会在进入 `kosmos` 之后发生红字报错，这个是正常的。请根据实际的报错信息尽心故障排查，如果无法解决请在评论区留言。

#### **五、更新最新版本的 `SigPatch` 和 `ES Patch`**

进入 `Kosmos` 虚拟系统之后，进入 `Switch` 相册，打开 `Sigpatch-Installer(@HarukuNX)`，根据提示，安装匹配最新的版本的 `Sigpatch`。此时系统会重新进入 `hekate` 引导，此时正常进入 `EMUMMC` 引导重新进入虚拟系统即可。但是在进入系统之后，大概率会遇到两个坑：

- 部分已安装的程序或者游戏，会发生【程序损坏】报错，此时需要将程序本体删除。
- 重新使用 `GoldLeaf` 安装 `NSP` 文档时候，会发生 `#2145-001` 或者 `#2002-4518` 报错，报错信息如下：
```powershell
Error 2145-0001 (0x291) 
Module: ETicket (145) 
Description: Unknown or Undocumented error (1)
==================================
Error: 2002-4518 (0x234C02)
Modul: FS (2)
Description: Invalid NCA (Missing Sigpatches or too low firmware) (4518)
```
上述的两个报错基本都是由于系统 `ES Patch` 或者 `Sigpatch` 缺失或者异常导致的，由于我们本步骤中已经更新了 `SigPatch`，因此之后需要做的时候就是正确的更新适配 `10.0.0+` 固件版本的 `ES Patches`。
将上面准备工作中的 `Fusee.zip` 解压，将里面的内容根据目录结构复制覆盖到 **Switch** 的 `SD卡目录` 中。之后重启重新引导一次系统就可以正确进行 `NSP` 的签名与安装。
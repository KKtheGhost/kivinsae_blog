---
title: NuGet 应用实践：手搓 Vitual Studio Choco 安装包
date: 2023-05-26 23:20:00
categories:
- [software,security]
tags:
- lang_chinese
- windows
- dotnet
- chocolatey
---
## 引言

大家用过 Chocolatey 吗？我相信答案一定是 Yes，因为它是 Windows 下最好用的包管理工具，恩，大概率没有之一。

虽然当下大多数国内的互联网大厂和游戏公司为员工配发的设备以 MacOS 为主，但是大量的日常工作场景，依然会在 Windows 上进行。无论是 C# 相关的开发，以及跨 OS 应用的开发，亦或者 Unity3D、Unreal 引擎的游戏打包，开发者都需要在 Windows 环境下进行开发和调试。

因此，Chocolatey NuGet 包的统一管理和维护的必要性，也愈发凸显。

事实上，相对于 YUM 和 APT 这样的包管理工具，Chocolatey 的包管理与开发是相当容易的。本质上，Chocolatey 的包管理就是 NuGet 包管理和开发。而对于熟悉 dotnet 开发的人来说，学习成本非常低，近乎为零。

枯燥地讲概念和丢代码是没什么意思的，所以不如跟着我的脚步，一起来写一个属于你自己的 Visual Studio 2019 Professional 的 Chocolatey 安装包 *（尤其是当我发现 Google 上似乎并没有找到比较好的教程的时候）*

## 准备工作

在开始动手之前，我还是非常建议大家看一下 Chocolatey 官方的 [Create Packages](https://docs.chocolatey.org/en-us/create/create-packages) 文档。这篇文章相当详细的描述了在开发 Chocolatey 包的时候需要遵守的一些规范，以及一个 Chocolatey NuGet 仓库的最小基本结构。

正如官方文档所言，事实上一个 Chocolatey 包中真正强制需要的文件，只有一个 `*.nuspec` 声明文件。其他所有的内容都不是必须的。当然，为了让我们的包可以被简单得安装、部署和卸载，在实践上我们还需要提供 `chocolateyInstall.ps1` 和 `chocolateyUninstall.ps1` ，从而实现安装和卸载的自动化。

下面这个表描述了所有 Custom 脚本被调用的环节：

|Script Name|Install|Upgrade|Uninstall|
:-:|:-:|:-:|:-:
|`chocolateyBeforeModify.ps1`||Yes|Yes|
|`chocolateyInstall.ps1`|Yes|Yes||
|`chocolateyUninstall.ps1`|||Yes|

同时，为了便于在 CI 中进行打包，一个 `*.csproj` 文件往往也是推荐创建的。

那么在有了以上知识准备以后，我们就可以开始部署构建 Chocolatey 包的开发环境了。对于首次尝试的朋友，我们还是推荐 `Win10_22H2` 作为开发系统首选。

首先需要安装一些必要的组件：
#### **安装 Chocolatey**
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```
请注意，上面这条安装命令可能因版本的迭代而发生变化，请以官方文档为准。Chocolatey 官方的安装文档请参考 [Chocolatey Installation](https://chocolatey.org/install) 。

#### **安装 donet SDK 3.1 和 netapp 2.2**
请注意，这里并不是固定的版本，只是在今天的案例里， `*.csproj` 调用的 `<TargetFramework>` 是 `netapp 2.2`。

访问 [Download .NET Core 3.1](https://dotnet.microsoft.com/en-us/download/dotnet/3.1)，下载并安装对应的 Dotnet SDK 3.1 安装包。

使用 Chocolatey 安装 dotnet core app 2.2
```powershell
choco install dotnetcore --version=2.2.8
```

#### **安装 NuGet 依赖**

请访问 [Ways to install a NuGet Package](https://learn.microsoft.com/en-us/nuget/consume-packages/overview-and-workflow#ways-to-install-a-nuget-package) 来选择适合你的方法，在本地开发环境安装 NuGet

到此位置，打包一个 NuGet 包的开发环境就已经准备好了。

## 构建 NuGet Repository 的基本结构

因为这次我们要手搓一个 Visual Studio 的 NuGet 包，所以不妨将我们的 NuGet 仓库命名为 `my_vs2019pro`。注意，在 Chocolatey 中，我们的包名主要靠 `*.nuspec` 文件定义，和仓库名并不是必须一致的。

进入你的开发目录，我们先初始化我们的 NuGet 仓库：
```powershell
cd <my_dev_dir>
mkdir my_vs2019pro
cd my_vs2019pro
git init
```

然后按照以下的目录树结构，创建必要的空白文件：
```powershell
C:.
├───tools
│   ├───chocolateyinstall.ps1
│   └───chocolateyuninstall.ps1
├───.gitignore
├───vs2019-myproject.csproj
├───vs2019-myproject.nuspec
└───vs
    └───myproject
```

稍微解释一下这个 `vs/myproject` 目录。我们有时候可能希望为自己的多个项目和分支创建不同的 NuGet 包，这时候就可以使用这个目录来存放不同的项目。然后，通过 `*.nuspec` 文件中的 `<files>` 标签来进行挂载。

当然，这个目录也不是必须的。

那么到此位置，我们的 NuGet 仓库的基本结构就已经创建好了。下面开始写最关键的 Spec 部分。

## 配置你的 NuGet 仓库的基本信息

首先是整个 NuGet 仓库中最重要的 `*.nuspec` 文件。这个文件中包含了我们的 NuGet 包的基本信息，以及一些必要的配置。

```xml
<?xml version="1.0"?>
<package xmlns="http://schemas.microsoft.com/packaging/2011/08/nuspec.xsd">
  <metadata>
    <id>vs2019-myproject</id>
    <version>16.11.26</version>
    <title>Visual Studio 2019 Professional</title>
    <authors>Microsoft</authors>
    <owners>Kivinsae Fang - dev@kivinsae.com</owners>
    <licenseUrl>https://visualstudio.microsoft.com/license-terms/mlt031619/</licenseUrl>
    <projectUrl>https://visualstudio.microsoft.com/</projectUrl>
    <iconUrl>https://rawcdn.githack.com/jberezanski/ChocolateyPackages/21d70aedb9304792378a9f68d07d704cd0855827/icons/vs2019.png</iconUrl>
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <description>Visual Studio 2019 Professional @ MyProject</description>
    <summary>Visual Studio 2019 Professional @ MyProject</summary>
    <releaseNotes></releaseNotes>
    <copyright>https://www.microsoft.com/en-us/legal/intellectualproperty/permissions</copyright>
    <tags>microsoft visual studio visualstudio vs vs16 2019 professional ide admin</tags>
    <dependencies>
      <dependency id="chocolatey-visualstudio.extension" version="1.10.2" />
      <dependency id="KB3033929" version="1.0.5" />
      <dependency id="KB2919355" version="1.0.20160915" />
      <dependency id="KB2999226" version="1.0.20161201" />
      <dependency id="dotnetfx" version="4.7.2" />
      <dependency id="visualstudio-installer" version="2.0.2" />
    </dependencies>
  </metadata>
  <files>
    <file src="tools\**" target="tools" />
    <file src="vs\myproject\**" target="tools\vs" />
    <!--Building from Linux? You may need this instead: <file src="tools/**" target="tools" />-->
  </files>
</package>
```
关于 `*.nuspec` 的写法和合法参数列表，本篇不打算展开，因为在 [.nuspec reference](https://learn.microsoft.com/en-us/nuget/reference/nuspec) 里已经写的非常棒了。

如果只是希望能打出一个正确的 Visual Studio 安装包，直接抄上面的配置，然后替换成读者自己的信息即可。在本文书写的节点，Visual Studio 2019 Professional 的最新版本为 `16.11.26`。

请注意，切勿修改 `<dependencies>` 部分的内容，这些是 Visual Studio 2019 Professional 安装所必须的依赖项。该列表本身可以在 [Visual Studio 2019 Pro - Dependencies](https://community.chocolatey.org/packages/visualstudio2019professional#dependencies) 中找到。

其次是 `*.csproj` 打包文件。需要强调说明的是，即便这个文件没有，也不影响我们使用 nuget 命令进行打包。这个项目文件本身只是提供了一个通过 dotnet 命令进行打包的选项而已，从而让我们在 CI/CD 的时候有更多的选择。

直接来看文件内容吧：
```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>netcoreapp2.2</TargetFramework>
    <NuspecFile>./vs2019-myproject.nuspec</NuspecFile>
    <Version>16.11.26</Version>
    <!-- NU5111: dotnet pack doesn't recognize the chocolateinstall powershell files so complains. We can safely ignore this warning -->
    <NoWarn>NU5111</NoWarn> 
    <!-- Allow dotnet pack to pass in the version from the cli to the nuspec token replacement system -->
    <NuspecProperties>version=$(Version)</NuspecProperties> 
    <NoBuild>true</NoBuild>
    <NoDefaultExcludes>true</NoDefaultExcludes>
    <OutputPath>publish</OutputPath>
  </PropertyGroup>
</Project>
```

关于 NuGet `*.csproj` 文件的写法，微软同样提供了非常不错的文档说明：[Create a NuGet package using MSBuild](https://learn.microsoft.com/en-us/nuget/create-packages/creating-a-package-msbuild)。我们只需要根据自己的实际需求来进行填写即可，也可以参考上方的案例。最重要的一条参数其实就是 `<NuspecFile>`，这个参数指定了我们的 `*.nuspec` 文件的位置。

在开始打包 NuPKG 之前，我们还有 2 件事情要做：
- 完成 `chocolateyInstall.ps1` 和 `chocolateyUninstall.ps1` 的编写。
- 在 `vs\myproject` 目录下放置 Visual Studio 2019 Professional 的离线安装包和 Mainfest 配置。

## 如何编写安装和卸载脚本

正如上面所说，`chocolateyInstall.ps1` 和 `chocolateyUninstall.ps1` 这两个脚本虽然不是绝对必须的文件，但是 99.9% 的 Chocolatey NuGet 包都会在 `tools` 目录下放置这两个文件。从而便于用户在安装和卸载的时候能够一把梭了。

这两个文件的编写，说实话灵活性非常高，高到理论上你可以用写出几乎任何你能想象的安装流程，无论是复杂还是简单。当然，即便如此，依然有两个 Chocolatey 的命令行工具在这里扮演了至关重要的角色：
- [Install-ChocolateyPackage](https://docs.chocolatey.org/en-us/create/functions/install-chocolateypackage)
- [Uninstall-ChocolateyPackage](https://docs.chocolatey.org/en-us/create/functions/uninstall-chocolateypackage)

上面的文档里其实都给出了这两个命令行的用法，以及一些最佳实践类的代码案例。我们拿来修改一下，添加一些自己的需求，就可以开始调试了。
以下是我们的 `chocolateyInstall.ps1` 文件：
```powershell
$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)\vs"
$fileLocation = Join-Path $toolsDir 'vs_Setup.exe'
$responseFileLocation = Join-Path $toolsDir 'Response.json'

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    fileType      = 'EXE' #only one of these: exe, msi, msu
    file         = $fileLocation

    softwareName  = 'vs2019*'
    checksum      = 'AC87102F794643547F61B1EFD8D8A9F2E201872D8EEB308FBDD84299E5DCA962'
    checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512
    checksum64    = 'AC87102F794643547F61B1EFD8D8A9F2E201872D8EEB308FBDD84299E5DCA962'
    checksumType64= 'sha256' #default is checksumType

    # MSI
    silentArgs    = "--in $responseFileLocation --quiet --force --wait --norestart"
    validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs
```

在安装脚本中，我们实际上只是构造了一个 `$packageArgs` 结构体，然后将其传给 `Install-ChocolateyInstallPackage` 命令行工具而已。在这个结构体里，我们可以通过 `silentArgs` 往执行安装过程的二进制文件传入需要的参数。例如，上面的脚本里，我们甚至可以添加一个函数，通过读取服务器上的 `vault` 配置，从 Vault Enterprise 上动态获取 Visual Studio 2019 Professional 的 ProductKey，然后以 `--productKey` 的方式，通过 `silentArgs` 传递给安装程序 `vs_Setup`，从而在完成安装的同时，做好 License 的注册。

至于 `chocolateyUninstall.ps1`，其实就更简单了，我们只需要调用 `Uninstall-ChocolateyPackage` 命令行工具，然后传入一个 `$packageArgs` 结构体即可。具体还是需要根据你的实际需求来进行，尤其需要注意两点：
- 检测当前包是否真的被正确安装，以避免卸载报错。
- 传入正确的 `$packageArgs`。

下面为一个简单的例子：
```powershell
$ErrorActionPreference = 'Stop'; # stop on all errors

$vsinstallLocation = '"C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional"'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'vs2019*'
  fileType      = 'EXE' #only one of these: MSI or EXE (ignore MSU for now)
  # MSI
  silentArgs    = "uninstall --installPath $vsinstallLocation --quiet --force --wait --norestart"
  validExitCodes= @(0, 3010, 1605, 1614, 1641) # https://msdn.microsoft.com/en-us/library/aa376931(v=vs.85).aspx
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | % { 
    $packageArgs['file'] = "$($_.UninstallString)"
    if ($packageArgs['fileType'] -eq 'MSI') {
      $packageArgs['silentArgs'] = "$($_.PSChildName) $($packageArgs['silentArgs'])"
      $packageArgs['file'] = ''
    }

    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
}
```
类似的案例可以在 GitHub 上大量公开的 Chocolatey NuGet 库中找到，例如 [jberezanski/ChocolateyPackages](https://github.com/jberezanski/ChocolateyPackages) 这个仓库，作者维护了几乎所有的 Chocolatey Visual Studio 的 NuGet 包。

而本篇中的这两个文件，大家也可以在以下的 GitHub 仓库中找到，都是 Chocolatey 官方的 Templates：
- [tests/packages/msi.template/templates/tools/chocolateyinstall.ps1](https://github.com/chocolatey/choco/blob/master/tests/packages/msi.template/templates/tools/chocolateyinstall.ps1)
- [tests/packages/msi.template/templates/tools/chocolateyuninstall.ps1](https://github.com/chocolatey/choco/blob/master/tests/packages/msi.template/templates/tools/chocolateyuninstall.ps1)

## Visual Studio 离线安装包和 Mainfest 配置

接下来已经到了本次 NuGet 包构建的最后一步了，那就是准备好 Visual Studio 2019 的最小化离线安装包和 Mainfest 配置文件。之所以说是 **最小化**，是因为我们在获取  Visual Studio 2019 的离线安装包时，默认会下载所有的组件，而我们需要的仅仅是 `vs_Setup.exe` 和 Mainfest JSON 配置而已。

下面是操作的步骤，首先在你的临时目录中下载 Visual Studio 2019 Professional 的在线安装包 `vs_Professional.exe`：
- [Download VS2019Pro 16.11.26](https://download.visualstudio.microsoft.com/download/pr/48ee919d-ab7d-45bc-a595-a2262643c3bc/ac87102f794643547f61b1efd8d8a9f2e201872d8eeb308fbdd84299e5dca962/vs_Professional.exe)

然后参考微软官方的 [Control updates to network-based Visual Studio deployments](https://learn.microsoft.com/en-us/visualstudio/install/controlling-updates-to-visual-studio-deployments?view=vs-2019)，利用 `vs_Professional.exe` 生成本地的离线安装目录。
    
```powershell
vs_Professional.exe --layout C:\vsoffline --lang en-US
```

之后，你会在 `C:\vsoffline` 看到有大量的文件被下载和生成，而我们需要的 `vs_Setup.exe` 以及 Mainfest 配置文件，都会在一开始就被下载完毕，所需文件列表为：
```
Catalog.json
ChannelManifest.json
Layout.json
Response.json
vs_installer.version.json
vs_setup.exe
```
这些文件一旦下载完毕，我们就可以直接把 `vs_Professional.exe` 的离线包生成进程干掉了。

之后将这些文件移动到 `vs\myproject` 目录下，通过 `*.nuspec` 的 `<file>` 挂载，在安装的时候就可以直接被刚才写好的 `chocolateyinstall.ps1` 调用了。

**需要额外注意的是**，我们可以在 `Response.json` 中定义我们希望安装的 Visual Studio 组件，这对于自动化和自定义安装非常有帮助。

## 打包 NuPKG 并上传到 NuGet 源

正如上面所说，我们有两种打包 NuPKG 的方法：

使用 `nuget` 命令打包：
```powershell
nuget pack .\vs2019-myproject.nuspec
```

使用 `dotnet` 命令打包：
```powershell
dotnet pack .\vs2019-myproject.csproj
```

之后如果没有报错和意外，我们应该可以在 `my_vs2019pro` 目录下看到一个打包好的 `vs2019-myproject<Verison>.nupkg` 文件。这个文件便是之后需要上传到 NuGet 源的唯一文件。

打包的输出大致是这个样子：
```
Microsoft (R) Build Engine version 16.7.3+2f374e28e for .NET
Copyright (C) Microsoft Corporation. All rights reserved.

  Determining projects to restore...
  All projects are up-to-date for restore.
...Logs...
  Successfully created package '<YOUR_DEV_DIR>\my_vs2019pro\publish\vs2019-myproject.16.11.26.nupkg'.
```

同样的，我们有两种上传 NuPKG 的方法。

使用 `nuget` 命令上传：
```powershell
nuget setApiKey <YOUR_NUGET_APIKEY>
nuget push vs2019-myproject<Verison>.nupkg -Source <YOUR_NUGET_SERVER>
```

使用 `dotnet` 命令上传：
```powershell
dotnet nuget push --skip-duplicate --api-key <YOUR_NUGET_APIKEY> -s <YOUR_NUGET_SERVER> ./publish/vs2019-myproject*.nupkg
```

关于上传的详细内容，可以参考微软官方的 [Publish NuGet packages](https://learn.microsoft.com/en-us/nuget/nuget-org/publish-a-package)

---
### **最后祝大家身体健康，玩的开心**

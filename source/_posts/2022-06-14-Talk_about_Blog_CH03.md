---
title: 聊聊个人博客这件事（三）
date: 2022-06-15 02:30:22
categories:
- 博客搭建和优化
tags:
- CHN
- 随想
- 技术
- 博客
---
<font color=Green><b>长文预警</b></font> 好了，终于来到了聊聊个人博客系列的**完结篇**。本篇我会尽可能简单明了的聊一下我的个人博客所使用的博客框架的具体部署细节、所使用的主题、所进行的调优。如果能够在读者未来想到搭建自己的博客的时候，起到一丁半点的帮助，那便是不虚这些笔墨了。

我大体会从以下几块内容进行展开，同时这些内容也应当是一个从框架到细节的过程。当然由于篇幅所限制，会有一些内容可能无法被详细描述，我会在未来考虑针对某一些技术细节，单独写个Post来说清楚：
- [一、搭建和部署](#%E4%B8%80%E3%80%81%E6%90%AD%E5%BB%BA%E5%92%8C%E9%83%A8%E7%BD%B2)
  - [安装、部署和生成](#%E5%AE%89%E8%A3%85%E3%80%81%E9%83%A8%E7%BD%B2%E5%92%8C%E7%94%9F%E6%88%90)
  - [HTTPS和CertBot](#HTTPS%E5%92%8CCertBot)
  - [GitHub Action和自动化](#GitHub-Action%E5%92%8C%E8%87%AA%E5%8A%A8%E5%8C%96)
  - [防火墙问题](#%E9%98%B2%E7%81%AB%E5%A2%99%E9%97%AE%E9%A2%98)
- [二、插件的选择和优化](#%E6%8F%92%E4%BB%B6%E7%9A%84%E9%80%89%E6%8B%A9%E5%92%8C%E4%BC%98%E5%8C%96)
- [三、CSS样式调整和EJS修改](#CSS%E6%A0%B7%E5%BC%8F%E8%B0%83%E6%95%B4%E5%92%8CEJS%E4%BF%AE%E6%94%B9)
  - [折叠块的渲染](#%E6%8A%98%E5%8F%A0%E5%9D%97%E7%9A%84%E6%B8%B2%E6%9F%93)
  - [Tags和Categories页面支持](#Tags%E5%92%8CCategories%E9%A1%B5%E9%9D%A2%E6%94%AF%E6%8C%81)

## **一、搭建和部署**

### **安装、部署和生成**
其实对于`Hexo`的部署来说，本质上并不是搭建一个**Server**，而是一个静态页面目录的**生成器**。对于个人博客这种载体来说，我个人认为**静态页面是一个比Server更优的解法**。理由有很多，比如静态页面博客可以很自由的部署到任何形式的服务器甚至`SaaS`平台上，甚至于诸如`S3`、`OSS`这样的对象存储。换句话说，一旦你选择了静态页面框架作为你的博客方案，你可以把你的博客运维框架大幅度的简单化。而简单化也会带来安全、管理、维护等多个方面的便利性，你可以关注于更少的事情，把有限的事情做的更好。

言归正传，开始介绍`Hexo`生成器。在开始部署之前，我们最好还是比较仔细的阅读一下以下几个页面：
- [什么是Hexo](https://hexo.io/zh-cn/docs/)
- [Hexo家目录结构](https://hexo.io/zh-cn/docs/setup)
- [Hexo根配置详解](https://hexo.io/zh-cn/docs/configuration)
- [Hexo生成器简述](https://hexo.io/zh-cn/docs/generating)

**下面着重讲讲所谓的生成器**：这其实就是`Hexo`框架在安装后，在`HEXO_HOME`目录下，快速生成静态页面目录的命令。这个操作是如此简单，以至于一共只有两个命令，就可完成重新生成的逻辑：
```bash
/usr/bin/hexo clean
/usr/bin/hexo generate
```
之后，如果配置和模块没有异常的话，生成器就会在`$HEXO_HOME/public/`下生成博客所需要的**所有静态页面和依赖文件**。但是需要注意的是，假如你通过类似`Apache2`、`Nginx`这类的负载均衡器来作为你的服务端口进程，那么在`site-available`的配置文件中，请尽可能不要直接把`$HEXO_HOME/public/`作为你的`web服务`的根目录。因为这样的话在页面重生成期间，会短暂的导致页面的显示异常。更加合适的方式是单独使用一个其他位置的目录，然后每一次在生成新版本的页面之后，通过`rsync`或者`cp`等命令，把新版的页面内容覆盖过去，这样可以大幅缩短博客的不可用时间。例如这样：
```bash
cp -r $HEXO_HOME/public/* /var/www/hexo/public/
```

### **HTTPS和CertBot**
拥有了自己的博客以后，我们还是需要稍微为自己的博客的安全性负责的。这里并不是说这个博客有什么流量吸引歹人来攻击，而是关闭`HTTP 80`访问、强制`HTTPS 443`访问、使用全球授信的证书链作为`SSL证书`，是任何一个网站搭建过程中**最最最根本的基本常识**。是的，这里在**明示**我国大量政企事业单位的IT从业者（或部门的领导）是缺乏基本常识的（乐）。

相对于企业级昂贵的`SSL证书`，其实个人对于证书的选择面非常广阔且廉价。在完成页面的部署之后，假如你使用的是`Apache2`、`Nginx`这种主流的负载均衡，那么完全可以用`CertBot`来进行一键自动HTTPS配置、证书签发和部署，非常非常方便。此处以`Nginx`为例：

```bash
# Install essential packages.
$~ sudo apt install certbot python3-certbot-nginx

# Edit nginx config files.
$~ sudo nano /etc/nginx/sites-available/example.com
#Find the existing server_name line. It should look like this:
#/etc/nginx/sites-available/example.com
#...
#server_name example.com www.example.com;
#...

# Check Nginx config syntax errors.
$~ sudo nginx -t

# Reload Nginx config
$~ sudo systemctl reload nginx

# Check firewall rules if it is running.
$~ sudo ufw status

# Change rules to allos both http/https access.
$~ sudo ufw allow 'Nginx Full'
$~ sudo ufw delete allow 'Nginx HTTP'

# Start obtaining an SSL certificate.
$~ sudo certbot --nginx -d example.com -d www.example.com
#Please follow the guidance from certbot to finish all the steps.

# Check ssl auto renew status.
$~ sudo systemctl status certbot.timer
#You are supposed to see output like this.
#● certbot.timer - Run certbot twice daily
#     Loaded: loaded (/lib/systemd/system/certbot.timer; enabled; vendor preset: enabled)
#     Active: active (waiting) since Mon 2020-05-04 20:04:36 UTC; 2 weeks 1 days ago
#    Trigger: Thu 2020-05-21 05:22:32 UTC; 9h left
#   Triggers: ● certbot.service

#To test the renewal process, you can do a dry run with certbot:
$~ sudo certbot renew --dry-run
```
完成上面一系列命令以后，正常情况下代理`Hexo`静态页面的负载均衡服务，已经设置了有效的SSL证书，并且会不断的自动更新`SSL证书`，同时负载均衡的`HTTP 80`端口，也会被强制rewrite到`HTTPS 443`端口提供服务。

题外话，如果你想拥有一个有效期更长的个人证书，其实`CloudFlare`提供了长达15年的个人证书供免费用户下载，只能说强者恐怖如斯。

### **GitHub Action和自动化**
**我是个懒狗。** 所以我喜欢在尽可能少的页面完成博客的写作。

我喜欢`MarkDown`和`LaTeX`这样的标记式语言所带来的内容和排版的确定性，当然，`LaTeX`写起来有点点麻烦，所以常规情况下`MarkDown`是博客写作的不二之选。如果可以，我希望能够以这样的方式来进行博客的写作和发布：
1. 在任意我喜欢的代码编辑器中，进行可以`Preview`的`MarkDown`文档编辑。
2. 在完成任意文档、草稿、`CSS`和`EJS`调整之后，只需要一个简单的命令，就可以在远程的服务器和对象存储中，生成、发布并更新博客内容。

由于目前这个博客的代码托管在了`GitHub`上，所以最简单的方法就是直接使用`GitHub Action`来作为自动化的方案。事实上现代的代码托管平台，例如`GitHub`、`GitLab`、乃至于`Azure`这样的云服务，对`CICD Pipeline`的支持都已经非常出色了，任何有稍许计算机知识的人都可以快速搭建自己的`CICD`工作流。

那么言归正传，在这个博客搭建的一开始，我就写好了对应的`GitHub Action`，当时写的时候主要是两个目标：
- 不引入第三方的容器镜像，原因是我不想再审一遍别人的`dockerfile`，而且引入镜像会让`Action`很慢。
- 尽量少的`Step`，这样无论是`debug`还是执行都会很简单。

因此，在这个工作流中，只使用了官方`ubuntu-latest`作为运行镜像。以下便是本博客在使用的`GitHub Action Workflow`：
```yml
name: Publish Blog
on: [push, pull_request]
jobs:

  build:
    name: "Publish My Blog"
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/master'
    # needs: test
    steps:
      - name: Configure SSH
        run: |
          mkdir -p ~/.ssh/
          echo "$SSH_KEY" > ~/.ssh/kivinsae.key
          chmod 600 ~/.ssh/kivinsae.key
          chmod 700 ~/.ssh
          cat >>~/.ssh/config <<END
          Host kivinsae-blog
            HostName $SSH_HOST
            User $SSH_USER
            Port 22
            IdentityFile ~/.ssh/kivinsae.key
            StrictHostKeyChecking no
          END
        env:
          SSH_USER: ${{ secrets.KIVINSAE_BLOG_USERNAME }}
          SSH_KEY: ${{ secrets.KIVINSAE_BLOG_RSAKEY }}
          SSH_HOST: ${{ secrets.KIVINSAE_BLOG_HOST }}

      - name: Make the public_sync script could be executed.
        run: ssh kivinsae-blog 'chmod +x /opt/hexo/public_sync.sh'

      - name: Executing remote ssh commands to republish blog
        run: ssh kivinsae-blog '/usr/local/bin/public_sync'
```
实质上，这个工作流一共只有一个`step`，三个任务。分别是：
- 初始化容器，配置容器的`ssh rsa私钥`和`.ssh`目录权限，配置目标服务器信息。
- 确保远程服务器上的更新脚本拥有可执行权限。
- 远程执行服务器上的自动更新、清理、`Hexo`生成脚本。

同时，工作流文件声明了只有在`push`到主分支，或者`PR`到主分支的前提下，才会触发运行。

通过这样的工作流，我只需要在本地`IDE`进行文档的书写和编辑，然后通过`COMMIT_MASTER`脚本进行主分支推送就可以了。然后在10-20秒后，我的博客就会**无感且自动地**更新所有新编辑的内容。而且我可以确保所有的变更，都是通过版本管理进行跟踪的，永远不需要担心任何一个修改发生在了自己想不起来的地方。

### **防火墙问题**
由于**一些众所周知的问题**，绝大多数脑回路正常的工程师都不会把自己博客服务器的本体放在中国大陆。但是大量的海外机房由于**另一个众所周知的原因**，国内直接访问是会有很大的问题的。所以这个月我花了一些时间来处理从中国大陆访问这个博客的问题。

这个时候，`Hexo`的静态页面的好处就体现出来了。我不希望花不必要的服务器费用在国内重新搭建一个镜像服务器，同时我也希望国内的访问能够保持稳定快速。那么这个时候，阿里云海外地域的`OSS`的静态网站托管服务似乎成了一个最佳的选择，因为阿里云的海外节点只要你不作死是基本不会被墙的，算是一个非常好的选择。

说到阿里云OSS静态网站托管，具体的部署方式可以参阅[这篇文章](https://help.aliyun.com/document_detail/31872.html)。其本质上就是阿里在`OSS`的基础上为用户额外提供了一层负载均衡代理，同时用户还可以白嫖阿里云`OSS`加速节点的全球加速效果（严格来说是要钱的，但是考虑个人站点的一丝丝流量，**约等于不要钱**）

而我这边其实只需要在自动生成脚本的最后面增加一行命令，就可以完成这个节点的同步：
```bash
ossutil64 sync /var/www/hexo/public/ oss://<bucket_name>/ --delete --force
```
利用阿里云提供的`ossutil64`工具，我们可以非常方便把本地静态页面目录的所有内容同步到`OSS`上，并立刻生效。至此，我的博客的全部部署问题已经全部解决。下面是一张架构图，有助于读者更好理解这个架构的拓扑结构：

<img src="https://kivinsae-blog.oss-accelerate.aliyuncs.com/blog_images/2022-06-14-Talk_about_Blog_CH03_01.drawio-fs8.png" width="480">

## **插件的选择和优化**
`Hexo`拥有相当数量的插件开发者，因此`Hexo`的插件选择是很丰富的。不过我个人还是遵循了就简原则，尽量少的引入第三方插件，以下为目前的插件列表：
```json
"hexo-bilibili-card": "^0.6.0",
"hexo-blog-encrypt": "^3.1.6",
"hexo-renderer-ejs": "^2.0.0",
"hexo-renderer-markdown-it": "^6.0.1",
"hexo-ruby-character": "^1.0.6",
"hexo-theme-landscape": "^0.0.3",
"nodejieba": "^2.6.0",
"valine": "^1.4.18"
```

其中`hexo-bilibili-card`、`hexo-blog-encrypt`、`hexo-ruby-character`的效果可以在 **[Hexo Blog plugins test field](https://www.kivinsae.com/2018/07/23/2018-07-23-Hexo_Plugin_TestField/)** 中查看，分别用于页面内容的丰富化呈现。

`hexo-renderer-ejs`为`Hexo`默认主题`landscape`自带的ejs解析插件。`hexo-renderer-markdown-it`为`MarkDown`解析加强插件。`hexo-theme-landscape`为`Hexo`默认主题本身。`nodejieba`为中文分词函数库。

需要着重讲一下是评论插件`valine`，具体的插件介绍和安装指南可以参考 **[Valine官网](https://valine.js.org/)** 。随着韩国几款主流的论坛评论插件例如`livere`之流对网络的要求愈发变态，而`Gitalk`又是需要评论者登录`GitHub`的，这些插件的使用变得越来越麻烦，无论是对博主还是访问者来说。

目前看来，`valine`算是中文博客目前相对更好的一个评论插件选择了。但是诡异的是，`valine`本身的插件配置中，`CDN`却选择了墙外的服务，因此墙内用户在访问装有`valine`插件的页面的时候，很可能会遇到加载极慢的问题。所以，对于这个插件我是做了一些优化的。在当前使用的主题的`_config.yml`中找到`valine`对应的配置块，额外添加一条子配置`valine`并按照如下面格式添加`jsdelivr`的`CDN`加速地址即可。
```
valine:
  valine: //cdn.jsdelivr.net/npm/valine@1.4.18/dist/Valine.min.js  #为了cd加速
  enable: true
```
按照官网的指引流程和上面的优化方法进行配置之后，博客的所有评论都将存储到`LeanCloud`的服务实例中，并且拥有相当不错的加载速度。

## **CSS样式调整和EJS修改**
这里的调优其实很多时候是出于对`landscape`这个默认皮肤的无奈。`Hexo`毕竟还是一个开源项目，在这段时间的使用过程中，还是发现了很多其本身的问题。好在应对方法也不复杂，只要对`html`、`css`和`JavaScript`有最低限度的了解和语法知识就可以轻松解决。

### **折叠块的渲染**
首先是`<details>`语法块的问题，`Hexo`对折叠内容的默认渲染可以说用惨绝人寰来形容，就是压根没有css式样，所以当博客需要使用折叠快的时候，我们需要手动添加一些关于折叠块的属性来确保视觉上勉强能看：
```html
<details style="box-shadow: 2px 2px 5px; border-radius: 6px; padding: .5em .5em .5em;">
    <summary><b>【鬼谷说】菊石（其一）：旧神的涅槃</b></summary>
    <div style="position: relative; padding-bottom: 75%; height: 0;">
        <iframe width="600" height="450" src="https://player.bilibili.com/player.html?aid=597067931&bvid=BV16B4y1X7ap&cid=734651916&page=1&high_quality=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
    </div>
    <br>
</details>
```
具体的呈现就会是这样一个效果。虽然依然很丑，但是至少能看。
<details style="box-shadow: 2px 2px 5px; border-radius: 6px; padding: .5em .5em .5em;">
    <summary><b>【鬼谷说】菊石（其一）：旧神的涅槃</b></summary>
    <div style="position: relative; padding-bottom: 75%; height: 0;">
        <iframe width="600" height="450" src="https://player.bilibili.com/player.html?aid=597067931&bvid=BV16B4y1X7ap&cid=734651916&page=1&high_quality=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
    </div>
    <br>
</details>
<br>

### **Tags和Categories页面支持**
非常糟心的一件事是，`landscape`主题似乎没有对`Tags`和`Categories`的根页面进行`ejs`的支持。如果用户单纯地跟着官方文档通过`hexo命令行`创建一个`source/tags/index.md`或者`source/categories/index.md`页面的话，在博客中其实是无法正常显示的。而在主题的`layout`目录中，原始的`tag.ejs`和`category.ejs`又被其他页面功能调用，所以，尽可能不要随意修改它们。

那么，为了让博客在`landscape`主题中可以正常显示`Tags`和`Categories`页面，我在`layout`目录下需要额外创建两个`ejs`模板文件，用于让这两个页面可以正常渲染和呈现，代码如下：

```js
<!-- node_module/hexo-theme-landscape/layout/tags.ejs -->
<article id="post" class="article article-type-post" itemscope itemprop="blogPost">
  <div class="article-inner">
      <header class="article-header">
        <h1 class="article-title" itemprop="name">
          <%= page.title %>
        </h1>
      </header>
    <div class="article-entry" itemprop="articleBody">
      <% if (site.tags.length){ %>
        <%- list_tags({show_count: true}) %>
      <% } %>
    </div>
  </div>
</article>
```

```js
<!-- node_module/hexo-theme-landscape/layout/categories.ejs -->
<article class="article article-type-post show">
  <div class="article-inner">
    <header class="article-header">
      <h1 class="article-title" itemprop="name">
        <%= page.title %>
      </h1>
    </header>
    <div class="article-entry" itemprop="articleBody">
      <% if (site.categories.length){ %>
        <%- list_categories(site.categories, {
          show_count: true,
          class: 'category',
          style: 'list',
          depth: 3,
          separator: ''
        }) %>
      <% } %>
    </div>
  </div>
</article>
```
在添加了上述ejs模板后，只要在`source/tags/index.md`或者`source/categories/index.md`中分别添加对应的`layout`配置即可：

```
# source/tags/index.md
---
title: 𝑩𝒍𝒐𝒈 𝑻𝒂𝒈𝒔
date: 2022-06-14 10:00:13
layout: tags
comments: false
---
```

```
# source/categories/index.md
---
title: 𝑩𝒍𝒐𝒈 𝑪𝒂𝒕𝒆𝒈𝒐𝒓𝒊𝒆𝒔
date: 2022-06-14 10:00:13
layout: categories
comments: false
---
```
之后修改`node_module/hexo-theme-landscape/_config.yml`，在顶部菜单栏中添加对应的页面路径，然后重新生成页面后，就可以在博客中访问正常的`Tags`和`Categories`页面了。


---
**以上就是关于本博客建设的简要技术说明，未来如果有时间我会更新一些关于博客建设的细节和Hexo本身调优的心得。** 

*感谢阅读*
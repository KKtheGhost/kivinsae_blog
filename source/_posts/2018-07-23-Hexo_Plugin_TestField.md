---
title: Hexo Blog plugins test field
date: 2018-07-23 00:00:00
tags: 
- ENG
- Test
- 博客
- Hexo
- Plugins
---
## **hexo-bilibili-card**
![](https://nodei.co/npm/hexo-bilibili-card.png)

一个Hexo插件，在你的文章中插入b站的视频卡片，样式模仿和借鉴自b站。
- **Type 1**
<p>
{% bilicard BV1hY4y1Y7g7 %}
</p>

- **Type 2**
<div class="article-youtube-container">
    <iframe src="//player.bilibili.com/player.html?aid=60016166&cid=104514776&page=1&danmaku=0" allowfullscreen="allowfullscreen" width="560" height="315" scrolling="no" frameborder="0" sandbox="allow-top-navigation allow-same-origin allow-forms allow-scripts"></iframe>
</div>

## **hexo-blog-encrypt**
![](https://nodei.co/npm/hexo-blog-encrypt.png)

- 首先, 这是 Hexo 生态圈中 最好的 博客加密插件
- 你可能需要写一些私密的博客, 通过密码验证的方式让人不能随意浏览.
- 这在 wordpress, emlog 或是其他博客系统中都很容易实现, 然而 hexo 除外.
- 可以在这里看到[测试页面](https://kivinsae.com/2018/07/23/2018-07-23-Hexo_encrypt_test)

## **hexo-ruby-character**
![](https://nodei.co/npm/hexo-ruby-character.png)

- `{% ruby 佐天泪子|掀裙狂魔 %}` → {% ruby 佐天泪子|掀裙狂魔 %}
- `{% ruby 超電磁砲|レールガン %}` → {% ruby 超電磁砲|レールガン %}

## **YouTube iframe showcase test**
<div class="article-youtube-container">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/F57P9C4SAW4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

---
**End of Test**
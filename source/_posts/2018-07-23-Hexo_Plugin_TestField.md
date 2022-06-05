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
{% bilicard BV16B4y1X7ap %}
</p>

- **Type 2**
<details>
    <summary>【鬼谷说】菊石（其一）：旧神的涅槃</summary>
    <div style="position: relative; padding-bottom: 75%; height: 0;">
        <iframe width="600" height="450" src="https://player.bilibili.com/player.html?aid=597067931&bvid=BV16B4y1X7ap&cid=734651916&page=1&high_quality=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
    </div>
</details>

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
<details>
	<summary>
		<span class="summary-title">Katy Perry - Firework (Official Music Video)</span>
		<div class="summary-chevron-up">
			<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-chevron-down"><polyline points="6 9 12 15 18 9"></polyline></svg>
		</div>
	</summary>
    <div class="summary-content"> 
        <div style="position: relative; padding-bottom: 56.25%; height: 0;">
            <iframe width="560" height="315" src="https://www.youtube.com/embed/QGJuMBdaqIw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
        </div>
    </div>
	<div class="summary-chevron-down">
		<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-chevron-up"><polyline points="18 15 12 9 6 15"></polyline></svg>
		
</details>

<details>
    <summary>Katy Perry - Firework (Official Music Video)</summary>
    <div style="position: relative; padding-bottom: 56.25%; height: 0;">
        <iframe width="560" height="315" src="https://www.youtube.com/embed/QGJuMBdaqIw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></iframe>
    </div>
</details>

---
**End of Test**
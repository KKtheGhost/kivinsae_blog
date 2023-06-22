const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');
const { convert } = require('xml-js');

// 读取 ./posts 目录下的所有文件
const postsDir = path.join(__dirname, 'posts');
const files = fs.readdirSync(postsDir);

// 按照文件名中的日期排序文件
const sortedFiles = files.sort((a, b) => {
  const dateA = new Date(a.split('-')[0]);
  const dateB = new Date(b.split('-')[0]);
  return dateB - dateA;
});

// 获取最近三篇博文
const recentFiles = sortedFiles.slice(0, 3);

// 创建 Atom feed 的 DOM
const { document } = new JSDOM().window;
const feed = document.createElement('feed');
feed.setAttribute('xmlns', 'http://www.w3.org/2005/Atom');

// 添加 feed 的 metadata
const title = document.createElement('title');
title.textContent = 'Your Blog Title';
feed.appendChild(title);

const link = document.createElement('link');
link.setAttribute('href', 'https://example.com/');
link.setAttribute('rel', 'self');
feed.appendChild(link);

const updated = document.createElement('updated');
updated.textContent = new Date().toISOString();
feed.appendChild(updated);

// 添加最近三篇博文的条目
recentFiles.forEach((file) => {
  const filePath = path.join(postsDir, file);
  const fileContent = fs.readFileSync(filePath, 'utf-8');

  const entry = document.createElement('entry');

  const entryTitle = document.createElement('title');
  const entryTitleText = fileContent.match(/<title>(.*?)<\/title>/)[1];
  entryTitle.textContent = entryTitleText;
  entry.appendChild(entryTitle);

  const entryLink = document.createElement('link');
  entryLink.setAttribute('href', `https://example.com/posts/${file}`);
  entry.appendChild(entryLink);

  const entryUpdated = document.createElement('updated');
  entryUpdated.textContent = new Date(file.split('-')[0]).toISOString();
  entry.appendChild(entryUpdated);

  const entryContent = document.createElement('content');
  entryContent.textContent = fileContent;
  entry.appendChild(entryContent);

  feed.appendChild(entry);
});

// 将 DOM 转换为 XML 字符串
const feedXML = convert(feed, { compact: true, spaces: 4 });

// 将生成的 Atom feed 保存到 atom.xml 文件
const outputFile = path.join(__dirname, 'atom.xml');
fs.writeFileSync(outputFile, feedXML, 'utf-8');

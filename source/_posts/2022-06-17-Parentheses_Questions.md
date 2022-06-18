---
title: LeetCode 括号问题详解
date: 2022-06-17 18:45:22
categories:
- [LeetCode,LeetCode思路详解（C）]
tags: 
- CHN
- 编程
- LeetCode
- C
---
如果经常刷`LeetCode`的话，其实应该会对有一道题目印象非常深刻。那就是括号问题 **[[20] Valid Parentheses](https://leetcode.com/problems/valid-parentheses/description/)** 。第一次看到这道题的话多少都会楞一下，因为乍一看题目内容非常的简单，无非是判断括号闭合的合法与否，但是仔细想想其实也有不少坑。尽管这道题是`LeetCode`中序号最小的堆栈问题，但是第一次做不一定能反应过来是堆栈。

这类题在`LeetCode`中一共有三道。分别是：
- **[[20] Valid Parentheses](https://leetcode.com/problems/valid-parentheses/description/)** <font color=Green><b>Easy</b></font>
- **[[921] Minimum Add to Make Parentheses Valid](https://leetcode.com/problems/minimum-add-to-make-parentheses-valid/description/)** <font color=Orange><b>Medium</b></font>
- **[[1541] Minimum Insertions to Balance a Parentheses String](https://leetcode.com/problems/minimum-insertions-to-balance-a-parentheses-string/description/)** <font color=Orange><b>Medium</b></font>

但是很离谱的是，我个人做下来的感觉 **[[20] Valid Parentheses](https://leetcode.com/problems/valid-parentheses/description/)** 才是<font color=Orange><b>Medium</b></font>的难度，剩下两道毫无疑问是<font color=Green><b>Easy</b></font>难度的， 甚至它们因为太简单可能做的时候不一定能直观感受到堆栈的思想。当然，后两题如果追求极限的低复杂度（比如**O(1)**）的话，还是很有挑战的。

还是来聊聊这类题目的基本思路吧，这里先以 **[[20] Valid Parentheses](https://leetcode.com/problems/valid-parentheses/description/)** 为例。其实基本思路不复杂，如果你理解堆栈的概念，其实一瞬间就能想明白是怎么一回事情。
```
+────+────+────+────+────+────+
| {  | [  | (  | (  | [  | (  |  <-- ')' Accept
+────+────+────+────+────+────+
|   +────+────+────+────+────+────+
--> | {  | [  | (  | (  | [  | X  |  <-- '('&')' Clear
    +────+────+────+────+────+────+
+────+────+────+────+────+────+
| {  | [  | (  | (  | [  | (  |  <-- ']' Dismatch
+────+────+────+────+────+────+
```
从上图可以看到对于每一个左括号，我们都按照顺序（先进后出，后进先出）放入堆栈中。但是对于右括号，我们要做的是两个核心步骤：
1. 将其和堆栈**最上层的那个左括号**进行对比，如果成对，则安全**匹配**。
2. 完成匹配后，将这个最上层的左括号**消掉**。然后如此循环往复，如果能够消除干净，则字符串`Syntax`合法。

从上面两个步骤又可以分别写出两个对应的逻辑，对于步骤一，所谓的对比就是**对右括号本身取对应的左括号**：
```c
char left(char c) {
    if (c == 41) {return 40;}
    else if (c == 93) {return 91;}
    else {return 123;}
}
```
对于步骤二，只需要对整个输入的字符串进行逐字对比，并不停调用步骤一的`left(char c)`。
```c
for (int i = 0; i < len; ++i) {
    if (s[i] == 40 || s[i] == 91 || s[i] == 123) {++idx; status[idx] = s[i];}
    else {
        if (left(s[i]) == status[idx]) {--idx;}
        else {return false;}
    }
}
```
将两个函数进行拼合，并对边界情况进行处理之后，便是 **[[20] Valid Parentheses](https://leetcode.com/problems/valid-parentheses/description/)** 的答案了（个人习惯用数字替代`ascii`码的对比）：
```c
char left(char c) {
    if (c == 41) {return 40;}
    else if (c == 93) {return 91;}
    else {return 123;}
}

bool isValid(char * s){
    int len=strlen(s);
    if (len == 1) {return false;}
    int *status = (int *)malloc(sizeof(int) * 10001);
    memset(status, 0, 10001);
    int idx = 0;

    for (int i = 0; i < len; ++i) {
        if (s[i] == 40 || s[i] == 91 || s[i] == 123) {++idx; status[idx] = s[i];}
        else {
            if (left(s[i]) == status[idx]) {--idx;}
            else {return false;}
        }
    }
    bool res;
    return res = (idx == 0) ? true : false;
}
```
其实这类括号题目，最重要就是第一时间要意识到是堆栈的思路，其次是需要对括号字符串有取左或者取右的直觉。这样其实就可以超快速解题了。

下面来看看另外两道标注了<font color=Orange><b>Medium</b></font>，实则更简单的括号类问题。

先以 **[[921] Minimum Add to Make Parentheses Valid](https://leetcode.com/problems/minimum-add-to-make-parentheses-valid/description/)** 为例，这道题真的不知道是怎么被评定为<font color=Orange><b>Medium</b></font>的，其实这里本质就两种情况：`入栈的是左括号` & `入栈的是右括号`。对于`入栈的是左括号`的情况，用一个状态变量`status`记录一下还欠缺右括号的数量。对于`入栈的是右括号`，如果左括号还有结余，也就是`status > 0`，直接进行堆栈抵消；对于左括号没有结余的情况，就必须让左括号进行增补，也就是`++res;`。事实上这已经是一个一维堆栈了，而 **[[20] Valid Parentheses](https://leetcode.com/problems/valid-parentheses/description/)** 至少还是一个二维堆栈。
```c
int minAddToMakeValid(char * s){
    int len = strlen(s), status = 0, res = 0;
    for (int i = 0; i < len; ++i)
    {
        if (s[i] == 40) {++status;}
        else {
            if (status > 0) {--status;}
            else {++res;}
        }
    } 
    return res + status;
}
```

接下来我们再来聊聊 **[[1541] Minimum Insertions to Balance a Parentheses String](https://leetcode.com/problems/minimum-insertions-to-balance-a-parentheses-string/description/)**。这道题完完全全就是 **[[921] Minimum Add to Make Parentheses Valid](https://leetcode.com/problems/minimum-add-to-make-parentheses-valid/description/)** 的轻度升级版。唯一区别是把 `(` & `)` 的括号对异化为了 `(` & `))` 。这就意味着我们需要多做一件事情：**把字符串先还原为Q921中的字符串，然后执行Q921的解法即可**。这真的称不上是<font color=Orange><b>Medium</b></font>难度。

需要新增的格式化步骤如下，主要是增加了对于单个右括号的增补处理，需要注意**单个右括号在字符串最末尾的特殊情况**：
```c
for (int i=0,j=0; i < len; ++i, ++j) {
    if (s[i] == 40) {new[j] = s[i];}
    else {
        if (i != len - 1 && s[i + 1] == 41) {new[j] = ')'; ++i;} 
        else {new[j] = ')'; ++res;}
    }
}
```
然后把格式化步骤和 **[[921]](https://leetcode.com/problems/minimum-add-to-make-parentheses-valid/description/)** 的答案结合一下，即为 **[[1541]](https://leetcode.com/problems/minimum-insertions-to-balance-a-parentheses-string/description/)** 的正确解法：
```c
int minInsertions(char * s){
    int res = 0,len = strlen(s);
    char *new = (char *)malloc(sizeof(char) * 3 * len);
    memset(new, '\0', 3*len);

    for (int i=0,j=0; i < len; ++i, ++j) {
        if (s[i] == 40) {new[j] = s[i];}
        else {
            if (i != len - 1 && s[i + 1] == 41) {new[j] = ')'; ++i;} 
            else {new[j] = ')'; ++res;}
        }
    }
    int i = 0, status = 0;
    while (new[i] != '\0')
    {
        if (new[i] == 40) {++status;}
        else {
            if (status > 0) {--status;}
            else {++res;}
        }
        ++i;
    }
    
    return res + status*2;
}
```

<font color=Green><b>总结：</b></font> 这类括号问题的关键是什么相信也比较明了了，其实就是堆栈思路。无论是 **[[20]](https://leetcode.com/problems/valid-parentheses/description/)** 的二维堆栈，还是后面两道题目的一维堆栈，其实本质是一样的。而难度本身也至多围绕其他方面展开，比如增加字符串预处理之类的。不过还是有点期待会不会在未来出现三维的堆栈。
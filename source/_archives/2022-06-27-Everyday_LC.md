---
title: LeetCode Daily Challenge 2022-06-27 (No. 1689)
date: 2022-06-27 11:30:00
categories:
- [LeetCode,Daily Challenge]
tags: 
- ENG
- LeetCode
- C
---
Today's Daily Challenge is **[1689. Partitioning Into Minimum Number Of Deci-Binary Numbers](https://leetcode.com/problems/partitioning-into-minimum-number-of-deci-binary-numbers/description/)** <font color=Orange><b>MEDIUM</b></font>. This question is pretty easy. To be honest, it's just a logical test.

```
Accepted
97/97 cases passed (12 ms)
Your runtime beats 80.62 % of c submissions
Your memory usage beats 63.57 % of c submissions (7.8 MB)
```

### **Let's do some brief explanation:**
Actually this question is an extremely free case. **A number array contains only decimal numbers.** Which means that `ANY` Natural number `x` could be the Sum of `N` decimal numbers. And the `N` is the largest digits in `x`.

So the <font style="font-family:'Georgia'"><b>O(n)</b></font> would be:
```c
int minPartitions(char * n){
    int len = strlen(n);
    int i = 0, j = len - 1;
    int res = 0;
    while (i <= j)
    {
        res = (res < n[i] - '0')? n[i] - '0' : res;
        res = (res < n[j] - '0')? n[j] - '0' : res;
        if (res == 9) {return res;}
        i++;j--;
    }
    return res;
}
```
Thank u for reading.

---
- Time complexity : <font style="font-family:'Georgia'"><b>O(n)</b></font>
- Space complexity : <font style="font-family:'Georgia'"><b>O(1)</b></font>
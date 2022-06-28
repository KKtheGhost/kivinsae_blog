---
title: LeetCode Daily Challenge 2022-06-28 (No. 1647)
date: 2022-06-28 12:30:00
categories:
- [LeetCode,Daily Challenge]
tags: 
- ENG
- LeetCode
- C
---
Today's Daily Challenge is **[1647. Minimum Deletions to Make Character Frequencies Unique](https://leetcode.com/problems/minimum-deletions-to-make-character-frequencies-unique/description/)** <font color=Orange><b>MEDIUM</b></font>. This question is a little bit tricky. The **KEY** idea would be `reversed qsort()`.

```
Accepted
103/103 cases passed (22 ms)
Your runtime beats 93.33 % of c submissions
Your memory usage beats 70 % of c submissions (8.7 MB)
```

### **Let's do some brief explanation:**
**[1647](https://leetcode.com/problems/minimum-deletions-to-make-character-frequencies-unique/description/)** <font color=Orange><b>MEDIUM</b></font> has very clear steps to solve the question. 
- Count the exact number of every distinct digit.
- Sort them from largest to smallest.
- Calculate the number of the `char`s that should be deleted.

Being aware of the 3 **key steps**, we could start element deleting then. From the largest digit count in the reversed counts dictionary, every digit's count must be smaller than the former one:
- <font style="font-family:'Georgia'"><b>count[i] >= count[i+1] + 1</b></font>

---

**Let's create a reverse `cmp()` for `qsort()`:**
```c
int cmp(const void *a, const void *b) {
    return *(int*)b - *(int*)a;
}
```

**Then count each digit's number and sort it in reversed order:**
```c
for (int i = 0; i < len; ++i) {
    dict[s[i] - 'a']++;
}
qsort(dict, 26, sizeof(int), cmp);
```

**Finally, go through the digit counts dictionary `dict`, and analyse the sum of the `char`s that should be deleted. The solution would be:**
```c
int cmp(const void *a, const void *b) {
    return *(int*)b - *(int*)a;
}

int minDeletions(char * s){
    int len = strlen(s);
    int *dict = malloc(sizeof(int)*26); memset(dict, 0, sizeof(int)*26);
    
    for (int i = 0; i < len; ++i) {
        dict[s[i] - 'a']++;
    }
    
    qsort(dict, 26, sizeof(int), cmp);
    int res = 0;
    for (int j = 0; j < 25; ++j) {
        if (dict[j] == 0 && dict[j+1] == 0) {break;}
        if (dict[j + 1] >= dict[j] && dict[j + 1] > 0) {
            res += (dict[j] == 0)? dict[j + 1] : dict[j + 1] - dict[j] + 1;
            dict[j + 1] = (dict[j] == 0)? 0 : dict[j] - 1;
        }
    }
    return res;
}
```

Thank u for reading.

---
- Time complexity : <font style="font-family:'Georgia'"><b>O(n)</b></font>
- Space complexity : <font style="font-family:'Georgia'"><b>O(1)</b></font>
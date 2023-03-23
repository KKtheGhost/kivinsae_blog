---
title: LeetCode Q1-20 思路详解 (持续更新中)
date: 2022-06-10 23:30:22
categories:
- [leecode,leetcode_clang]
tags: 
- lang_chinese
- programming
- leetcode
- C
---
最近又开始了第 `?` 轮的`LeetCode`刷刷刷。怎么说呢，LC这个东西你说它功利，那肯定是绝对功利的。如果说这个世界上有什么东西的学习收益比英语还高的话，可能也就是只有LC了。尽管对于ACM狂人和算法猛汉来说，刷LC其实只是纯粹的休闲娱乐活动，就俗称**益智游戏**，可对于绝大多数的一般从业者来说，如果在LC能很稳定的Pass绝大多数的`EASY`和`MEDIUM`，以及部分`HARD`的话，已经足够让你够一下`FLAG`的门槛了。如果成为周赛弄潮儿，那Offer真的就是拒不过来里。

很遗憾，由于本人有限的智力，其实我觉得在面试这种有一定时限和压力的情况下，能稳定输出90% `EASY`和`MEDIUM`的伪代码的人，只要能流利听说英语，就已经有足够实力成为一个世界公民了。

所以，有什么理由不刷LC呢，即便仅仅作为饭后的益智娱乐，多数问题也足够有趣，更勿论`Submission Accepted`和`100% faster`带来的快感了。

言归正传，下面开始LC Q1-Q20的思路详解。这里我只讲自己的思路过程，尽可能做到通俗易懂吧。如果真的讲得不清楚，那确实就是水平有限，非常抱歉。
- 如果发现我的某个实现的复杂度不是最优，那很正常。是我的能力的问题。
- 如果发现有`HARD`被跳过了，理由同上
- 我会用C语言来刷，算是一种挑战。刚才最近在重新捡C。
- **这个系列我应该只会做` Q1 - Q100 `或者` Q1 - Q200 `的基础题。剩下题目的详解可能还是通过主题讲解的方式会更好。**

---
## **[No.1 Two Sum (两数之和)](https://leetcode.com/problems/two-sum/)**
`// @lc EASY`

**Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target. You may assume that each input would have exactly one solution, and you may not use the same element twice. You can return the answer in any order.**

首先这是一道简单题，那就不用怕。其次先看**题目和入参范围**：
- 一个数组，元素数量`2 <= nums.length <= 104`，元素和目标值范围都在`[INT_MIN, INT_MAX]`内。
- 一个目标值，数组里会有两个元素的和是这个目标值，有且只有一组。
- 以`[i1, i2]`的形式返回这两个元素在数组中的`index`

这种题目其实如果熟悉哈希表的话其实一眼就知道怎么搞了。每一个两两组合都在哈希表里对应一个值。然后快速遍历就好了。但是C语言没有现成可以用的哈希表，我也不想手撸一个，直接暴利破解。反正目的是刷题的快感。
```c
int* twoSum(int* nums, int numsSize, int target, int* returnSize){
    *returnSize = 2; 
    /* 返回数组包含两个int，所以size是2 */
    int *Res = malloc((*returnSize) * sizeof(int)); 
    /* malloc一个内存空间，用来存返回值 */
    /* 额外提一嘴，LeetCode用C的时候会自动帮你free，所以尽管calloc或malloc就行 */

    for (int i = 0; i < numsSize; ++i) { 
    /* 第一个元素，从index=0开始 */
        for (int j = numsSize - 1; j > i; --j) { 
        /* 第二个元素，稍微暴利得灵活一点，j > i 防止重复遍历 */
            if (nums[i] + nums[j] == target) { 
            /* 一旦符合结果直接写入返回结果数组里，然后goto到循环外返回 */
                Res[0] = i;
                Res[1] = j;
                goto end;
            }
        }
    }

    end:return Res;
}
```

## **[No.16 Two Sum (最接近的三数之和)](https://leetcode.com/problems/two-sum/)**
`// @lc MEDIUM`

**Given an integer array nums of length n and an integer target, find three integers in nums such that the sum is closest to target.
Return the sum of the three integers.
You may assume that each input would have exactly one solution.**

这道题和`Q15`其实几乎没有什么区别，对于这种三数之和的问题，基本思路直接就是三个`index`遍历问题。为了防止重复遍历增加运行时间，一个比较取巧的方式是增加一个左侧`index`的单增限制。与此同时，为了确保`middle`和`right`的两个`index`的移动是可控严谨的，需要在对整个`nums`数列进行遍历前，首先进行排序。因此和`Q15`一样，我们需要对C语言`<stdlib.h>`标准库中的 **[qsort()](https://www.tutorialspoint.com/c_standard_library/c_function_qsort.htm)** 函数非常了解。除此以外，本题没什么需要特别注意的边界陷阱。

那么直接看代码的注释吧：
```c
/* qsort()的$4是有固定写法的，就是下面这个compare函数 */
int compare(const void *a, const void *b)
{
    return *(int*)a - *(int*)b;
}
/* 正式的算法部分 */
int threeSumClosest(int* nums, int numsSize, int target){
    /* numsSize == 3 特殊情况 */
    if (numsSize ==  3) {return nums[0]+nums[1]+nums[2];}
    /* 此处需要给res赋予一个大于target最大值的初始值即可 */
    int res = 9999,middle,right;
    /* 数组qsort排序预处理 */
    qsort(nums, numsSize, sizeof(nums[0]), compare);
    /* left index遍历 */
    for (int i = 0; i < numsSize - 2; ++i) {
        /* 设定middle index和right index的初始值 */
        middle = i + 1;
        right = numsSize - 1;
        /* 设置第二层遍历的终止条件，本质是把O(n*2)降低到O(n) */
        while (middle < right)
        {
            int sum = nums[i] + nums[middle] + nums[right];
            /* 因为数组经过qsort，所以sum大于target则right index左移。 */
            if (sum > target)
                right--;
            /* 因为数组经过qsort，所以sum小于target则middle index右移。 */
            else if (sum < target)
                middle++;
            /* 特殊情况，如果sum等于target了，直接结束遍历，goto返回结果。 */
            else {res = target; goto end;}
            /* 常规判断：如果sum更接近target，则更新res的值 */
            res = (abs(sum - target) < abs(res - target)) ? sum : res;
        }
    }
    end:;
    return res;
}
```
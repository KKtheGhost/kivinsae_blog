---
title: LeetCode Q1-20 思路详解 (持续更新中)
date: 2022-06-10 23:30:22
tags: 
- CHN
- 编程
- LeetCode
- Go
---
最近又开始了第 `?` 轮的`LeetCode`刷刷刷。怎么说呢，LC这个东西你说它功利，那肯定是绝对功利的。如果说这个世界上有什么东西的学习收益比英语还高的话，可能也就是只有LC了。尽管对于ACM狂人和算法猛汉来说，刷LC其实只是纯粹的休闲娱乐活动，就俗称**益智游戏**，可对于绝大多数的一般从业者来说，如果在LC能很稳定的Pass绝大多数的`EASY`和`MEDIUM`，以及部分`HARD`的话，已经足够让你够一下`FLAG`的门槛了。如果成为周赛弄潮儿，那Offer真的就是拒不过来里。

很遗憾，由于本人有限的智力，其实我觉得在面试这种有一定时限和压力的情况下，能稳定输出90% `EASY`和`MEDIUM`的伪代码的人，只要能流利听说英语，就已经有足够实力成为一个世界公民了。

所以，有什么理由不刷LC呢，即便仅仅作为饭后的益智娱乐，多数问题也足够有趣，更勿论`Submission Accepted`和`100% faster`带来的快感了。

言归正传，下面开始LC Q1-Q20的思路详解。这里我只讲自己的思路过程，尽可能做到通俗易懂吧。如果真的讲得不清楚，那确实就是水平有限，非常抱歉。
- 如果发现我的某个实现的复杂度不是最优，那很正常。是我的能力的问题。
- 如果发现有`HARD`被跳过了，理由同上
- 我会用C语言来刷，算是一种挑战。刚才最近在重新捡C。

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
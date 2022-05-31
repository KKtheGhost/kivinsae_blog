---
title: A Simple explanation about 312.Burst Balloons
date: 2022-01-01 02:10:22
tags: 
- 编程
- LeetCode
- Go
---
As the first daily LeetCode problem in 2022, [burst ballons](https://leetcode.com/problems/burst-balloons/) acted like a true challange for most of people. So the question is, where did the difficulties come from. In this blog, I will briefly explain it.

We should firstly read the problem description.

<font color=Grey>You are given `n` balloons, indexed from `0` to `n - 1`. Each balloon is painted with a number on it represented by an array `nums`. You are asked to burst all the balloons.

If you burst the `ith` balloon, you will get `nums[i - 1] * nums[i] * nums[i + 1]` coins. If `i - 1` or `i + 1` goes out of bounds of the array, then treat it as if there is a balloon with a 1 painted on it.

Return the maximum coins you can collect by bursting the balloons wisely.</font>

Once we saw the word ‘maximum’, it could be a signal for DP solution. Which means there must be a simple DP prototype to solve the problem. But in burst ballons, things get quite complicated than usual. Cause the prototype is quite different from what you have in description and examples.

So let have a quick view of the example:

**Example 1:**
```
Input: nums = [3,1,5,8]
Output: 167
Explanation:
nums = [3,1,5,8] --> [3,5,8] --> [3,8] --> [8] --> []
coins =  3*1*5    +   3*5*8   +  1*3*8  + 1*8*1 = 167
```
**Example 2:**
```
Input: nums = [1,5]
Output: 10
```
Once you solved the problem, you’ll realize that prototype is actually displayed in Example1’s explanation. But people who face this problem for the first time may feel confused to find out the DP prototype, cause prototype should be un-related one by one, but the input nums works as a related structure when we burst the ballons. However, there’s a question:
- **Where do these “1” come from in the explanation?**

This is the **KEY POINT** for 312.Burst Ballons, in other words, the true prototype for the problem. Yes, we should add “1” to both the head and the tail of the given array. Then everything changed, the related structure turns into an un-related structure. The mathematical explanation maybe quite complex, but we can write the basic DP structure firstly.

```
i, k, j are indexes for numbers in array.
          dp[i][k]            dp[k][j]
     ┌─────────────────┐     ┌─────────┐
┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐
│ i │   │   │   │   │   │ k │   │   │   │ j │
└───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┘
      └────────────────────────────────┘
                  dp[i][j]
```
when `i = 0` and `j = len(nums)-1` , which means `nums[i] = 1` and `nums[j] = 1` , the ‘**maximum**’ of `dp[0][len(nums)-1]` is the answer we want. So every thing get quite clear, and we can write down the structure code with few borders bellow:
- The prototype is:
```
dp[i][j] = nums[i] * nums[k] * nums[j] + dp[i][k] + dp[k][j]
```
- **k ≥ i+1 && k < j**
- The head and the end of sub-array is continuously moving, k itselef is also moving, so there should be 3 for loops.

Then we can write down the DP Code structure:
```
func maxCoins(nums []int) int {
    // Add "1" to the head and end of origin array.
    balloms := append([]int{1}, nums...)
    balloms = append(balloms, 1)
    // Get the length of new array.
    lb := len(balloms)
    // Init DP structure of the problem.
    dp := make([][]int, lb)
    // Generation index structure of DP.
    for i := range(dp) { dp[i] = make([]int, lb) }
    // First for loop: start sub array with length i.
    for i := 2; i < lb; i++ {
        // Second for loop: moving head and end.
        for head := 0; head + i < lb; head ++ {
            max := 0
            end := head + i
            // Third loop: moving k
            for k := head + 1; k < end; k ++ {
                // ...Prototype...
                }
            }
        }
    }
    return dp[0][lb-1]
}
```
Then just add the prototype and maximum function into the DP structure code above to get your first Accepted of 2022~
```
res := balloms[head] * balloms[k] * balloms[end] + dp[head][k] + dp[k][end]
     if res > max {
           max = res
           dp[head][end] = max
     }
```
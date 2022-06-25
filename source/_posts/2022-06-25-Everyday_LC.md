---
title: LeetCode Daily Challenge 2022-06-25 (No. 665)
date: 2022-06-25 12:30:00
categories:
- [LeetCode,Daily Challenge]
tags: 
- ENG
- LeetCode
- C
---
Today's Daily Challenge is **[665. Non-decreasing Array](https://leetcode.com/problems/non-decreasing-array/)** <font color=Orange><b>MEDIUM</b></font>. This question is pretty easy but we should be very careful about the edge conditions.

```
Accepted
335/335 cases passed (27 ms)
Your runtime beats 91.67 % of c submissions
Your memory usage beats 33.33 % of c submissions (7.1 MB)
```

### **Let's do some brief explanation:**
Read the Constraints firstly:
- `n == nums.length`
- `1 <= n <= 104`
- `-105 <= nums[i] <= 105`

So the length would be bigger than 0. And the first edge condition would be `nums.length < 3`. Under this condition, you could **always** turn the array into increasing array by modifying at most one element.

<sup><b>Exp1</b></sup>Then we'll go forward and deal with the second edge condition: How to discriminate the special conditions below?
- `[... 5, 8, 4, 7, ...]`
- `[... 2, 3, 3, 2, 2, ...]`

These conditions are definitely `false` because you could never turn it into an increasing array by modifying at most one element.

Let's investigate these cases carefully:
- If `nums[i]` is **equal or smaller** than `nums[i+1]`, give it a `<sup>↑`, otherwise a `<sup>↓`.
- If `nums[i]` is **equal or smaller** `nums[i+2]`, give it a `<sub>↑`, otherwise a `<sub>↓`.

So the cases in **Exp1** could be written in this way:
- [ . . .  5<sup><b>↑</b></sup><sub><b>↓</b></sub>, 8<sup><b>↓</b></sup><sub><b>↓</b></sub>, 4<sup><b>↑</b></sup>, 7, . . . ]
- [ . . .  2<sup><b>↑</b></sup><sub><b>↑</b></sub>, 3<sup><b>↑</b></sup><sub><b>↓</b></sub>, 3<sup><b>↓</b></sup><sub><b>↓</b></sub>, 2<sup><b>↑</b></sup>, 2, . . . ]

**Now we could abstract the prototype of this edge conditon:**
![](
https://kivinsae-blog.oss-accelerate.aliyuncs.com/blog_images/20220625-LC-fs8.png)
- [ . . .  N<sub><b>i</b></sub><sup><b>↑</b></sup><sub><b>↓</b></sub>, N<sub><b>i+1</b></sub><sup><b>↓</b></sup><sub><b>↓</b></sub>, N<sub><b>i+2</b></sub><sup><b>↑</b></sup>, N<sub><b>i+3</b></sub>, . . . ]

With the prototype, we could turn it into code easily:
```c
if (nums[i] > nums[i+1]) {
	/* Action */
	if (i > 0 && i < numsSize - 2 && nums[i] > nums[i+2] && nums[i-1] > nums[i+1]) {
		/* Action */
	}
}
```

### **Let's get down to the business, explain the solution by code & comments:**
```c
bool checkPossibility(int* nums, int numsSize){
    if (numsSize < 3) {return 1;} /* Edge Condition 1 */

    int x = 0;
    int i = 0;
	/* Start the while loop to go through the array */
    while (i < numsSize - 1)
    {
        if (nums[i] > nums[i+1]) {
            x++;
			/* Edge Condition 1 */
            if (i > 0 && i < numsSize - 2 && nums[i] > nums[i+2] && nums[i-1] > nums[i+1]) {
                x++;
            }
        }
        if (x > 1) {return 0;} /* False condition */
        i++;
    }
    return 1;
}
```

Thank u for reading.

---
- Time complexity : <font style="font-family:'Georgia'"><b>O(n)</b></font>
- Space complexity : <font style="font-family:'Georgia'"><b>O(1)</b></font>
---
title: LeetCode Daily Challenge 2022-06-23 (No. 630)
date: 2022-06-23 14:01:00
categories:
- [leecode,Daily Challenge]
tags: 
- lang_english
- leetcode
- C
---
Today's Daily Challenge is **[630. Course Schedule III](https://leetcode.com/problems/course-schedule-iii/)** <font color=Red><b>HARD</b></font>. A question could be solved by tons of algorism methods, and I'll choose interative method to solve it.

Actually I've solved this question years before in Go. So this post would be a brief explanation with interative method. Questions like **[630. Course Schedule III](https://leetcode.com/problems/course-schedule-iii/)**, which asks to find a max value or deepest value out of a multi-dimension array, could usually be solved by greed or interative method.

Let's get down to the business, explain the solution by code & comments:
```c
/* Two-Dimension int array cmp() */
int CourseCmp(const void *a, const void *b) {
    return (*(int **)a)[1] - (*(int **)b)[1];
}

int scheduleCourse(int** courses, int coursesSize, int* coursesColSize){
    /* Sort the int[] array by int[][1], which means, by the last day of the course */
    qsort(courses, coursesSize, sizeof(int **), CourseCmp);
    int tsum = 0, res = 0;
    /* Main logical codes of the function */
    for (int i = 0; i < coursesSize; i++) {
        if (tsum + courses[i][0] <= courses[i][1]) {
            tsum += courses[i][0];
            courses[res++] = courses[i];
        }
        else {
            /* Try to kick off the largest duration in the valid tsum */
            int max = i;
            for (int j = 0; j < res; ++j) {
                if (courses[j][0] > courses[max][0]) max = j;
            }
            if (courses[max][0] > courses[i][0]) {
                tsum += courses[i][0] - courses[max][0];
                courses[max] = courses[i];
            }
        }
    }
    return res;
}
```
Sometimes we might get annoyed with `qsort()` in `C lib` because it requires a `cmp()` function to execute the **Quicksort** function. But in **[630](https://leetcode.com/problems/course-schedule-iii/)**, the flexibility of `qsort()` make everything simple and clear. The `courses` array sorted by `the end day` would be the key condition for the `for loop` below.

A two-dimension int array compare function is easy to write, Basically we could write a similar function for any **non-malloc n-demension array** as the form below:
```c
int CourseCmp(const void *a, const void *b) {
    return (*(int **)a)[1] - (*(int **)b)[1];
}
```
The key point is the `for loop`. It runs a interative logic in every single loop.
- `tsum` stores the valid sum of course durations and plays as a safe house for the courses which ends earlier than `course[i][1]`.
- `res` records the number of the valid courses.
- `max` helps find out the longest duration in current `tsum`. Then kicks it off from `tsum` and replaces it by the new duration time of `course[i]`.

Finally the loop goes to its end and the `res` variable stores the current `count` of valid durations.

---
- Time complexity : <font style="font-family:'Georgia'"><b>O(n * count)</b></font>
- Space complexity : <font style="font-family:'Georgia'"><b>O(1)</b></font>
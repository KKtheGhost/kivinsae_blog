---
title: LeetCode Daily Challenge 2022-06-24 (No. 1354)
date: 2022-06-24 23:30:00
categories:
- [LeetCode,Daily Challenge]
tags: 
- ENG
- LeetCode
- C
---
Today's Daily Challenge is **[1354. Construct Target Array With Multiple Sums](https://leetcode.com/problems/construct-target-array-with-multiple-sums/)** <font color=Red><b>HARD</b></font>. The most simple way solve today's challenge would be qsort(). While only **one simple element** is changed in every loop, it's cost would be significantly reduced.

So the basic logic is here:
```
[9, 3, 5] -> qsort() -> [3, 5, 9]
'9' must be added from 2 number, the first will be 3 + 5 = 8, the second would be 1.
So the largest number in the array could be written in this way:
    max = N * (sum - max) + M * 1
And the Max turns into max%sum because you could execute the step above for N times.
Then we reorder the array and get the new max element and new min element.
Then go to the next loop.

And while the loop goes, finally will reach 3 conditions:
- 1. the Max and Min elements become 1 in the same loop; So the result is true.
- 2. Max is too small and (max - sum)<=0 before reaching condition 1; The result is false.
- 3. (sum == max) after finishing one loop; It is a edge condition; The result is false.
```

Let's get down to the business, explain the solution by code & comments:
```c
/* One-Dimension int array cmp() */
int cmp(const void *a, const void *b) {
    return *(int*)a - *(int*)b;
}

bool isPossible(int* target, int targetSize){
	long int sum = 0;
    /* Init & qsort the array for the first time */
    qsort(target, targetSize, sizeof(int), cmp);
    /* Init the max and min */
	int max = target[targetSize - 1];
	int min = target[0];
    if (max == 1 & min == 1) {return 1;} /* Edge condition for [1] */
    
    /* Init the sum */
    for (int i = 0; i < targetSize; i++){
			sum += target[i];
	}
    /* Start the loop */
	while(max > 1 && min >= 1)
	{
		sum -= max;
		if (max - sum <= 0 || sum == 0) return 0;
		if (sum == 1) {
			target[targetSize - 1] = 1; /* Edge condition, because x > 0, x%1 = x */
            sum += 1;
		}
        else {
			target[targetSize - 1] = max % sum; /* Re-calculate the max */
            sum += target[targetSize - 1];
		}
        /* Re-qsort the array */
		qsort(target, targetSize, sizeof(int), cmp);
        /* Re-generate the max and min */
		max = target[targetSize - 1];
		min = target[0];
	    if (max == 1 & min == 1) {return 1;}
    }
	return 0;
}
```

Thank u for reading.

---
- Time complexity : <font style="font-family:'Georgia'"><b>O(nlogn)</b></font>
- Space complexity : <font style="font-family:'Georgia'"><b>O(n)</b></font>
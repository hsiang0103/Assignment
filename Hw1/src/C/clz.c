#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <assert.h>
#include <time.h>


int clz_1(uint32_t x)
{
    int count = 0;
    for (int i = 31; i >= 0; --i)
    {
        if (x & (1U << i))
            break;
        count++;
    }
    return count;
}

int clz_2(uint32_t x)
{
    if (x == 0)
        return 32;
    int count = 0;
    if (x <= 0x0000FFFF)
    {
        count += 16;
        x <<= 16;
    }
    if (x <= 0x00FFFFFF)
    {
        count += 8;
        x <<= 8;
    }
    if (x <= 0x0FFFFFFF)
    {
        count += 4;
        x <<= 4;
    }
    if (x <= 0x3FFFFFFF)
    {
        count += 2;
        x <<= 2;
    }
    if (x <= 0x7FFFFFFF)
    {
        count += 1;
        x <<= 1;
    }
    return count;
}

int clz_3(uint32_t x)
{
    int count = 0, temp;
    temp = (x < 0x00010000) << 4;
    count += temp;
    x <<= temp;
    temp = (x < 0x01000000) << 3;
    count += temp;
    x <<= temp;
    temp = (x < 0x10000000) << 2;
    count += temp;
    x <<= temp;
    temp = (x < 0x40000000) << 1;
    count += temp;
    x <<= temp;
    temp = (x < 0x80000000);
    count += temp;
    x <<= temp;
    count += (x == 0);
    return count;
}

int clz_4(uint32_t x)
{
    int count = 0, temp;
    temp = (x < 0x00010000) << 4;
    count += temp;
    x <<= temp;
    temp = (x < 0x01000000) << 3;
    count += temp;
    x <<= temp;
    temp = (x < 0x10000000) << 2;
    count += temp;
    x <<= temp;
    temp = (x >> 27) & 0x1e;
    count += (0x55af >> temp) & 3;
    count += (x == 0);
    return count;
}

int main()
{
    srand(time(NULL));
    int num, corner_case[6] = {-1, 1, -2147483648, 2147483647,0x08000008,0x08000018};
    int y1,y2,y3,y4,answer;
    for (int i = 0; i < 6; i++)
    {
        answer = __builtin_clz(corner_case[i]);
        y1 = clz_1(corner_case[i]);
        assert(y1 == answer);
        y2 = clz_2(corner_case[i]);
        assert(y2 == answer);
        y3 = clz_3(corner_case[i]);
        assert(y3 == answer);
        y4 = clz_4(corner_case[i]);
        assert(y4 == answer);
    }
    for (int i = 0; i < 10000; i++)
    {
        num = ((rand() << 17) | rand());
        answer = __builtin_clz(num);
        y1 = clz_1(num);
        assert(y1 == answer);
        y2 = clz_2(num);
        assert(y2 == answer);
        y3 = clz_3(num);
        assert(y3 == answer);
        y4 = clz_4(num);
        assert(y4 == answer);
    }
    printf("All test pass!!\n");
    return 0;
}
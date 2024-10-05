#include <stdint.h>
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <math.h>

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
    int num[10] = {48763, -48763, 696969, 12345, 1, 0, 654, 12, 0x00444444, 0x00016412};
    uint32_t y;
    for (int i = 0; i < 10; i++)
    {
        y = clz_4(num[i]);
        // printf("%d\n", num[i]);
        printf("%d\n", y);
        // printf("%f\n", bits_to_fp32(y));
    }
    return 0;
}
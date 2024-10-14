#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <assert.h>
#include <time.h>
static inline float fabsf(float x)
{
    uint32_t i = *(uint32_t *)&x; // Read the bits of the float into an integer
    i &= 0x7FFFFFFF;              // Clear the sign bit to get the absolute value
    x = *(float *)&i;             // Write the modified bits back into the float
    return x;
}
static inline int my_clz(uint32_t x)
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
static inline uint32_t fp16_to_fp32(uint16_t h)
{
    const uint32_t w = (uint32_t)h << 16;
    const uint32_t sign = w & UINT32_C(0x80000000);
    const uint32_t nonsign = w & UINT32_C(0x7FFFFFFF);
    uint32_t renorm_shift = my_clz(nonsign);
    renorm_shift = renorm_shift > 5 ? renorm_shift - 5 : 0;
    const int32_t inf_nan_mask = ((int32_t)(nonsign + 0x04000000) >> 8) & INT32_C(0x7F800000);
    const int32_t zero_mask = (int32_t)(nonsign - 1) >> 31;
    return sign | ((((nonsign << renorm_shift >> 3) + ((0x70 - renorm_shift) << 23)) | inf_nan_mask) & ~zero_mask);
}

int main()
{
    uint16_t x[10] = {0x1234, 0x5678, 0x4876, 0xF123, 0xFC00, 0x0400, 0x3555, 0x0022, 0x0001, 0x00FF};
    for (int i = 0; i < 10; i++)
    {
        uint32_t y = fp16_to_fp32(x[i]);
        printf("fp16:%4x -> fp32:%8x\n", x[i], y);
    }
}

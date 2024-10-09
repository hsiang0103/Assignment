#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <assert.h>
#include <time.h>

uint32_t fp32_to_bits(float f)
{
    union
    {
        float as_value;
        uint32_t as_bits;
    } fp32 = {.as_value = f};
    return fp32.as_bits;
}

int clz(uint32_t x)
{
    int count = 0, temp;
    temp = (x < 0x00010000) << 4;
    count += temp;
    x <<= temp; // off 16
    temp = (x < 0x01000000) << 3;
    count += temp;
    x <<= temp; // off 8
    temp = (x < 0x10000000) << 2;
    count += temp;
    x <<= temp; // off 4
    temp = (x >> 27) & 0x1e;
    count += (0x55af >> temp) & 3;
    count += (x == 0);
    return count;
}

// Function to convert integer to floating-point representation
uint32_t IntToFloat(int num)
{
    int leading_zero, exponent, mantissa, sign = 0;
    int shift, round_bit, temp, last_bit;
    sign = num >> 31;
    // If num is 0, the function directly returns 0
    if (num == 0)
    {
        return 0;
    }
    // The absolute value of num is taken to proceed with the conversion.
    if (num < 0)
    {
        num = -num;
    }
    // calculates the number of leading zeros
    leading_zero = clz(num);
    shift = 31 - leading_zero;
    // The exponent in IEEE 754 format is stored with a bias of 127
    // So exponent = 127 + (31 - leading_zero);
    exponent = 127 + shift;

    mantissa = num ^ (1 << shift);
    if (shift > 23)
    {
        // Round to closest
        round_bit = (mantissa >> (shift - 24)) & 0x00000001;
        // Round to even modification
        last_bit = (mantissa >> (shift - 23)) & 0x00000001;
        temp = (1 << (shift - 24)) - 1;
        temp = mantissa & temp;
        // if the round part is XXX.5
        // in C, .5 will be round to closest even
        // if last_bit == 1, then round_bit = 1
        // if last_bit == 0, then round_bit = 0
        if (temp == 0 && round_bit == 1)
        {
            round_bit = last_bit;
        }
        mantissa = mantissa >> shift - 23;
        mantissa = mantissa + round_bit;
    }
    else
    {
        mantissa = mantissa << 23 - shift;
    }
    // The function assembles the single-precision floating-point number by packing:
    // The sign bit into the most significant bit 31,
    // The 8-bit exponent into bits 30-23,
    // The 23-bit mantissa into bits 22-0.
    return ((sign << 31) | (exponent << 23)) + mantissa;
}

int main()
{
    srand(time(NULL));
    int num, y, corner_case[5] = {0, -1, 1, -2147483648, 2147483647};
    for (int i = 0; i < 5; i++)
    {
        y = IntToFloat(corner_case[i]);
        // check the output equal to the c conversion//
        assert(y == fp32_to_bits((float)(corner_case[i])));
    }
    for (int i = 0; i < 1000; i++)
    {
        num = ((rand() << 17) | rand());
        y = IntToFloat(num);
        // check the output equal to the c conversion//
        assert(y == fp32_to_bits((float)(num)));
    }
    printf("All test pass!!\n");
    return 0;
}

#include <stdint.h>
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>
#include <assert.h>
// Function to count leading zeros in the binary representation of an integer

float bits_to_fp32(uint32_t w)
{
    union
    {
        uint32_t as_bits;
        float as_value;
    } fp32 = {.as_bits = w};
    return fp32.as_value;
}

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
    int shift, round_bit, temp;
    // If num is 0, the function directly returns 0
    if (num == 0)
    {
        return 0;
    }

    // If the integer is negative, the sign is set to 1.
    // The absolute value of num is taken to proceed with the conversion.
    if (num < 0)
    {
        num = -num;
        sign = 1;
    }

    // calculates the number of leading zeros 
    leading_zero = clz(num);

    // The exponent in IEEE 754 format is stored with a bias of 127
    // So exponent = 127 + (31 - leading_zero);
    exponent = 158 - leading_zero;

    // Determines how many bit should be shifted to align for the mantissa.
    // shift =  23 - (31 - leading_zero);
    shift = -8 + leading_zero;
    
    if (shift >= 0)
    {
        // no rounding for |number| < 2^24
        round_bit = 0;
        temp = (num << shift);
    }
    else
    {
        // rounding for |number| > 2^24
        // The round_bit is set to the least significant bit of the shifted-off part.
        shift = -shift;
        round_bit = (num >> (shift - 1));
        temp = (num >> shift);
    }

    // The mantissa is formed by taking the lower 23 bits of the shifted number 
    // (temp & 0x007FFFFF).
    // If round_bit is set, it adds 1 to the mantissa to apply the rounding.
    mantissa = (temp & 0x007FFFFF) + round_bit;

    // The function assembles the single-precision floating-point number by packing:
    // The sign bit into the most significant bit 31,
    // The 8-bit exponent into bits 30-23,
    // The 23-bit mantissa into bits 22-0.
    return (sign << 31) | (exponent << 23) | mantissa;
}

int main()
{

    int num[10] = {48763, -48763, 696969, 12345, 1, 0, 654, 12, 0x444444, 0x16412};
    uint32_t y;
    for (int i = 0; i < 10; i++)
    {
        y = IntToFloat(num[i]);
        // check the output equal to the c conversion//
        // careful, for the number > 2^24 output will loss some precision//
        assert(y == fp32_to_bits((float)(num[i])));

        printf("The signle-precision bit representaion of %8d is %x\n", num[i], y);
    }
    return 0;
}

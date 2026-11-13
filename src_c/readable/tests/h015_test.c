/* H015: 32-bit arithmetic (values from the emulation of the asm routines). */
#include <stdio.h>
#include "../h015_runtime.h"
static int fails;
#define CHECK(c) do{ if(!(c)){ printf("FAIL %d: %s\n", __LINE__, #c); fails++; } }while(0)
int main(void){
  u32 r;
  CHECK(h015_divu32(100, 7, &r) == 14 && r == 2);
  CHECK(h015_divu32(0x12345678u, 0x10, &r) == 0x1234567u && r == 8);
  CHECK(h015_divu32(0x12345678u, 0x12345u, &r) == 0x1000 && r == 0x678);
  CHECK(h015_divu32(5, 0x10000u, &r) == 0 && r == 5);
  CHECK(h015_mulu32(0x12345678u, 0x12345u) == 0x6665b658u);
  CHECK(h015_divs32(-100, 7, &r) == -14 && r == 2);   /* positive remainder */
  CHECK(h015_divs32(100, -7, &r) == -14 && r == 2);
  CHECK(h015_divs32(-100, -7, &r) == 14 && r == 2);
  printf(fails ? "%d failures\n" : "all H015 checks passed\n", fails);
  return fails != 0;
}

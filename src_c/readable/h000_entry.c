/*
 * H000: entry point.  Initialises the modules in the order of the
 * original (99 calls), then continues into the main body
 * (jmp H001+$0058).
 */
#include "h001_main.h"
#include "h004_init.h"
#include "h015_runtime.h"
#include "unported.h"

void h002_init(void);
void h072_init(void);
void h097_init(void);
void h095_init(void);
void h057_init(void);
void h032_init(void);
void h085_init(void);
void h047_init(void);
void h048_init(void);
void h011_init(void);
void h028_init(void);
void h010_init(void);
void h042_init(void);
void h044_init(void);
void h043_init(void);
void h100_init(void);
void h029_init(void);
void h052_init(void);
void h003_init(void);
void h005_init(void);
void h031_init(void);
void h014_init(void);
void h034_init(void);
void h035_init(void);
void h053_init(void);
void h030_init(void);
void h056_init(void);
void h060_init(void);
void h077_init(void);
void h046_init(void);
void h073_init(void);
void h066_init(void);
void h008_init(void);
void h063_init(void);
void h062_init(void);
void h067_init(void);
void h033_init(void);
void h065_init(void);
void h027_init(void);
void h006_init(void);
void h007_init(void);
void h009_init(void);
void h058_init(void);
void h096_init(void);
void h059_init(void);
void h061_init(void);
void h013_init(void);
void h069_init(void);
void h064_init(void);
void h068_init(void);
void h071_init(void);
void h070_init(void);
void h012_init(void);
void h037_init(void);
void h036_init(void);
void h045_init(void);
void h049_init(void);
void h039_init(void);
void h055_init(void);
void h038_init(void);
void h050_init(void);
void h051_init(void);
void h078_init(void);
void h079_init(void);
void h080_init(void);
void h054_init(void);
void h098_init(void);
void h086_init(void);
void h099_init(void);
void h088_init(void);
void h087_init(void);
void h040_init(void);
void h041_init(void);
void h091_init(void);
void h092_init(void);
void h081_init(void);
void h082_init(void);
void h083_init(void);
void h084_init(void);
void h089_init(void);
void h090_init(void);
void h093_init(void);
void h094_init(void);
void h016_init(void);
void h017_init(void);
void h018_init(void);
void h019_init(void);
void h020_init(void);
void h021_init(void);
void h022_init(void);
void h023_init(void);
void h024_init(void);
void h025_init(void);
void h026_init(void);
void h074_init(void);
void h075_init(void);
void h076_init(void);

/* PORT H000+$0000 */
static void program_entry(void)
{
    h015_runtime_start();
    h002_init();
    h003_init();
    h005_init();
    h004_init();
    h016_init();
    h017_init();
    h018_init();
    h019_init();
    h074_init();
    h075_init();
    h020_init();
    h021_init();
    h022_init();
    h023_init();
    h076_init();
    h024_init();
    h025_init();
    h026_init();
    h037_init();
    h036_init();
    h045_init();
    h049_init();
    h039_init();
    h055_init();
    h038_init();
    h050_init();
    h051_init();
    h078_init();
    h079_init();
    h080_init();
    h054_init();
    h098_init();
    h086_init();
    h099_init();
    h088_init();
    h087_init();
    h040_init();
    h041_init();
    h031_init();
    h091_init();
    h092_init();
    h052_init();
    h081_init();
    h082_init();
    h083_init();
    h084_init();
    h014_init();
    h029_init();
    h089_init();
    h090_init();
    h100_init();
    h093_init();
    h094_init();
    h043_init();
    h034_init();
    h044_init();
    h042_init();
    h035_init();
    h053_init();
    h010_init();
    h028_init();
    h030_init();
    h056_init();
    h011_init();
    h060_init();
    h048_init();
    h077_init();
    h046_init();
    h073_init();
    h066_init();
    h047_init();
    h008_init();
    h063_init();
    h062_init();
    h067_init();
    h085_init();
    h033_init();
    h065_init();
    h027_init();
    h032_init();
    h006_init();
    h007_init();
    h009_init();
    h058_init();
    h057_init();
    h096_init();
    h095_init();
    h097_init();
    h059_init();
    h061_init();
    h013_init();
    h069_init();
    h064_init();
    h068_init();
    h071_init();
    h070_init();
    h072_init();
    h012_init();
    game_main();
}

/*
 * Command line arguments: the H015 runtime keeps them in H015+$8
 * (argv, table of pointers); the game reads argv[2] (H013, key J).
 */
int g_argc;
char **g_argv;

int main(int argc, char **argv)
{
    g_argc = argc;
    g_argv = argv;
    program_entry();
    return 0;
}

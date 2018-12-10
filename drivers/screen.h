#define VIDEO_ADDRESS 0xb8000

/*Colors*/
#define Black 0x00 //these colors are with black backgrounds
#define BLUE 0x01
#define GREEN 0x02
#define RED 0x04
#define MAGENTA 0x05
#define YELLOW 0x0e

#define WHITE_ON_BLACK 0x0f
#define RED_ON_WHITE 0xf4

/* screen i/o ports */
#define REG_SCREEN_CTRL 0x3d4 //We query this port to get cursor point val
#define REG_SCREEN_DATA 0x3d5 //Our queried val will be in here

/* Function declarations */
void clear_screen();

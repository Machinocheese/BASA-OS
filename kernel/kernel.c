//#include "../drivers/ports.h"
/* force to create kernel entry function */
void dummy_test_entrypoint() {
}

//vga ports header file
//Placed here instead of in a header file for compilation reasons
unsigned char port_byte_in(unsigned short port);
void port_byte_out(unsigned short port, unsigned char data);
unsigned short port_word_in(unsigned short port);
void port_word_out(unsigned short port, unsigned short data);

void main() {
	//Indexing for screen position:
	//Top left of the screen is position 0xb8000
	//Every odd bit controls the color of the previous position
	//Color codes for VGA can be found here: http://www.osdever.net/bkerndev/Docs/printing.htm

	//Note to self - memory+0xa0 is in the same column
	//Each row contains a0 characters
	
	//VGA ports 0x3d4 and 0x3d5 handle cursor data
	//14 contains the high byte and 15 contains the low byte for cursor position
	//Example usage of the ports:
	port_byte_out(0x3d4, 14);
	int position = port_byte_in(0x3d5);
	position = position << 8;		//High byte needs to be shifted
	port_byte_out(0x3d4, 15);
	position += port_byte_in(0x3d5);//Low byte just needs to be added
	
	//position now contains the cursor byte location
	int offset_from_vga = position*2;
	char* vga = 0xb8000;
	vga[offset_from_vga] = 'X';
	//This bit controls the color of the bit just printed
	vga[offset_from_vga+1] = 0x0f;

}

int length(char* str);

//This is bad practice but the makefile wasn't configured to include header files and I'm not sure
//how to fix compilation in that way
unsigned char port_byte_in(unsigned short port)
{
	unsigned char result;
	__asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
	return result;
}

unsigned short port_word_in(unsigned short port)
{
	unsigned short result;
	__asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));
	return result;
}

//Vars are already in registers, so no "=" is needed
void port_byte_out(unsigned short port, unsigned char data)
{
	__asm__("out %%al, %%dx" : "=a" (data) : "d" (port));
}

void port_word_out(unsigned short port, unsigned short data)
{
	__asm__("out %%ax, %%dx" : "=a" (data) : "d" (port));
}

//Custom print function that takes in a string str and prints it character by character starting from position pos
void print_at(char* str, int pos)
{
	for (int x = 0; x < length(str); ++x)
	{
		char* temp_mem = (char*) pos + 0x2*x;
		*temp_mem = str[x];
	}
}

void print_vertical(char* str, int pos)
{
	for (int x = 0; x < length(str); ++x)
	{
		char* temp_mem = (char*) pos + 0xa0*x;
		*temp_mem = str[x];
	}
}

//String length function
int length(char* str)
{
	int x = 0;
	while (str[x] != '\0')
		x++;
	return x;
}

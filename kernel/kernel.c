/* force to create kernel entry function */
void dummy_test_entrypoint() {
}

void main() {
	//I figured out exact screen positions with this commented out code
	// char* video_memory = (char*) 0xb8000;
	// *video_memory = '1';
	// char* video_mem2 = (char*) 0xb80a0;
	// *video_mem2 = '2';
	// char* video_mem3 = (char*) 0xb8100;
	// char* video_mem4 = (char*) 0xb8150;
	// char* video_mem5 = (char*) 0xb8200;
	// char* video_mem6 = (char*) 0xb8250;
	// char* video_mem7 = (char*) 0xb8300;
	// char* video_mem8 = (char*) 0xb8350;
	// char* video_mem9 = (char*) 0xb8400;
	// char* video_mem0 = (char*) 0xb8450;
	// char* video_mema = (char*) 0xb8500;
	// char* video_memb = (char*) 0xb8550;
	// *video_mem3 = '3';
	// *video_mem4 = '4';
	// *video_mem5 = '5';
	// *video_mem6 = '6';
	// *video_mem7 = '7';
	// *video_mem8 = '8';
	// *video_mem9 = '9';
	// *video_mem0 = '0';
	// *video_mema = 'A';
	// *video_memb = 'B';

	print_custom("BASA-OS loaded\0", 0xb8a00);
	//print_vertical("V E R T I C A L\0", 0xb8680);

	//Note to self - memory+0xa0 is in the same column
	//Each row contains a0 characters

}

//Custom print function that takes in a string str and prints it character by character starting from position pos
void print_custom(char* str, int pos)
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

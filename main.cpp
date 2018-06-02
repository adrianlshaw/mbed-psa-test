#include <stdio.h>
#include "spm_client.h"

int main(int argc, char *argv[])
{
	while (1) {
		printf("Client: Hello world\n\r");
		
		psa_handle_t h = psa_connect(0x0000DEAD, 1);
	
		if (!h) {
			printf("Client: Could not connect to service\n\r");
		} else {
			psa_call(h, NULL, 0, NULL, 0);
			psa_close(h);
		}
		printf("Client: Exiting\n\r");
	}
	return 0;
}

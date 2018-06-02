#include <string.h>
#include <stdint.h>
#include "spm_server.h"
#include "psa_secure_part_partition.h"

#define PSA_WAIT_BLOCK UINT32_MAX

#define PSA_IPC_CONNECT 1
#define PSA_IPC_CALL 2
#define PSA_IPC_DISCONNECT 3

#define PSA_CONNECTION_ACCEPTED (0)
#define PSA_CONNECTION_REFUSED (-1)

void partition_main(void *ptr)
{
	psa_msg_t msg = { 0 };
	int32_t result = 0;
	uint32_t signals = 0;

	printf("Partition: Initialised\n\r");
	while (1) {
		//part_stats();
		signals = psa_wait_any(PSA_WAIT_BLOCK);

		if (signals & SERVICE_MSK) {

			psa_get(signals, &msg);
			switch(msg.type) {
				case PSA_IPC_CONNECT:
					printf("Parition: Got a connection!\n\r");
					/* Only allowing requests from Non-Secure domain */
					if (psa_identity(msg.handle) > 0) {
						result = PSA_CONNECTION_REFUSED;
					} else {
						result = PSA_CONNECTION_ACCEPTED;
					}
					break;
				case PSA_IPC_CALL:
					printf("Partition: Got an IPC call!\n\r");
					break;
				case PSA_IPC_DISCONNECT:
					printf("Partition: Connection was closed!\n\r");
					break;
				default:
					abort();
					break;

			}
			psa_end(msg.handle, result);
		} else {
			abort();
		}
	}
}

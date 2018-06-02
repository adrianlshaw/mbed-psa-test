CUR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

dockerfile:
	cd Dockerfile && docker build -t mbed .

disco:
	docker run -ti -v $(CUR):/spm mbed /bin/bash -c "cp * /tmp/ -r && \
		cd /tmp/ && mbed compile -t GCC_ARM -m DISCO_F429ZI && \
       		cp ./BUILD/DISCO_F429ZI/GCC_ARM/tmp.bin /spm/ &&	\
		qemu-system-gnuarmeclipse -board STM32F429I-Discovery \
		-mcu STM32F429ZI \
		-image ./BUILD/DISCO_F429ZI/GCC_ARM/tmp.bin \
		-nographic -serial mon:stdio"

docker-microbit: dockerfile
	mkdir -p output
	chmod -R 777 output
	docker run -ti --rm -v $(CUR):/spm:rw mbed make microbit

microbit:
	cp * /tmp/ -r
	cd /tmp
	chown -R $$USER:$$USER /tmp/*
	# Source is copied in order to change the build configuration
	# Enable compilation on mbedOS 5, enable SPM, reduce SRAM usage
	# to make it suitable for the Micro:bit's 16K SRAM
	sed -i 's/versions\"\: \[\"2\"]/versions": ["2", "5"]/g' /tmp/mbed-os/targets/targets.json
	echo "*" > /tmp/mbed-os/features/.mbedignore
	sed -i 's#"value": 0#"value": 1#g' /tmp/mbed-os/spm/mbed_lib.json
	sed -i 's#"value": 10#"value": 1#g' /tmp/mbed-os/spm/mbed_lib.json

	echo '{ "config": { "main-stack-size": {	"value": 2000 } } }' > /tmp/mbed_app.json 

	# Start the compilation
	cd /tmp && mbed compile -m NRF51_MICROBIT -t GCC_ARM -DMBED_STACK_STATS_ENABLED=1 -DMBED_HEAP_STATS_ENABLED=1 --stats-depth=100  

	cp /tmp/BUILD/NRF51_MICROBIT/GCC_ARM/tmp.hex output/
	cp /tmp/BUILD/NRF51_MICROBIT/GCC_ARM/tmp.map output/

# docker build -t mbed .
# docker run -ti -v $PWD:/spm mbed
FROM ubuntu
RUN apt-get update -qq && apt-get install -y -qq git wget libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev pkg-config autogen autoconf python python-pip nano
RUN pip install mbed-cli
WORKDIR /usr/local/
RUN wget https://github.com/gnu-mcu-eclipse/qemu/releases/download/gae-2.8.0-20170301/gnuarmeclipse-qemu-debian64-2.8.0-201703022210-head.tgz
RUN tar zxvf gnuarmeclipse-qemu-debian64-2.8.0-201703022210-head.tgz
ENV PATH $PATH:/usr/local/gnuarmeclipse/qemu/2.8.0-201703022210-head/bin
RUN wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2
RUN tar xvjf gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2
ENV PATH $PATH:/usr/local/gcc-arm-none-eabi-7-2017-q4-major/bin/
WORKDIR /spm
RUN pip install colorama PySerial PrettyTable Jinja2 IntelHex junit-xml pyYAML requests mbed-ls mbed-host-tests mbed-greentea beautifulsoup4 fuzzywuzzy pyelftools jsonschema future
CMD [ "/bin/bash" ]

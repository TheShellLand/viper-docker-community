FROM theshellland/viper-docker-base

USER root
WORKDIR /

# basic requirements
RUN apt update \
    && apt install -y libssl-dev swig libffi-dev ssdeep libfuzzy-dev p7zip-full

# for compiling code
RUN apt install -y build-essential

# fix unrar not found
RUN apt install -y unrar-free

# fix bitstring module not found
RUN pip3 install bitstring

# fix OSError: libusb-1.0.so: cannot open shared object file: No such file or directory
RUN apt install -y libusb-1.0-0-dev

# Exif
RUN apt install -y exiftool

# ClamAV
RUN apt install -y clamav-daemon

# Tor
RUN apt install -y tor

# Scraper
RUN apt install -y libdpkg-perl

# fix ERROR: pymisp 2.4.124 has requirement jsonschema<4.0.0,>=3.2.0, but you'll have jsonschema 3.0.1 which is incompatible.
# fix ERROR: pymispgalaxies 0.2 has requirement jsonschema<4.0.0,>=3.2.0, but you'll have jsonschema 3.0.1 which is incompatible.
RUN pip3 install jsonschema==3.2.0

# Yara
RUN pip3 install yara-python

# ssdeep
WORKDIR /install
#RUN pip3 install ssdeep
RUN git clone https://github.com/ssdeep-project/ssdeep \
    && cd ssdeep \
    && autoreconf -i \
    && ./configure \
    && make \
    && make install \

# yara
WORKDIR /install
RUN apt install -y automake libtool make gcc \
    # for generating lexers and parsers
    && apt install -y flex bison \
    && git clone https://github.com/VirusTotal/yara.git \
    && cd yara \
    && ./bootstrap.sh \
    && sync \
    && ./configure --with-crypto --enable-magic --enable-cuckoo --enable-dotnet \
    && make \
    && make install \
    && make check

#### Python

# ssdeep
RUN pip3 install ssdeep

# Yara pip
RUN pip3 install yara-python

# PyExif
WORKDIR /install
RUN git clone git://github.com/smarnach/pyexiftool.git \
    && cd pyexiftool \
    && python setup.py install

# AndroGuard
RUN pip3 install -U androguard


# cleanup
RUN apt autoremove -y \
    && apt autoclean \
    && apt clean \
    && rm -rf /tmp/*

# Create Viper User
RUN groupadd -r viper \
#    && useradd -r -g viper -d /home/viper -s /sbin/nologin -c "Viper User" viper \
    && useradd -r -g viper -d /home/viper -s /bin/bash -c "Viper User" viper \
    && mkdir /home/viper \
    && chown -R viper:viper /home/viper

WORKDIR /home/viper
USER viper

# get community modules
#RUN echo update-modules | viper

ENTRYPOINT ["viper"]

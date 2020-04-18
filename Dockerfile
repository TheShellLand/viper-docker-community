FROM theshellland/viper-docker-base

# fun note, $INSTALL is used by programs, DONT SET INSTALL VAR
ENV TMPINSTALL /install

USER root
WORKDIR /

# basic requirements
RUN apt update \
    && apt install -y libssl-dev swig libffi-dev ssdeep libfuzzy-dev p7zip-full \
    # for compiling code
    && apt install -y build-essential \
    # fix unrar not found
    && apt install -y unrar-free \
    # fix bitstring module not found
    && pip3 install bitstring \
    # fix OSError: libusb-1.0.so: cannot open shared object file: No such file or directory
    && apt install -y libusb-1.0-0-dev \
    # fix ERROR: pymisp 2.4.124 has requirement jsonschema<4.0.0,>=3.2.0, but you'll have jsonschema 3.0.1 which is incompatible.
    # fix ERROR: pymispgalaxies 0.2 has requirement jsonschema<4.0.0,>=3.2.0, but you'll have jsonschema 3.0.1 which is incompatible.
    && pip3 install jsonschema==3.2.0 \
    # cleanup
    && apt autoremove -y \
    && apt autoclean -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*


#### Packages

RUN apt update \
    # Exif
    && apt install -y exiftool \
    # ClamAV
    && apt install -y clamav-daemon \
    # Tor
    && apt install -y tor \
    # Scraper
    && apt install -y libdpkg-perl \
    # fix ERROR: pymisp 2.4.124 has requirement jsonschema<4.0.0,>=3.2.0, but you'll have jsonschema 3.0.1 which is incompatible.
    # fix ERROR: pymispgalaxies 0.2 has requirement jsonschema<4.0.0,>=3.2.0, but you'll have jsonschema 3.0.1 which is incompatible.
    && pip3 install jsonschema==3.2.0 \
    # cleanup
    && apt autoremove -y \
    && apt autoclean -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*

# ssdeep
WORKDIR $TMPINSTALL
RUN apt update \
    && apt install -y build-essential git gcc make libfuzzy-dev libtool libffi-dev automake autoconf libtool \
    && git clone https://github.com/ssdeep-project/ssdeep \
    && cd ssdeep \
    && autoreconf -i \
    && ./configure \
    && make \
    && make install \
    # cleanup
    && rm -rf $TMPINSTALL \
    && apt autoremove -y \
    && apt autoclean -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*

# yara
WORKDIR $TMPINSTALL
RUN apt update \
    && apt install -y automake libtool make gcc \
    # for generating lexers and parsers
    && apt install -y flex bison \
    # dependencies
    && apt install -y libjansson-dev libmagic-dev \
    && git clone https://github.com/VirusTotal/yara.git \
    && cd yara \
    && ./bootstrap.sh \
    && sync \
    && ./configure --with-crypto --enable-magic --enable-cuckoo --enable-dotnet \
    && make \
    && make install \
    && make check \
    # cleanup
    && rm -rf $TMPINSTALL \
    && apt autoremove -y \
    && apt autoclean -y \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*

#### Python

RUN pip3 install update pip \
    # ssdeep
    && pip3 install ssdeep \
    # Yara pip
    && pip3 install yara-python \
    # AndroGuard
    && pip3 install -U androguard \
    # pydeep
    # needed for ssdeep?
    && pip3 install pydeep

# PyExif
WORKDIR $TMPINSTALL
RUN git clone https://github.com/smarnach/pyexiftool \
    && cd pyexiftool \
    && python setup.py install \
    # cleanup
    && rm -rf $TMPINSTALL


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

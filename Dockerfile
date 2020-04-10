FROM theshellland/viper-docker-base

# basic requirements
RUN apt install -y libssl-dev swig libffi-dev ssdeep libfuzzy-dev p7zip-full

# fix unrar not found
RUN apt install -y unrar-free

# get community modules
RUN echo update-modules | viper

# fix ERROR: pymisp 2.4.124 has requirement jsonschema<4.0.0,>=3.2.0, but you'll have jsonschema 3.0.1 which is incompatible.
# fix ERROR: pymispgalaxies 0.2 has requirement jsonschema<4.0.0,>=3.2.0, but you'll have jsonschema 3.0.1 which is incompatible.
RUN pip3 install jsonschema==3.2.0

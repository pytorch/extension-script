FROM ubuntu:xenial

RUN apt-get update  -y \
  && apt-get install -y git cmake vim make wget gnupg build-essential software-properties-common gdb zip

# Install OpenCV
RUN apt-get install -y libopencv-dev

# Install Miniconda
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh \
  && chmod +x miniconda.sh \
  && ./miniconda.sh -b -p ~/local/miniconda \
  && rm ./miniconda.sh

# Symlink the Miniconda activation script to /activate
RUN ln -s ~/local/miniconda/bin/activate /activate
#Change python to 3.7
RUN . /activate && conda install python=3.7
# Install PyTorch
RUN . /activate && \
  conda install  -c pytorch-nightly cpuonly && \
  conda install  -c pytorch-nightly pytorch 

# Download LibTorch
RUN wget https://download.pytorch.org/libtorch/nightly/cpu/libtorch-shared-with-deps-latest.zip
RUN unzip libtorch-shared-with-deps-latest.zip && rm libtorch-shared-with-deps-latest.zip

# Get conda working
ENV PATH=$PATH:/root/local/miniconda/bin/  
RUN conda init bash

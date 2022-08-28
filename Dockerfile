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

###########################Clark Added Below

#How to Git clone in Docker?
RUN git clone https://github.com/pytorch/extension-script.git
RUN git clone https://github.com/dblalock/bolt.git

###%% Things added to get Bolt working; could've just used their docker?: https://github.com/dblalock/bolt/blob/master/BUILD.md
WORKDIR bolt/
RUN apt update -y
RUN sudo apt-get install \
	build-essential \
	clang-3.9 \
	libc++-dev \
	libeigen3-dev \
	swig \
	 -y

#Need to install Bazel for build
RUN sudo apt install apt-transport-https curl gnupg \
	&& curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg \
	&& sudo mv bazel-archive-keyring.gpg /usr/share/keyrings \
	&& echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list \
	&& sudo apt update && sudo apt install bazel

#Bolt packages
RUN conda install --file requirements.txt 
#install kmc2 
RUN cd .. \
	&& git clone -b mneilly/cythonize https://github.com/mneilly/kmc2.git \
	&& cd kmc2 \
	&& python setup.py install

RUN cd bolt/cpp && bazel run :main
#Note: 1 test currently fails
RUN python setup.py install && pytest tests/ 
# Specify the base image for the environment
FROM ubuntu:20.04

# Specify the maintainer of the image
LABEL maintainer="dbontempi@bwh.harvard.edu"

# Remove any third-party apt sources to avoid issues with expiring keys.
RUN rm -f /etc/apt/sources.list.d/*.list

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install some basic system utilities
RUN apt update && apt install -y --no-install-recommends \  
  wget \
  sudo \
  git \
&& rm -rf /var/lib/apt/lists/*

# Create a working directory
RUN mkdir /app
WORKDIR /app

# Create a non-root user "user" and switch to it
# We can rename "user" after AIMI in the future
RUN adduser --disabled-password --gecos '' --shell /bin/bash user \
 && chown -R user:user /app
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user
USER user

# Set up a user directory for "user"
ENV HOME=/home/user
RUN mkdir $HOME/.cache $HOME/.config \
 && chmod -R 777 $HOME

# Copy the YAML environment file in the container
ADD ./environment.yaml /app/environment.yaml

# Set up Conda and install a very minimal base environment
ENV CONDA_AUTO_UPDATE_CONDA=false \
    PATH=$HOME/miniconda/bin:$PATH

ENV CONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"

RUN wget -O ~/miniconda.sh $CONDA_URL --no-check-certificate \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p ~/miniconda \
 && rm ~/miniconda.sh \
 && conda env update -n base -f /app/environment.yaml \
 && rm /app/environment.yaml \
 && conda clean -ya

RUN conda update -n base -c defaults conda
RUN echo "conda activate base" > ~/.bashrc

RUN pip3 install -f https://download.pytorch.org/whl/cu113/torch_stable.html \
  torch==1.10.0+cu113 \
  torchvision==0.11.1+cu113 \
  torchaudio==0.10.0+cu113

# Clone git repositories
# FIXME: as soon as the GitHub repo is public
RUN git clone <link-to-repo>

# download ensemble model data
RUN wget <link-to-model> -O models
RUN unzip models/ensemble-model-weights.zip -d ../models/ && rm models/ensemble-model-weights.zip

# download InceptionV4 pre-trained model data
RUN wget <link-to-model> -O /user/.cache/torch/hub/checkpoints/ --no-check-certificate

# data pre-processing
RUN ...

# Create useful aliases for dev
RUN echo 'alias ll="ls -alF"' >> ~/.bashrc

# Create directories that will be used as mounting points
#RUN mkdir /app/data /app/data/input_data /app/data/output_data 

CMD ["python", "/app/CXR-Lung-Risk/src/run_cxr_lung_risk.py"]

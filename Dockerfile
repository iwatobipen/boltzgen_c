FROM nvidia/cuda:12.3.2-cudnn9-runtime-ubuntu22.04
# 2.2.1
# retry

RUN apt-get update && apt-get install -y \
    wget \
    git \
    vim \
    sudo \
    build-essential
WORKDIR /opt

RUN wget https://github.com/conda-forge/miniforge/releases/download/25.3.1-0/Miniforge3-25.3.1-0-Linux-x86_64.sh && \
#RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" && \
    git clone https://github.com/HannesStark/boltzgen.git && \
    sh Miniforge3-25.3.1-0-Linux-x86_64.sh -b -p /opt/Miniforge && \    
    rm -r Miniforge3-25.3.1-0-Linux-x86_64.sh
    
ENV PATH /opt/Miniforge/bin:$PATH
WORKDIR /opt/boltzgen
RUN conda create -n boltzgen python=3.21 -y && \
    conda init
    
SHELL ["conda", "run", "-n", "boltzgen", "/bin/bash", "-c"]

RUN touch setup.cfg && \
    conda clean --all -y && \ 
    pip cache purge && \
    pip install -e .[cuda] && \
    echo "conda activate boltz" >> ~/.bashrc

ENV PATH /opt/Miniforge/envs/boltz/bin:$PATH

FROM runpod/base:0.6.2-cuda12.2.0
WORKDIR /app

# Install dependencies
RUN apt-get update

COPY . .
ARG CACHEBUST=1
RUN git clone https://github.com/ostris/ai-toolkit.git && \
    cd ai-toolkit && \
    git submodule update --init --recursive

WORKDIR /app/ai-toolkit

RUN echo "Contents of /app/ai-toolkit:" && ls -la


RUN ln -s /usr/bin/python3 /usr/bin/python
RUN python -m pip --no-cache-dir install -r requirements.txt 

#RUN apt-get install -y tmux nvtop htop

#RUN pip install jupyterlab

# mask workspace
#RUN mkdir /workspace


# symlink app to workspace
#RUN ln -s /app/ai-toolkit /workspace/ai-toolkit

#WORKDIR /
#CMD ["/start.sh"]
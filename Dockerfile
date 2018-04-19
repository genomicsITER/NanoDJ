FROM jupyter/datascience-notebook
LABEL maintainer="Hector Rodriguez Perez (hecrp) alu0100774429@ull.edu.es"

USER root

WORKDIR /home/jovyan/software

RUN apt-get update && \
    apt-get install -y \
    zlib1g-dev \
    cmake \
    default-jre \ 
    unzip \ 
    apt-transport-https \
    python2.7 \ 
    python-pip \
    strace \
    libhdf5-cpp-11 \
    libbz2-dev \  
    python3 python3-setuptools libboost-all-dev \
    python3-h5py python3-numpy python3-dateutil python3-progressbar \
    libboost-filesystem1.58.0 libboost-program-options1.58.0 \
    libboost-system1.58.0 libboost-log1.58.0 libboost-thread1.58.0 \
    libboost-python1.58.0


RUN pip install bash_kernel biopython nanosim-h jupyterlab
RUN python -m bash_kernel.install

RUN git clone https://github.com/lh3/minimap2 && \
    cd minimap2 && \
    make && \
    cd ..

RUN git clone --recursive https://github.com/isovic/racon.git racon && cd racon && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make

RUN git clone https://github.com/rrwick/Unicycler.git && cd Unicycler && make && cd ..

RUN git clone https://github.com/lh3/miniasm && (cd miniasm && make)

RUN git clone https://github.com/marbl/canu.git && \
    cd canu/src && \
    make -j 1

RUN git clone https://github.com/ablab/quast.git && \ 
    cd quast && \ 
    ./setup.py install \ 
    && cd ..

RUN git clone https://github.com/rrwick/Porechop.git && \
    cd Porechop && \
    python3 setup.py install

RUN git clone https://github.com/rrwick/Rebaler.git && \
    cd Rebaler && \
    python3 setup.py install

RUN git clone https://github.com/fenderglass/Flye && \  
    cd Flye && \  
    python2 setup.py build

RUN wget "http://cab.spbu.ru/files/release3.11.0/SPAdes-3.11.0-Linux.tar.gz" && \
    tar -xvzf SPAdes-3.11.0-Linux.tar.gz && rm SPAdes-3.11.0-Linux.tar.gz

RUN wget "https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.3/bowtie2-2.3.3-linux-x86_64.zip" && \
    unzip bowtie2-2.3.3-linux-x86_64.zip -d ~ && rm bowtie2-2.3.3-linux-x86_64.zip

RUN wget "https://sourceforge.net/projects/samtools/files/samtools/1.5/samtools-1.5.tar.bz2" && \
    tar -xvjf samtools-1.5.tar.bz2 && rm samtools-1.5.tar.bz2

RUN mkdir pilon && \ 
    cd pilon && \ 
    wget "https://github.com/broadinstitute/pilon/releases/download/v1.22/pilon-1.22.jar" && \
    chown jovyan pilon-1.22.jar && \ 
    cd ..

RUN wget "https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.15.tar.bz2" && \
    tar -xvjf bwa-0.7.15.tar.bz2 && \
    rm bwa-0.7.15.tar.bz2 && \ 
    cd bwa-0.7.15 && make && cd ..

RUN wget "https://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/ncbi-blast-2.7.1+-x64-linux.tar.gz" && \
    tar zxvpf ncbi-blast-2.7.1+-x64-linux.tar.gz && \ 
    rm ncbi-blast-2.7.1+-x64-linux.tar.gz

RUN wget "ftp://ftp.genome.umd.edu/pub/MaSuRCA/latest/MaSuRCA-3.2.4.tar.gz" && \  
    tar -xzvf MaSuRCA-3.2.4.tar.gz && \
    cd MaSuRCA-3.2.4 && ./install.sh && cd ..

COPY scripts /home/jovyan/scripts
RUN wget "https://downloads.sourceforge.net/project/rpore/0.24/poRe_0.24.tar.gz" && \
    cat /home/jovyan/scripts/CRAN_repbydefault.txt  >> /home/jovyan/.Rprofile && \
    Rscript /home/jovyan/scripts/pore_dependencies.R && \ 
    R CMD INSTALL poRe_0.24.tar.gz

RUN wget "https://codeload.github.com/fenderglass/Flye/tar.gz/2.3.1" && \
    tar -xzvf 2.3.1 && \ 
    rm 2.3.1

RUN git clone --recursive https://github.com/jts/nanopolish.git && \
    cd nanopolish && \
    make && cd ..

RUN wget "https://sourceforge.net/projects/bowtie-bio/files/bowtie2-2.3.4.1-linux-x86_64.zip" && \
    unzip bowtie2-2.3.4.1-linux-x86_64.zip -d ~/software

RUN wget -O- https://mirror.oxfordnanoportal.com/apt/ont-repo.pub | apt-key add - && \
    echo "deb http://mirror.oxfordnanoportal.com/apt xenial-stable non-free" | tee /etc/apt/sources.list.d/nanoporetech.sources.list && \
    apt-get update && \ 
    wget -qO python3-ont-albacore_2.1.10-1~xenial_amd64.deb https://mirror.oxfordnanoportal.com/software/analysis/python3-ont-albacore_2.1.10-1~xenial_amd64.deb && \
   apt-get install -y python3-ont-fast5-api && \ 
   dpkg -i python3-ont-albacore_2.1.10-1~xenial_amd64.deb && \
   apt-get install -fy

WORKDIR /home/jovyan/notebooks

ENV PATH "$PATH:/home/jovyan/software/ncbi-blast-2.7.1+/bin"
ENV PATH "$PATH:/home/jovyan/software/Porechop"
ENV PATH "$PATH:/home/jovyan/software/SPAdes-3.11.0-Linux/bin"
ENV PATH "$PATH:/home/jovyan/software/minimap2"
ENV PATH "$PATH:/home/jovyan/software/racon/build/bin"
ENV PATH "$PATH:/home/jovyan/software/bowtie2-2.3.4.1-linux-x86_64"
ENV PATH "$PATH:/home/jovyan/software/samtools-1.5"
ENV PATH "$PATH:/home/jovyan/software/pilon/bin"
ENV PATH "$PATH:/home/jovyan/software/Unicycler"
ENV PATH "$PATH:/home/jovyan/software/bwa-0.7.15"
ENV PATH "$PATH:/home/jovyan/software/canu/Linux-amd64/bin"
ENV PATH "$PATH:/home/jovyan/software/quast"
ENV PATH "$PATH:/home/jovyan/software/miniasm"
ENV PATH "$PATH:/home/jovyan/software/pilon"
ENV PATH "$PATH:/home/jovyan/software/Flye-2.3.1/bin"
ENV PATH "$PATH:/home/jovyan/software/nanopolish"
ENV PATH "$PATH:/home/jovyan/software/MaSuRCA-3.2.4/bin"

USER jovyan
CMD jupyter lab --allow-root

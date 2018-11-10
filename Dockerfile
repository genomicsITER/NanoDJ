FROM jupyter/datascience-notebook:160eb5183ace
LABEL maintainer="Genomics Division, ITER (genomicsITER)"

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
    libboost-python1.58.0 graphviz


RUN pip install bash_kernel biopython nanosim-h jupyterlab && \
    python -m bash_kernel.install

RUN echo '**************************************' && \
    echo '*******Installing minimap2 ***********' && \
    echo '**************************************' && \
    git clone https://github.com/lh3/minimap2 && \
    cd minimap2 && make && \
    find . -name '*.o' -exec rm -f {} \; && \
    cd ..

RUN echo '**************************************' && \
    echo '*******Installing racon    ***********' && \
    echo '**************************************' && \
    git clone --recursive https://github.com/isovic/racon.git racon && \
    cd racon && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make && \
    find . -name '*.o' -exec rm -f {} \; 

RUN echo '**************************************' && \
    echo '*******Installing Unicycler **********' && \
    echo '**************************************' && \
    git clone https://github.com/rrwick/Unicycler.git && \
    cd Unicycler && make && \
    find . -name '*.o' -exec rm -f {} \; && \
    cd .. 

RUN echo '**************************************' && \
    echo '*******Installing miniasm ************' && \
    echo '**************************************' && \
    git clone https://github.com/lh3/miniasm && \
    (cd miniasm && make && find . -name '*.o' -exec rm -f {} \;) 

RUN echo '**************************************' && \
    echo '*******Installing canu ***************' && \
    echo '**************************************' && \
    git clone https://github.com/marbl/canu.git && \
    cd canu/src && make -j 1 && find . -name '*.o' -exec rm -f {} \;

RUN echo '**************************************' && \
    echo '*******Installing quast **************' && \
    echo '**************************************' && \
    git clone https://github.com/ablab/quast.git && \ 
    cd quast && ./setup.py install && \
    find . -name '*.o' -exec rm -f {} \; && \
    cd .. 

RUN echo '**************************************' && \
    echo '*******Installing Porechop ***********' && \
    echo '**************************************' && \
    git clone https://github.com/rrwick/Porechop.git && \
    cd Porechop && \
    python3 setup.py install && \
    find . -name '*.o' -exec rm -f {} \;

RUN echo '**************************************' && \
    echo '*******Installing Rebaler ************' && \
    echo '**************************************' && \
    git clone https://github.com/rrwick/Rebaler.git && \
    cd Rebaler && \
    python3 setup.py install

RUN echo '***********************************' && \
    echo '*******Installing samtools  *******' && \
    echo '***********************************' && \
    wget "https://sourceforge.net/projects/samtools/files/samtools/1.5/samtools-1.5.tar.bz2" && \
    tar -xvjf samtools-1.5.tar.bz2 && rm samtools-1.5.tar.bz2 

RUN echo '***********************************' && \
    echo '*******Installing SPAdes  *******' && \
    echo '***********************************' && \
    wget "http://cab.spbu.ru/files/release3.13.0/SPAdes-3.13.0-Linux.tar.gz" && \
    tar -xvzf SPAdes-3.13.0-Linux.tar.gz && rm SPAdes-3.13.0-Linux.tar.gz

RUN echo '***********************************' && \
    echo '*******Installing pilon ***********' && \
    echo '***********************************' && \
    mkdir pilon && cd pilon && \ 
    wget "https://github.com/broadinstitute/pilon/releases/download/v1.22/pilon-1.22.jar" && \
    chown jovyan pilon-1.22.jar && cd .. 

RUN echo '***********************************' && \
    echo '*******Installing bwa *************' && \
    echo '***********************************' && \
    wget "https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.15.tar.bz2" && \
    tar -xvjf bwa-0.7.15.tar.bz2 && \
    rm bwa-0.7.15.tar.bz2 && \ 
    cd bwa-0.7.15 && make && \
    find . -name '*.o' -exec rm -f {} \; && \
    cd .. 

RUN echo '***********************************' && \
    echo '*******Installing ncbi-blast+ *****' && \
    echo '***********************************' && \
    wget "https://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/ncbi-blast-2.7.1+-x64-linux.tar.gz" && \
    tar zxvpf ncbi-blast-2.7.1+-x64-linux.tar.gz && \ 
    rm ncbi-blast-2.7.1+-x64-linux.tar.gz 

RUN echo '***********************************' && \
    echo '*******Installing MaSuRCA *********' && \
    echo '***********************************' && \
    wget "https://github.com/alekseyzimin/masurca/releases/download/3.2.8/MaSuRCA-3.2.8.tar.gz" && \  
    tar -xzvf MaSuRCA-3.2.8.tar.gz && \
    rm MaSuRCA-3.2.8.tar.gz && \
    cd MaSuRCA-3.2.8 && ./install.sh && \
    find . -name '*.o' -exec rm -f {} \; && \
    cd .. 

RUN echo '*********************************************' && \
    echo '*******Installing rhdf5 (R bioconductor) ****' && \
    echo '*********************************************' && \
    echo 'local({r <- getOption("repos"); r["CRAN"] <- "http://cran.cnr.berkeley.edu/"; options(repos = r)})'  >> /home/jovyan/.Rprofile && \
    R -e "source('http://www.bioconductor.org/biocLite.R'); biocLite('rhdf5'); install.packages(c('shiny','svDialogs','data.table','bit64'))" 

RUN echo '***********************************' && \
    echo '*******Installing Flye ************' && \
    echo '***********************************' && \
    wget "https://codeload.github.com/fenderglass/Flye/tar.gz/2.3.6" && \
    tar -xzvf 2.3.6 && \ 
    rm 2.3.6 && \ 
    cd Flye-2.3.6 && \  
    python2 setup.py install && cd .. 

RUN echo '***********************************' && \
    echo '*******Installing nanopolish ******' && \
    echo '***********************************' && \
    git clone --recursive https://github.com/jts/nanopolish.git && \
    cd nanopolish && \
    make && \
    find . -name '*.o' -exec rm -f {} \; && \
    cd .. 

RUN echo '***********************************' && \
    echo '*******Installing bowtie2 *********' && \
    echo '***********************************' && \
    wget "https://sourceforge.net/projects/bowtie-bio/files/bowtie2-2.3.4.1-linux-x86_64.zip" && \
    unzip bowtie2-2.3.4.1-linux-x86_64.zip -d ~/software && \
    rm bowtie2-2.3.4.1-linux-x86_64.zip

RUN echo '****************************************************' && \
    echo '*******Installing albacore & fast5 (ONT software) **' && \
    echo '****************************************************' && \
    wget -O- https://mirror.oxfordnanoportal.com/apt/ont-repo.pub | apt-key add - && \
    echo "deb http://mirror.oxfordnanoportal.com/apt xenial-stable non-free" | tee /etc/apt/sources.list.d/nanoporetech.sources.list && \
    apt-get update && \ 
    wget -qO python3-ont-albacore_2.3.3-1~xenial_amd64.deb https://mirror.oxfordnanoportal.com/software/analysis/python3-ont-albacore_2.3.3-1~xenial_amd64.deb && \
    apt-get install -y python3-ont-fast5-api && \ 
    dpkg -i python3-ont-albacore_2.3.3-1~xenial_amd64.deb && \
    rm python3-ont-albacore_2.3.3-1~xenial_amd64.deb && \
    apt-get install -fy && \
    apt-get -y install gnuplot-x11 qt5-default 

RUN echo '***********************************' && \
    echo '*******Installing Bandage *********' && \
    echo '***********************************' && \
    mkdir Bandage && cd Bandage && \  
    wget "https://github.com/rrwick/Bandage/releases/download/v0.8.1/Bandage_Ubuntu_dynamic_v0_8_1.zip" && \  
    unzip Bandage_Ubuntu_dynamic_v0_8_1.zip && \  
    rm Bandage_Ubuntu_dynamic_v0_8_1.zip 

RUN echo '***********************************' && \
    echo '*******Installing Nanosim *********' && \
    echo '***********************************' && \
    wget "https://github.com/bcgsc/NanoSim/archive/v2.1.0.tar.gz" && \
    tar -xzvf v2.1.0.tar.gz && \
    rm v2.1.0.tar.gz


ENV PATH "$PATH:/home/jovyan/software/ncbi-blast-2.7.1+/bin"
ENV PATH "$PATH:/home/jovyan/software/Porechop"
ENV PATH "$PATH:/home/jovyan/software/SPAdes-3.13.0-Linux/bin"
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
ENV PATH "$PATH:/home/jovyan/software/Flye-2.3.6/bin"
ENV PATH "$PATH:/home/jovyan/software/nanopolish"
ENV PATH "$PATH:/home/jovyan/software/MaSuRCA-3.2.8/bin"
ENV PATH "$PATH:/home/jovyan/software/Bandage"
ENV PATH "$PATH:/home/jovyan/software/Nanosim-2.1.0/src"

USER jovyan
WORKDIR /home/jovyan/notebooks

CMD jupyter lab --allow-root

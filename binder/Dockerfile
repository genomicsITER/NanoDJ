FROM jupyter/datascience-notebook:160eb5183ace
LABEL maintainer="Genomics Division, ITER (genomicsITER)"

USER root

WORKDIR /home/jovyan/software

RUN apt-get update && \
    apt-get install -y \
    python-pip 

RUN echo '***********************************' && \
    echo '*******Installing biopython  ******' && \
    echo '***********************************' && \
    pip install biopython

RUN echo '***********************************' && \
    echo '*******Installing ncbi-blast ******' && \
    echo '***********************************' && \
    wget "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.7.1/ncbi-blast-2.7.1+-x64-linux.tar.gz" && \
    tar zxvpf ncbi-blast-2.7.1+-x64-linux.tar.gz && \ 
    rm ncbi-blast-2.7.1+-x64-linux.tar.gz

ENV PATH "$PATH:/home/jovyan/software/ncbi-blast-2.7.1+/bin"


WORKDIR /home/jovyan/notebooks

RUN echo '**************************************' && \
    echo '*******Binder NanoDJ *****************' && \
    echo '**************************************' && \
    git init && \
    git remote add origin -f https://github.com/genomicsIter/NanoDJ && \
    git pull origin binder && \
    rm -rf .git && \
    chown -R jovyan:users ~/notebooks 

USER jovyan
CMD jupyter lab --allow-root



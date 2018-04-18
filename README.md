# NanoDJ

NanoDJ is a Jupyter notebook integration of tools for simplified manipulation and assembly of DNA sequences produced by ONT devices. It integrates basecalling, read trimming and quality control, simulation and plotting routines with a variety of widely used aligners and assemblers, including procedures for hybrid assembly. 

NanoDJ is built as a Docker container that runs a Jupyter Lab instance. The user can work with ONT data using the notebooks that are provided or open a new Jupyter Lab session and run the icluded software packages.

*NanoDJ has been tested using a clean Ubuntu virtual machine only with Docker v1.13.1 installed*

### **Run NanoDJ container:**

Clone the repository and build the image locally (soon on Dockerhub):

```
git clone https://github.com/genomicsITER/NanoDJ.git
cd NanoDJ
docker build -t nanodj:latest .
```

Create a container with the image:

```
docker run -it --rm -p 8888:8888 -v nanodj_notebooks:/home/jovyan/notebooks nanodj:latest
```

Open the localhost:8888/*token* link that appears in the output after the Jupyter Lab instance is started.

NanoDJ includes data and notebooks. However, a volume (the -v option) should be created to import these materials. With this volume, input and output data and modified notebooks can be saved on your host machine. 

**Escherichia coli data links:**

- 1D: <https://s3.climb.ac.uk/nanopore/E_coli_K12_1D_R9.2_SpotON_2.tgz>
- 2D: https://s3.climb.ac.uk/nanopore/R9_Ecoli_K12_MG1655_lambda_MinKNOW_0.51.1.62.tar

**Human DNA mitochondrial data:**

- https://github.com/nanopore-wgs-consortium/NA12878/blob/master/Genome.md


**Porechop notebook data:**

-  https://github.com/rrwick/Porechop/files/901044/1_out.fastq.zip

**Streptococcus agalactiae Illumina reads (PE300) and R9.0 SpotON FAST5 files:**

- To be released.
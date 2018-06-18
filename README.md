![alt text](https://i.imgur.com/UmUUyLp.png "NanoDJ-logo")

NanoDJ is a Jupyter notebook integration of tools for simplified manipulation and assembly of DNA sequences produced by ONT devices. It integrates basecalling, read trimming and quality control, simulation and plotting routines with a variety of widely used aligners and assemblers, including procedures for hybrid assembly. 

![alt text](https://i.imgur.com/r2ls27U.png "NanoDJ-pipeline")

NanoDJ is built as a Docker container that runs a Jupyter Lab instance. The user can work with ONT data using the notebooks that are provided or open a new Jupyter Lab session and run the included software packages.

*NanoDJ has been tested using a clean Ubuntu virtual machine only with Docker v1.13.1 installed*

### **Run NanoDJ container:**

Clone the repository and pull the image from Dockerhub (recommended):

```
git clone https://github.com/genomicsITER/NanoDJ.git
cd NanoDJ
docker pull hecrp/nanodj:latest
```

*The NanoDJ image can be also built locally using *docker build -t nanodj:latest .*

Create a container with the image:

```
docker run -it --rm -p 8888:8888 -v /path/to/nanodjrepo/nanodj_notebooks:/home/jovyan/notebooks nanodj:latest
```

Open the localhost:8888/*token* link that appears in the output after the Jupyter Lab instance is started.

NanoDJ includes data and notebooks. However, a volume (the -v option) should be created to import these materials. With this volume, input and output data and modified notebooks can be saved on your host machine. 

**Mac users**

Notebooks directory must be added in the Docker GUI options (on file sharing section) before mounting that directory. Once it is in the list, volume should be mounted with the -v option as usual.

**Windows users**

Check that the directory that is going to be mounted is under the C:\Users directory. This path is written as "/c/Users/" in the -v option.

*On Windows 8.1, the Jupyter Lab instance cannot be accessed from localhost:8888/lab. "localhost" must be replaced with the IP of the VM that runs Docker on your system.*

**Write permission on notebook files**

Files and directories mounted as a volume doesn't have the [UID and GID](https://en.wikipedia.org/wiki/User_identifier) of the container's user (*jovyan*) so changes in notebooks can't be saved. You should change the owner of the mounted files with this command on your host machine after cloning the repository.

```
sudo chown -R 1000:100 ./nanodj_notebooks
```

With this command we change the owner recursively setting the UID and GID with the *jovyan* user values.

### Additional data

**Escherichia coli data links:**

- 1D: <https://s3.climb.ac.uk/nanopore/E_coli_K12_1D_R9.2_SpotON_2.tgz>
- 2D: https://s3.climb.ac.uk/nanopore/R9_Ecoli_K12_MG1655_lambda_MinKNOW_0.51.1.62.tar

**Human DNA mitochondrial data:**

- https://github.com/nanopore-wgs-consortium/NA12878/blob/master/Genome.md


**Porechop notebook data:**

-  https://github.com/rrwick/Porechop/files/901044/1_out.fastq.zip

**Streptococcus agalactiae Illumina reads (PE300) and R9.0 SpotON FAST5 files:**

- To be released.

### **NanoDJ support:**

Feel free to open a new issue on this repository or contact us by email: *genomica@iter.es*  

**NanoDJ image logo by Daniel Medina (IG:@danymedale)**  

### **How to cite NanoDJ:**

Rodríguez-Pérez H, Hernández-Beeftink T, Lorenzo-Salazar JM, Roda-García JL, Pérez-González CJ, Colebrook M, Flores C. (2018) NanoDJ: A Dockerized Jupyter Notebook for Interactive Oxford Nanopore MinION Sequence Manipulation and Genome Assembly. Submitted.  

*NanoDJ image logo by Daniel Medina (IG:@danymedale)*  

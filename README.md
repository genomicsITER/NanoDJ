[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/genomicsITER/NanoDJ/binder)
[![VICE](https://cyverse-nanodj.readthedocs-hosted.com/en/latest/_images/vice_badge.png)](https://de.cyverse.org/de/?type=apps&app-id=b0e5bdc4-6226-11e9-a28f-008cfa5ae621&system-id=de)



![alt text](https://i.imgur.com/UmUUyLp.png "NanoDJ-logo")

NanoDJ is a [Jupyter](http://jupyter.org/) notebook integration of tools for simplified manipulation and assembly of DNA sequences produced by [ONT](https://nanoporetech.com/) devices. It integrates basecalling, read trimming and quality control, simulation and plotting routines with a variety of widely used aligners and assemblers, including procedures for hybrid assembly. 

![alt_text](https://github.com/genomicsITER/NanoDJ/blob/master/NanoDJ_pipeline_chart.png "NanoDJ-pipeline2")

NanoDJ is built as a [Docker](https://www.docker.com/) container that runs a [Jupyter Lab](https://jupyterlab.readthedocs.io/en/stable/) instance. The user can work with ONT data using the notebooks that are provided or open a new Jupyter Lab session and run the included software packages.

This project is now integrated in [VICE](https://cyverse-visual-interactive-computing-environment.readthedocs-hosted.com/en/latest/getting_started/about.html), a visual and interactive computing environment which is part of [CyVerse](https://www.cyverse.org/), a project that consist of platforms, tools and services built in order to provide life scientists with powerful computational infrastructure to handle huge datasets and complex analyses.

*NanoDJ has been tested using a clean Ubuntu virtual machine only with Docker v1.13.1 installed*

### **Run NanoDJ container:**

Clone the repository and pull the image from [Docker Hub](https://hub.docker.com/) (recommended):

```
git clone https://github.com/genomicsITER/NanoDJ.git
cd NanoDJ
docker pull genomicsiter/nanodj:latest
```

*The NanoDJ image can be also built locally using *docker build -t genomicsiter/nanodj:latest .*

Create a container with the image:

```
docker run -it --rm -p 8888:8888 -v /path/to/nanodjrepo/nanodj_notebooks:/home/jovyan/notebooks genomicsiter/nanodj:latest
```
In order to spawn the Bandage GUI from NanoDJ on your machine, you should run the container setting the [DISPLAY](https://askubuntu.com/questions/432255/what-is-the-display-environment-variable) environment variable and mounting the [X11](https://en.wikipedia.org/wiki/X_Window_System) socket as shown below. This is only valid for Linux users:

```
docker run -it --rm -p 8888:8888 \  
           -e DISPLAY=$DISPLAY \  
           -v /tmp/.X11-unix:/tmp/.X11-unix \  
           -v /path/to/NanoDJ/nanodj_notebooks:/home/jovyan/notebooks \  
           genomicsiter/nanodj:latest
```

After running the *docker run* command, open  the localhost:8888/*token* link that appears in the output after the Jupyter Lab instance is started.

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

- MinION reads: https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA451111
- Illumina MiSeq reads: https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA451107

### **Getting help with NanoDJ**

Feel free to open a new issue on this repository or contact us by email: *genomica@iter.es*  

### **How to cite NanoDJ:**

Rodríguez-Pérez H, Hernández-Beeftink T, Lorenzo-Salazar JM, Roda-García JL, Pérez-González CJ, Colebrook M, Flores C. NanoDJ: A Dockerized Jupyter Notebook for Interactive Oxford Nanopore MinION Sequence Manipulation and Genome Assembly. BMC Bioinformatics (2019 20:234) https://doi.org/10.1186/s12859-019-2860-z

### **Funding:**

This research was funded by the Instituto de Salud Carlos III (grants PI14/00844 and PI17/00610), the Spanish Ministry of Science, Innovation and Universities (grant RTC-2017-6471-1; MINECO/AEI/FEDER, UE), the Spanish Ministry of Economy and Competitiveness (grant MTM2016-74877-P), which were co-financed by the European Regional Development Funds ‘A way of making Europe’ from the European Union, and by the agreement OA17/008 with Instituto Tecnológico y de Energías Renovables ([ITER](http://www.iter.es/)) to strengthen scientific and technological education, training, research, development and innovation in Genomics, Personalized Medicine and Biotechnology.

**NanoDJ image logo by Daniel Medina (IG:@danymedale)** 

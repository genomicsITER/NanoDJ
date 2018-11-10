```markdown
### NanoDJ notebooks index

| Notebook                                | Description                                                  |
| --------------------------------------- | :----------------------------------------------------------- |
| **0.0_QualityControl.ipynb**            | Evaluate the quality control and sequence handling.          |
| **1.0_Basecalling.ipynb**               | Translates the events or the raw electrical signal from an ONT sequencer (FAST5 format) to a DNA sequence to obtain a FASTA or a FASTQ file.     |
| **1.1_Trim+Demux.ipynb**                | Perform sequence trimming and demultiplexing.                |
| **2.0_DeNovo_Canu-Miniasm.ipynb**       | De novo assembly with Canu or Miniasm, and polish with Racon and Pilon.               |
| **3.0_DeNovo_Canu+polish.ipynb**        | Nanopolish modules to improve the Canu assembly.             |
| **4.0_DeNovo_Flye.ipynb**               | De novo assembly with Flye software.                         |
| **5.0_DeNovo_Hybrid.ipynb**             | Perform de novo assembly of Nanopore reads in conjunction with Illumina reads using MaSuRCA and/or Unicycler software. |
| **6.0_AssemblyCompare.ipynb**           | Compare distinct assembly results based on QUAST software    |
| **7.0_SimulateReads.ipynb**             | Obtain simulated reads made with Nanosim software and the Nanosim-h fork with precomputed models |
| **8.0_Alignment.ipynb**                 | Reference-based assembly using either BWA, BLAST or Rebaler software                       |
| **9.0_AssemblyGraph.ipynb**             | Assembly graph visualization.                                |
| **Educational.ipynb**                   | Performs basecalling (with Albacore), quality control steps, and a BLAST-based classification of the reads (for educational purposes) |
```
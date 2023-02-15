<h1 align="center">Mycoplasma_target</h1>

## What to do
The pipeline in Nextflow workflow can be used to analyze the NGS data from Mycoplasma. The analyses include SNPs calling, read coverage, read depth, read quality, quality control, etc. 

## Prerequisites
Nextflow should be installed. The detail of installation can be found in https://github.com/nextflow-io/nextflow.

Python3 is needed.

Singularity/Apptainer is also needed. The detail of installation can be found in https://apptainer.org/

In addition, the below docker container images are needed in the pipeline. These images should be downloaded to the directory /apps/staphb-toolkit/containers/ in your local computer. You can find them from StaPH-B/docker-builds (https://github.com/StaPH-B/docker-builds).

1. fastqc_0.11.9.sif
2. trimmomatic_0.39.sif
3. bbtools_38.76.sif
4. multiqc_1.8.sif
5. bwa_0.7.17.sif
6. samtools_1.12.sif
7. bcftools 1.13-37


## How to run
1. put your data files into directory /fastqs. Your data file's name should look like "JBS22002292_1.fastq.gz", "JBS22002292_2.fastq.gz" 
2. open file "parames.yaml", set the parameters. 
3. get into the top directory of the pipeline, run "sbatch mycoplasma_target.sh"

#### Note: some sample data files can be found in directory /fastqs/test_sample

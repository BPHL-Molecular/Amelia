<h1 align="center">Amelia</h1>

## What to do
The Nextflow pipeline can be used to analyze the NGS data from Mycoplasma. The analyses include read coverage, read depth, read quality, quality control, SNP calling and related amino acid variation etc. 

## Prerequisites
Nextflow should be installed. The detail of installation can be found in https://github.com/nextflow-io/nextflow.

Python3 is needed.

Singularity/Apptainer is also needed. The detail of installation can be found in https://apptainer.org/

## How to run
1. put your data files into directory /fastqs. Your data file's name should look like "JBS22002292_1.fastq.gz", "JBS22002292_2.fastq.gz"
2. put your primer information file in bed format into directory /primers.
3. open file "parames.yaml", set the parameters. 
4. get into the top directory of the pipeline and then run command below:

   If you use SLURM, run 
   ```bash
   sbatch amelia.sh
   ```
   If not use SLURM, run 
   ```bash
   bash ./amelia.sh
   ```

## Result

In the final report, except for some columns related to sequencing quality another 7 columns were added. The each column is named by primer name. In each primer column, the outputs are Absolute matching read counts per amplicon, depth per amplicon, Percentage coverage per amplicon, SNPs per amplicon. These outputs are separated by comma. For example, one primer column lists below:
 
```bash
3548,733.1,58.21,T191144A|ATG:AAG|M:K;T191801C|CTC:CCC|L:P
```
It means that in the amplification region mapping reads are 3548,  depth is 733.1, percentage coverage is 58.21, the nucleotide T changes to A at site 191144, (if the SNP occurs at CDS region) the triplet ATG changes to AAG, the amino acid M changes to K; the second SNP is T to C at site 191801, triplet changes from CTC to CCC, amino acid changes from L to P.

If no SNPs occur at an amplification region, "None" will be added to the output. For example,
```bash 
2977,609.2,58.21,None
```
If SNPs do not occur at CDS region, such as rRNA, no triplet and amino acid will be outputted. For example,
```bash
9,1.5,45.82,A173799G
```
#### Note: some sample data files can be found in directory /fastqs/test_sample. A sample of primer bed file can be found in /primers. 

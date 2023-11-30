#!/bin/bash
#SBATCH --account=bphl-umbrella
#SBATCH --qos=bphl-umbrella
#SBATCH --job-name=amelia
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=25
#SBATCH --mem=150gb
#SBATCH --output=amelia.%j.out
#SBATCH --error=amelia.%j.err
#SBATCH --time=3-00


#module load singularity
module load apptainer


###### run normal pipeline
nextflow run myco_target.nf -params-file params.yaml

sort ./output/*/report.txt | uniq > ./output/sum_report.txt
titleline=$(grep 'reference' ./output/sum_report.txt)
sed -i '/sampleID\treference/d' ./output/sum_report.txt
sed -i "1i $titleline" ./output/sum_report.txt

cp ./output/*/variants/*.vcf ./output/variants/
#cat ./output/assemblies/*.fa > ./output/assemblies.fasta
#singularity exec /apps/staphb-toolkit/containers/nextclade_2021-03-15.sif nextclade --input-fasta ./output/assemblies.fasta --output-csv ./output/nextclade_report.csv





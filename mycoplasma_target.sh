#!/bin/bash
#SBATCH --account=bphl-umbrella
#SBATCH --qos=bphl-umbrella
#SBATCH --job-name=mycoplasma_target_nf
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=25
#SBATCH --mem=100gb
#SBATCH --output=mycoplasma_target.%j.out
#SBATCH --error=mycoplasma_target.%j.err
#SBATCH --time=3-00


#module load singularity
module load apptainer


###### run normal pipeline
nextflow run myco_target.nf -params-file params.yaml

sort ./output/*/report.txt | uniq > ./output/sum_report.txt
sed -i '/sampleID\treference/d' ./output/sum_report.txt
sed -i '1i sampleID\treference\tstart\tend\tnum_raw_reads\tnum_clean_reads\tnum_mapped_reads\tpercent_mapped_clean_reads\tcov_bases_mapped\tpercent_genome_cov_map\tmean_depth\tmean_base_qual\tmean_map_qual' ./output/sum_report.txt

cp ./output/*/variants/*.vcf ./output/variants/
#cat ./output/assemblies/*.fa > ./output/assemblies.fasta
#singularity exec /apps/staphb-toolkit/containers/nextclade_2021-03-15.sif nextclade --input-fasta ./output/assemblies.fasta --output-csv ./output/nextclade_report.csv





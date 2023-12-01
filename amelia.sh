#!/bin/bash
#SBATCH --account=bphl-umbrella
#SBATCH --qos=bphl-umbrella
#SBATCH --job-name=amelia
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=200gb
#SBATCH --output=amelia.%j.out
#SBATCH --error=amelia.%j.err
#SBATCH --time=48:00:00
#SBATCH --mail-user=<EMAIL>
#SBATCH --mail-type=FAIL,END

module load apptainer
module load nextflow
APPTAINER_CACHEDIR=./
export APPTAINER_CACHEDIR


###### run normal pipeline
nextflow run myco_target.nf -params-file params.yaml

sort ./output/*/report.txt | uniq > ./output/sum_report.txt
titleline=$(grep 'reference' ./output/sum_report.txt)
sed -i '/sampleID\treference/d' ./output/sum_report.txt
sed -i "1i $titleline" ./output/sum_report.txt

cp ./output/*/variants/*.vcf ./output/variants/

mv ./*.out ./output
mv ./*err ./output

dt=$(date "+%Y%m%d%H%M%S")
mv ./output ./output-$dt

rm -r ./work




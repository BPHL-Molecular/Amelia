#!/usr/bin/env nextflow

/*
Note:
Before running the script, please set the parameters in the config file params.yaml
*/

//Step1:input data files
nextflow.enable.dsl=2
def L001R1Lst = []
def sampleNames = []
myDir = file("$params.input")

myDir.eachFileMatch ~/.*_1.fastq.gz/, {L001R1Lst << it.name}
L001R1Lst.sort()
L001R1Lst.each{
   def x = it.minus("_1.fastq.gz")
     //println x
   sampleNames.add(x)
}
//println L001R1Lst
//println sampleNames


//Step2: process the inputed data
A = Channel.fromList(sampleNames)
//A.view()

include { fastqc } from './modules/fastqc.nf'
include { trimmomatic } from './modules/trimmomatic.nf'
include { bbduk } from './modules/bbduk.nf'
include { fastqc_clean } from './modules/fastqc_clean.nf'
include { multiqc } from './modules/multiqc.nf'
include { frag_bwa } from './modules/frag_bwa.nf'
include { frag_samtools } from './modules/frag_samtools.nf'
include { bcftools } from './modules/bcftools.nf'
include { amplicon_stat } from './modules/amplicon_stat.nf'
include { bedtools } from './modules/bedtools.nf'
include { pystats } from './modules/pystats.nf'

workflow {   
  fastqc(A)| trimmomatic | bbduk | fastqc_clean | multiqc | frag_bwa | frag_samtools | bcftools | amplicon_stat | bedtools | pystats | view   
}



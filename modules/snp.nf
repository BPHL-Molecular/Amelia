process snp {
    input:
        val mypath
    output:
        //stdout
        val mypath
        //path "pyoutputs.txt", emit: pyoutputs
        
    
    """ 
    samplename=\$(echo ${mypath} | rev | cut -d "/" -f 1 | rev)
    #Call variants
    mkdir ${mypath}/variants
    singularity exec docker://staphb/samtools:1.12 samtools mpileup -A -d 8000 --reference ${params.reference}/L43967.2.fasta -B -Q 0 ${mypath}/alignment/\${samplename}.sorted.bam -o ${mypath}/alignment/\${samplename}.sorted.bam.mpileup
    #bcftools mpileup -d 8000 -f ${params.reference}/L43967.2.fasta -B -a FORMAT/AD ${mypath}/alignment/\${samplename}.sorted.bam | bcftools call -mv -Ov | bcftools norm -f ${params.reference}/L43967.2.fasta - | bcftools filter -e 'QUAL < 20' - > ${mypath}/variants/\${samplename}.variants.vcf
    singularity exec docker://staphb/bcftools:1.12 bcftools mpileup -d 8000 -f ${params.reference}/L43967.2.fasta -B -a FORMAT/AD ${mypath}/alignment/\${samplename}.sorted.bam | singularity exec docker://staphb/bcftools:1.12 bcftools call -mv -Ov | singularity exec docker://staphb/bcftools:1.12 bcftools norm -f ${params.reference}/L43967.2.fasta - | singularity exec docker://staphb/bcftools:1.12 bcftools filter -e 'QUAL < 20' - > ${mypath}/variants/\${samplename}.variants.vcf
    
    # amplicon statistics
    singularity exec docker://staphb/samtools:1.12 samtools ampliconstats ${params.primer}/primer.bed ${mypath}/alignment/\${samplename}.sorted.bam -o ${mypath}/astats -l 10000
    
    # intersect of reference gff file and variant (SNP) VCF file
    singularity exec docker://staphb/bedtools:latest bedtools intersect -a ${params.reference}/L43967.2.gff3 -b ${mypath}/variants/\${samplename}.variants.vcf -wa -u > ${mypath}/intersect 
    
    ############################################
    #Generate consensus assembly
    ##mkdir ${mypath}/assembly
    ##bcftools view -Oz -o ${mypath}/variants/\${samplename}.variants.vcf.gz ${mypath}/variants/\${samplename}.variants.vcf
    ##bcftools index ${mypath}/variants/\${samplename}.variants.vcf.gz
    ##bcftools consensus -f ${params.reference}/L43967.2.fasta -o ${mypath}/assembly/\${samplename}.consensus ${mypath}/variants/\${samplename}.variants.vcf.gz
    #############################################
    """
}

process bcftools {
    input:
        val mypath
    output:
        //stdout
        val mypath
        //path "pyoutputs.txt", emit: pyoutputs
        
    
    """ 
    samplename=\$(echo ${mypath} | rev | cut -d "/" -f 1 | rev)
    
    bcftools mpileup -d 8000 -f ${params.reference}/L43967.2.fasta -B -a FORMAT/AD ${mypath}/alignment/\${samplename}.sorted.bam | bcftools call -mv -Ov | bcftools norm -f ${params.reference}/L43967.2.fasta - | bcftools filter -e 'QUAL < 20' - > ${mypath}/variants/\${samplename}.variants.vcf
    
    """
}

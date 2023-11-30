process bedtools {
    input:
        val mypath
    output:
        //stdout
        val mypath
        //path "pyoutputs.txt", emit: pyoutputs
        
    
    """ 
    samplename=\$(echo ${mypath} | rev | cut -d "/" -f 1 | rev)
        
    # intersect of reference gff file and variant (SNP) VCF filte
    bedtools intersect -a ${params.reference}/L43967.2.gff3 -b ${mypath}/variants/\${samplename}.variants.vcf -wa -u > ${mypath}/intersect 
       
    """
}

process amplicon_stat {
    input:
        val mypath
    output:
        //stdout
        val mypath
        //path "pyoutputs.txt", emit: pyoutputs
        
    
    """ 
    samplename=\$(echo ${mypath} | rev | cut -d "/" -f 1 | rev)
    
    # amplicon statistics
    samtools ampliconstats ${params.primer}/primer.bed ${mypath}/alignment/\${samplename}.sorted.bam -o ${mypath}/astats -l 10000
    
    """
}

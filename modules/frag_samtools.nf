process frag_samtools {
    input:
        val mypath
 
    output:
        //stdout
        val mypath
        //path "pyoutputs.txt", emit: pyoutputs

    """
    samplename=\$(echo ${mypath} | rev | cut -d "/" -f 1 | rev)
    
    samtools view -F 4 -u -h -bo ${mypath}/aln-se.bam ${mypath}/aln-se.sam
    samtools sort -n -o ${mypath}/alignment/\${samplename}.namesorted.bam ${mypath}/aln-se.bam
    
    samtools fixmate -m ${mypath}/alignment/\${samplename}.namesorted.bam ${mypath}/alignment/\${samplename}.fixmate.bam

    #Create positional sorted bam from fixmate.bam
    samtools sort -o ${mypath}/alignment/\${samplename}.positionsort.bam ${mypath}/alignment/\${samplename}.fixmate.bam

    #Mark duplicate reads
    samtools markdup ${mypath}/alignment/\${samplename}.positionsort.bam ${mypath}/alignment/\${samplename}.markdup.bam

    #Remove duplicate reads
    samtools markdup -r ${mypath}/alignment/\${samplename}.positionsort.bam ${mypath}/alignment/\${samplename}.dedup.bam

    #Sort dedup.bam and rename to .sorted.bam
    samtools sort -o ${mypath}/alignment/\${samplename}.sorted.bam ${mypath}/alignment/\${samplename}.dedup.bam

    #Index final sorted bam
    samtools index ${mypath}/alignment/\${samplename}.sorted.bam
    
    #coverage of reads
    samtools coverage ${mypath}/alignment/\${samplename}.sorted.bam -o ${mypath}/alignment/\${samplename}.coverage.txt

    #Call variants
    mkdir ${mypath}/variants
    samtools mpileup -A -d 8000 --reference ${params.reference}/L43967.2.fasta -B -Q 0 ${mypath}/alignment/\${samplename}.sorted.bam -o ${mypath}/alignment/\${samplename}.sorted.bam.mpileup


    """
}

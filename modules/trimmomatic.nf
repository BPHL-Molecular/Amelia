process trimmomatic {
   input:
      val x
   output:
      //stdout
      //path 'xfile.txt', emit: aLook
      val x
      //path "${params.output}/${x}_trim_2.fastq", emit: trimR2
      
   """    
   #Run trimmomatic
   trimmomatic PE -phred33 -trimlog ${params.output}/${x}/${x}.log ${params.output}/${x}/${x}_1.fastq.gz ${params.output}/${x}/${x}_2.fastq.gz ${params.output}/${x}/${x}_trim_1.fastq.gz ${params.output}/${x}/${x}_unpaired_trim_1.fastq.gz ${params.output}/${x}/${x}_trim_2.fastq.gz ${params.output}/${x}/${x}_unpaired_trim_2.fastq.gz SLIDINGWINDOW:4:30 MINLEN:75 TRAILING:20 > ${params.output}/${x}/${x}_trimstats.txt

   rm ${params.output}/${x}/${x}_unpaired_trim_*.fastq.gz
   #rm ${params.output}/${x}/${x}_1.fastq.gz ${params.output}/${x}/${x}_2.fastq.gz
   """
}

process fastqc_clean {
   input:
      val x
   output:
      //stdout
      //path 'xfile.txt', emit: aLook
      val x
      //path "${params.output}/${x}_trim_2.fastq", emit: trimR2
      
   """  
   #Run fastqc on clean forward and reverse reads
   fastqc ${params.output}/${x}/${x}_1.fq.gz ${params.output}/${x}/${x}_2.fq.gz

   #Rename fastqc output files
   mv ${params.output}/${x}/${x}_1_fastqc.html ${params.output}/${x}/${x}_1_clean_fastqc.html
   mv ${params.output}/${x}/${x}_1_fastqc.zip ${params.output}/${x}/${x}_1_clean_fastqc.zip
   mv ${params.output}/${x}/${x}_2_fastqc.html ${params.output}/${x}/${x}_2_clean_fastqc.html
   mv ${params.output}/${x}/${x}_2_fastqc.zip ${params.output}/${x}/${x}_2_clean_fastqc.zip
   """
}

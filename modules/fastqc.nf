process fastqc {
   input:
      val x
   output:
      //stdout
      //path 'xfile.txt', emit: aLook
      val x
      //path "${params.output}/${x}_trim_2.fastq", emit: trimR2
      
   """  
   #echo ${params.input}/${x}_1.fastq.gz >> xfile.txt
   
   #mkdir -p ${params.output}/assemblies
   mkdir -p ${params.output}/variants
   #mkdir -p ${params.output}/vadr_error_reports
   mkdir -p ${params.output}/${x}
   cp ${params.input}/${x}_*.fastq.gz ${params.output}/${x}
   
   #Run fastqc on original reads
   fastqc ${params.output}/${x}/${x}_1.fastq.gz ${params.output}/${x}/${x}_2.fastq.gz

   mv ${params.output}/${x}/${x}_1_fastqc.html ${params.output}/${x}/${x}_1_original_fastqc.html
   mv ${params.output}/${x}/${x}_1_fastqc.zip ${params.output}/${x}/${x}_1_original_fastqc.zip
   mv ${params.output}/${x}/${x}_2_fastqc.html ${params.output}/${x}/${x}_2_original_fastqc.html
   mv ${params.output}/${x}/${x}_2_fastqc.zip ${params.output}/${x}/${x}_2_original_fastqc.zip
   """
}

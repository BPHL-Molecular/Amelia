process multiqc {
   input:
      val x
   output:
      //stdout
      //path 'xfile.txt', emit: aLook
      val "${params.output}/${x}", emit: outputpath1
      //path "${params.output}/${x}_trim_2.fastq", emit: trimR2
      
   """    
   #Run multiqc
   multiqc ${params.output}/${x}/${x}_*_fastqc.zip -o ${params.output}/${x}

   #Map reads to reference
   mkdir ${params.output}/${x}/alignment
   """
}

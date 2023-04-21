process pystats {
    input:
        val mypath
    output:
        stdout
        //val mypath
        //path "pyoutputs.txt", emit: pyoutputs
        
    $/
    #!/usr/bin/env python3
    
    import subprocess
    #import glob
    from Bio import SeqIO
    items = "${mypath}".strip().split("/")
    #print(items[-1])
    filepath1 = "${mypath}"+"/alignment/"+items[-1]+".coverage.txt"
    #print(filepath1)
    with open(filepath1, 'r') as cov_report:
        header = cov_report.readline()
        header = header.rstrip()
        stats = cov_report.readline()
        stats = stats.rstrip()
        stats = stats.split()
        ref_name = stats[0]
        #print(ref_name)
        start = stats[1]
        end = stats[2]
        reads_mapped = stats[3]
        cov_bases = stats[4]
        cov = stats[5]
        depth = stats[6]
        baseq = stats[7]
        #print(reads_mapped)
        mapq = stats[8]
        
    #Get number of raw reads
    proc_1 = subprocess.run('zcat ' + "${mypath}/" + items[-1] + '_1.fastq.gz | wc -l', shell=True, capture_output=True, text=True, check=True)
    wc_out_1 = proc_1.stdout.rstrip()
    reads_1 = int(wc_out_1) / 4
    proc_2 = subprocess.run('zcat ' + "${mypath}/" + items[-1] + '_2.fastq.gz | wc -l', shell=True, capture_output=True, text=True, check=True)
    wc_out_2 = proc_2.stdout.rstrip()
    reads_2 = int(wc_out_2) / 4
    raw_reads = reads_1 + reads_2
    raw_reads = int(raw_reads)

    #Get number of clean reads
    proc_c1x = subprocess.run('zcat ' + "${mypath}/" + items[-1] + '_1.fq.gz | wc -l', shell=True, capture_output=True, text=True, check=True)
    wc_out_c1x = proc_c1x.stdout.rstrip()
    reads_c1x = int(wc_out_c1x) / 4
    proc_c2x = subprocess.run('zcat ' + "${mypath}/" + items[-1] + '_2.fq.gz | wc -l', shell=True, capture_output=True, text=True, check=True)
    wc_out_c2x = proc_c2x.stdout.rstrip()
    reads_c2x = int(wc_out_c2x) / 4
    clean_reads = reads_c1x + reads_c2x
    clean_reads = int(clean_reads)
    #print(clean_reads)
    
    #Get percentage of mapped reads/clean reads
    percent_map = "%0.4f"%((int(reads_mapped)/int(clean_reads))*100)
    #print(percent_map)
    
    ############################################################################
    
    primerfile = "${params.primer}"+"/primer.bed"
    ampstatsfile = "${mypath}" + "/astats"
    variantfile = "${mypath}" + "/variants/" + items[-1]+".variants.vcf"
    genefile = "${mypath}" + "/intersect"
    reffile = "${params.reference}" + "/L43967.2.fasta"
    
    ####### function 1 #################
    def triplet(snpsite,ref,alt):
        print(snpsite)
        print(ref)
        print(alt)
        with open(genefile) as genes:
             lines = genes.readlines()
             tripletstart=[]
             triplets=[]
             num = len(lines)
             for aidx in range(0,num):
                 cells=lines[aidx].rstrip().split("\t")
                 if (cells[2] == "CDS") and (int(snpsite) >= int(cells[3])) and (int(snpsite) <= int(cells[4])):
                    print(str(cells[4])+">="+str(snpsite)+">="+str(cells[3]))
                    snpsite_in_cds = int(snpsite)-int(cells[3])+1
                    if cells[7]=="0":
                       tri_remainder = snpsite_in_cds % 3
                    if cells[7]=="1":
                       tri_remainder = (snpsite_in_cds-2) % 3
                    if cells[7]=="2":
                       tri_remainder = (snpsite_in_cds-1) % 3
                       
                    if tri_remainder == 0:
                       tripletstart.append(str(int(snpsite)-2)+"|3")
                    if tri_remainder == 1:
                       tripletstart.append(str(int(snpsite))+"|1")
                    if tri_remainder == 2:
                       tripletstart.append(str(int(snpsite)-1)+"|2")
             #print(tripletstart)
             if tripletstart:
                fasta_seqs = SeqIO.read(reffile,'fasta')
                for atriplet in tripletstart:
                    subs=atriplet.strip().split("|")
          
                    ### Note: subs is from VCF file which start numbering at 1. But Bio.SeIQ sequence start at 0.
                    ref_tri=fasta_seqs.seq[int(subs[0])-1]+fasta_seqs.seq[int(subs[0])]+fasta_seqs.seq[int(subs[0])+1]
                    alt_tri=""
                    print(subs[1])
                    if int(subs[1]) == 1:
                       alt_tri = alt+fasta_seqs.seq[int(subs[0])]+fasta_seqs.seq[int(subs[0])+1]
                    if int(subs[1]) == 2:
                       alt_tri = fasta_seqs.seq[int(subs[0])-1]+alt+fasta_seqs.seq[int(subs[0])+1]
                    if int(subs[1]) == 3:
                       alt_tri = fasta_seqs.seq[int(subs[0])-1]+fasta_seqs.seq[int(subs[0])]+alt
                    triplets.append(ref_tri+":"+ alt_tri) 
         
             else:
                print("triplet is empty")
        return triplets 
    
    ########## function 2 #############################################  
    def translate(triplet):
      genetic_code={
          "TTT":"F",
          "TTC":"F",
          "TTA":"L",
          "TTG":"L",
          "TCT":"S",
          "TCC":"S",
          "TCA":"S",
          "TCG":"S",
          "TAT":"Y",
          "TAC":"Y",
          "TAA":"*",
          "TAG":"*",
          "TGT":"C",
          "TGC":"C",
          "TGA":"*",
          "TGG":"W",
          "CTT":"L",
          "CTC":"L",
          "CTA":"L",
          "CTG":"L",
          "CCT":"P",
          "CCC":"P",
          "CCA":"P",
          "CCG":"P",
          "CAT":"H",
          "CAC":"H",
          "CAA":"Q",
          "CAG":"Q",
          "CGT":"R",
          "CGC":"R",
          "CGA":"R",
          "CGG":"R",
          "ATT":"I",
          "ATC":"I",
          "ATA":"I",
          "ATG":"M",
          "ACT":"T",
          "ACC":"T",
          "ACA":"T",
          "ACG":"T",
          "AAT":"N",
          "AAC":"N",
          "AAA":"K",
          "AAG":"K",
          "AGT":"S",
          "AGC":"S",
          "AGA":"R",
          "AGG":"R",
          "GTT":"V",
          "GTC":"V",
          "GTA":"V",
          "GTG":"V",
          "GCT":"A",
          "GCC":"A",
          "GCA":"A",
          "GCG":"A",
          "GAT":"D",
          "GAC":"D",
          "GAA":"E",
          "GAG":"E",
          "GGT":"G",
          "GGC":"G",
          "GGA":"G",
          "GGG":"G"
      }
      aa=""
      for key in genetic_code:
          if triplet == key:
             aa = genetic_code[key]
             break
      return aa  
    
    ##### main program #############################
    
    # get primers from primer.bed
    primers=[]
    leftsites=[]
    rightsites=[]
    with open(primerfile, 'r', encoding='unicode_escape') as primer:
        lines = primer.readlines()
        num = len(lines)
        for odd in range(0,num,2):
            oddline = lines[odd].strip()
            cells = oddline.split("\t")
            leftsites.append(cells[1])
            subcells = cells[3].split("_F")
            primers.append(subcells[0])
    
        for even in range(1,num,2):
            evenline = lines[even].strip()
            cells = evenline.split("\t")
            rightsites.append(cells[2])
      
    #print(leftsites)
    #print(rightsites)

    # get amplicon stats 
    ## Absolute matching read counts per amplicon 
    reads_matched = []
    proc_1y = subprocess.run('grep ^FREADS '+ ampstatsfile + ' | cut -f 3-', shell=True, capture_output=True, text=True, check=True)  
    wc_out_1y = proc_1y.stdout.rstrip()  
    #print(wc_out_1y)  
    cells = wc_out_1y.split("\t")
    for acell in cells:
        reads_matched.append(acell)
    #print(reads_matched)

    ## Read depth per amplicon
    reads_depth = []
    proc_2y = subprocess.run('grep ^FDEPTH '+ ampstatsfile + ' | cut -f 3-', shell=True, capture_output=True, text=True, check=True)  
    wc_out_2y = proc_2y.stdout.rstrip()
    cells = wc_out_2y.split("\t")
    for acell in cells:
        reads_depth.append(acell)
    #print(reads_depth)

    ## Percentage coverage per amplicon
    coverage_amp = []
    proc_3y = subprocess.run('grep ^FPCOV '+ ampstatsfile + ' | cut -f 3-', shell=True, capture_output=True, text=True, check=True)  
    wc_out_3y = proc_3y.stdout.rstrip()
    cells = wc_out_3y.split("\t")
    for acell in cells:
        coverage_amp.append(acell)
    #print(coverage_amp)

    # get variants and their site in genes
    pnum = len(leftsites)
    variants = [None]*pnum
    with open(variantfile,'r') as varfile:
         lines = varfile.readlines()
         num = len(lines)
         for anum in range(0,num):
             if(lines[anum].startswith("#")):
                  continue
             cells = lines[anum].split("\t")
             #print(cells[1])
             for idx in range(0,pnum):
             #print(cells)
                  if (int(cells[1]) >= int(leftsites[idx])) and (int(cells[1]) <= int(rightsites[idx])):
                       triplets = triplet(cells[1],cells[3],cells[4])
                       #print(tripletstart)
                       #print(cells[3] + cells[1] + cells[4] + ",")
                       if variants[idx] != None:
                           variants[idx] += ";" + cells[3] + cells[1] + cells[4]
                       else:
                           variants[idx] = cells[3] + cells[1] + cells[4]
           
                       if triplets:
                           aa_pairs=[]
                           for pair in triplets:
                               apair = pair.strip().split(":")
                               ref_aa = translate(apair[0])
                               alt_aa = translate(apair[1])
                               aa_pairs.append(ref_aa+":"+alt_aa)
                           variants[idx] += "|" + ";".join(triplets) + "|" + ";".join(aa_pairs)
               
    #print(variants)

    with open("${mypath}"+"/output.txt", 'w') as output:
         output.write("\t".join(primers)+'\n')
         for idx in range(0,pnum):
             output.write(reads_matched[idx]+","+reads_depth[idx]+","+coverage_amp[idx]+","+str(variants[idx])+'\t')

    
    with open("${mypath}"+"/report.txt", 'w') as report:
        header = ['sampleID', 'reference', 'start', 'end', 'num_raw_reads', 'num_clean_reads', 'num_mapped_reads', 'percent_mapped_clean_reads', 'cov_bases_mapped', 'percent_genome_cov_map', 'mean_depth', 'mean_base_qual', 'mean_map_qual']
        report.write('\t'.join(map(str,header)) +'\t'+"\t".join(primers) +'\n')
        results = [items[-1], ref_name, start, end, raw_reads, clean_reads, reads_mapped, percent_map, cov_bases, cov, depth, baseq, mapq]
        for idx in range(0,pnum):
            results.append(reads_matched[idx]+","+reads_depth[idx]+","+coverage_amp[idx]+","+str(variants[idx]))
        report.write('\t'.join(map(str,results)) + '\n')
    /$
}

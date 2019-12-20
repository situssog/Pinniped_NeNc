import re
from sys import argv
script,spp,tbnFile=argv

#out_shifts_coords = open('NEOsch_cds_coords.txt', 'w+')
#out_shifts_coords.write('Gene\tSbjct_Start\tSbjct_End\tFrame\tQuery_Start\tQuery_End\n')
out_shifts_with_Phoca_genes = open(spp+'_cds_coords_ODOrosGenes_blastn.txt', 'w+')
out_shifts_with_Phoca_genes.write('Walrus_gene\tGene\tSbjct_Start\tSbjct_End\tStrand\tQuery_Start\tQuery_End\tLength\tCoordinates\n')
out_coding=open(spp+'_cds_coords_ODOrosGenes_blastn_coding.txt', 'w+')
out_coding.write('Walrus_gene\tGene\tStrand\tCoding\n')
logFile=open('logFile.txt', 'w+')
#    succ_genes = open(disk_location+species+'/successful_refs_'+species+'_ALL.lst').read().splitlines()
#       if gene in succ_genes:
a=open(tbnFile).read().split('Query= ')[1:]
        #seq=open(disk_location+species+'/successful_blasts_'+species+'_ALL/'+species+'_'+species+'_ALL_'+gene+'_tbn.OrdReads').readlines()
        
for i in a:
    coords_query=[]
    coords_sbjct=[]
    coords_sbjct_coding=[]
    strands={}
    lengths=[]
    length=0
    n=i.split("\n")
    if '***** No hits found *****' in n:
        continue
         
    ref_gene=n[0].split("_")[0]+'_'+n[0].split("_")[1]
    print ref_gene
    #length=int(n[n.index('Length=')].replace('Length=',''))
    for x in n:
        if x.startswith('> '):
            gene=x.replace("> ",'')#.split(" ")[0]
            #print gene
            strands[ref_gene]=[]
        elif x.startswith(' Strand='):
            strand=x.replace(' Strand=Plus/','')
            #strand[ref_gene].append(x.replace(' Strand=Plus/',''))
        elif x.startswith('Sbjct'):
            b=x.replace('Sbjct ','').replace('*','-')
            c=re.search(' *[A-Z a-z -]*  ',b)
            #print 'cgroup:',c.group(0)
            m=b.replace(c.group(0),',').replace(' ','')
            #print 'm:',m
            #print int(m.split(',')[0])
            #prinat int(m.split(',')[1])
            coords_sbjct.append(int(m.split(',')[0]))
            coords_sbjct.append(int(m.split(',')[1]))
            coords_sbjct_coding.append([int(m.split(',')[0]),int(m.split(',')[1])])
            strands[ref_gene].append(strand)
        elif x.startswith('Query '):
            b=x.replace('Query ','').replace('*','-')
            c=re.search(' *[A-Z a-z -]*  ', b)
            #print 'cgroup:',c.group(0)
            m=b.replace(c.group(0),',').replace(' ','')
            #print 'm:',m
            coords_query.append(int(m.split(',')[0]))
            coords_query.append(int(m.split(',')[1]))
        #elif x.startswith(' Strand='):
         #   strand[ref_gene].append(x.replace(' Strand=Plus/',''))
        elif x.startswith('Length='):
           lengths.append(x)
    length=int(lengths[0].replace('Length=',''))
    #print 'Plus:',strand[ref_gene].count('Plus')
    #print 'Minus:',strand[ref_gene].count('Minus')
    logFile.write(ref_gene + ' Query: ' + str(sorted(coords_query))+'\n')
    logFile.write(ref_gene + ' Sbjct: ' + str(sorted(coords_sbjct))+'\n')
    
    #if sorted(coords_query)[0] == 1 :#and frame_shifts[gene] == 1:
     #   cds_start=min(coords_sbjct)
            
    #elif sorted(coords_query)[0] > 1 :#and frame_shifts[gene] >= 1:
     #   if sorted(coords_sbjct)[0] == 1:
      #      cds_start=sorted(coords_sbjct)[0]
       # elif sorted(coords_sbjct)[0] > 1:
        #    if sorted(coords_sbjct)[0] - (sorted(coords_query)[0]) >= 1:
         #       cds_start=sorted(coords_sbjct)[0]-(sorted(coords_query)[0])
          #  else:
               #cds_start=sorted(coords_sbjct)[0]-sorted(coords_query)[0]-((sorted(coords_sbjct)[0]-sorted(coords_query)[0]))-1
           #     cds_start=1
   # else:
    cds_start=min(coords_sbjct)
    
    #if max(sorted(coords_query)) < length:
    #    cds_end=max(coords_sbjct)+(length-max(sorted(coords_query))+1)
    #else:
    cds_end=max(coords_sbjct)
    str_final=''
    #str_final_PlusCount = 0
    #str_final_MinusCount = 0
    toRemove=[]
#    for i in strand[ref_gene]:
    if strands[ref_gene].count('Plus') > strands[ref_gene].count('Minus'):
        str_final = 'Plus'
    elif strands[ref_gene].count('Plus') == strands[ref_gene].count('Minus'):
        str_final=strands[ref_gene][0] 
    else:
        str_final= 'Minus'
    print 'Plus:',strands[ref_gene].count('Plus')
    print 'Minus:',strands[ref_gene].count('Minus')
    print coords_sbjct_coding
    print strands[ref_gene]
    for i in range(len(strands[ref_gene])):
        if strands[ref_gene][i] != str_final:
            print strands[ref_gene][i], 'str_final=',str_final
            toRemove.append(coords_sbjct_coding[i])
            #print ref_gene
            #print coords_sbjct_coding
            #coords_sbjct_coding.pop(strand[ref_gene].index(i))
            #strand[ref_gene].pop(strand[ref_gene].index(i))
            #print coords_sbjct_coding
    if len(toRemove) != 0:
        print str_final, toRemove

#    singleStrand_cds_coding=coords_sbjct_coding[:]
    for i in toRemove:
       #singleStrand_cds_coding=singleStrand_cds_coding.remove(i)
        coords_sbjct_coding.remove(i)
    #   print coords_sbjct_coding
        
   
        
    #print 'CDS: %d:%d' %(cds_start, cds_end)
    out_shifts_with_Phoca_genes.write(ref_gene+'\t'+gene+'\t'+str(cds_start)+'\t'+str(cds_end)+'\t'+str_final+'\t'+str(sorted(coords_query)[0])+'\t'+str(sorted(coords_query)[-1])+'\t'+str(length)+'\n')
    out_coding.write(ref_gene+'\t'+gene+'\t'+str_final+'\t'+str(coords_sbjct_coding).replace('[[','[').replace(']]',']')+'\n')
#    print '%s\t%s\t%d\t%d\t%s\t%d\t%d\t%d\n' %(ref_gene,gene, cds_start, cds_end,strand[gene],sorted(coords_query)[0],sorted(coords_query)[-1],length)
    
#    print str(coords_sbjct_coding).replace('[[','[').replace(']]',']')
    #else:
        #print 'No sequence recovered for %s in species %s.' %(gene,species)
       # continue
out_shifts_with_Phoca_genes.close()
out_coding.close()

         

from sys import argv
script,spp=argv
#Coordinates after blast to Walrus
coords_file=open(spp+'_cds_coords_ODOrosGenes_blastn_coding.txt').read().splitlines()[1:]

#Create output file to write tab with coordinates of coding regions
output_file=open(spp+'_cds_coords_coding_seqExt_ordered.txt', 'w+')
output_file.write('Gene\tContig\tStrand\tCoding_seqs\n')
for i in coords_file:
    gene=i.split('\t')[0]
    contig=i.split('\t')[1]
    strand=i.split('\t')[2]
    coords=i.split('\t')[3].split(', ')
    #print len(coords)
    cds=[]
    cds_starts=[]
    cds_ordered=[]
    cds.append(coords[0].lstrip('[').rstrip(']').split(','))#[0])
    #print cds
    #cds_ordered.append(coords[0].lstrip('[').rstrip(']').split(',')[0])
    #cds[0].append(coords[0].lstrip('[').rstrip(']').split(',')[1])
    cds_starts.append(coords[0].lstrip('[').rstrip(']').split(',')[0])
    #print gene 

#Extract coordinates depending on the strand
    for n in range(1,len(coords)):
        #print n
        #print coords[n], coords[n-1]
        # cds_starts.append(int(coords[n].lstrip('[').rstrip(']').split(',')[0]))
        if strand == 'Plus':
            if int(coords[n].lstrip('[').rstrip(']').split(',')[0]) == int(coords[n-1].lstrip('[').rstrip(']').split(',')[1])+1:
                cds[-1][1] = coords[n].lstrip('[').rstrip(']').split(',')[1]
            else:
                #cds.append(cds[0:len(cds)])
                cds.append(coords[n].lstrip('[').rstrip(']').split(','))
                #cds.pop(0)
                #cds.pop(0)
              
                #cds=list(cds[0])
                #print cds
                cds_starts.append(coords[n].lstrip('[').rstrip(']').split(',')[0])
        
        elif strand == 'Minus':
            if int(coords[n].lstrip('[').rstrip(']').split(',')[0]) == int(coords[n-1].lstrip('[').rstrip(']').split(',')[1])-1:
                cds[-1][1] = coords[n].lstrip('[').rstrip(']').split(',')[1]
            else:
                #cds.append(cds[0:len(cds)])
                cds.append(coords[n].lstrip('[').rstrip(']').split(','))
                #cds.pop(0)
                #cds.pop(0)
                #print cds
                cds_starts.append(coords[n].lstrip('[').rstrip(']').split(',')[0])
    #if strand == 'Minus':
        #cds.reverse()
    #print cds

    cds_starts = sorted(cds_starts)
    #if strand == 'Minus':
     #   cds_starts.reverse()    
    if len(cds) == 1:
        cds_ordered = sorted(cds)
    
    else:
    #print gene + ' ; '+strand+ ' ; ' + str(cds)
    
        for k in cds_starts:
        #print k
            for j in cds:
                if strand == 'Plus':
                    #print j[0]
                    #j=j.lstrip('[').rstrip(']').split(',')
                    #if strand == 'Plus'
                    if k == j[0]:
                        cds_ordered.append(j)
                        #print 'Strand: Plus ; k='+k+' ; j[0]='+j[0]
                elif strand == 'Minus':
                    if k == j[0]:
                        cds_ordered.append(j)
                        #print 'Strand: Minus ; k='+k+' ; j[1]='+j[1]
             
                #elif strand == 'Minus':
                 #        k < int(j[0]):
                 #  cds_ordered.append(k)
                  # cds_ordered.append(j)
                #else:
             #   if i == int(j):
              #      cds_ordered.append(int(j))
        #else:
         #    cds_ordered.append(j)
    #print gene+'; '+ strand+' ; '+str(cds_ordered)

#Create and write outputfile with cds coordinates    
    output_file.write(gene+'\t'+contig+'\t'+strand+'\t'+'['+str(cds_ordered)+'\n')#.replace('[[','').replace("']","'")+'\n')
output_file.close()

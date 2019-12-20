from sys import argv
script, spp, scaffolds, cds = argv

#Function reading sequences from scaffolds.
def read_alignment(filename):
    sequences=[]
    ids=[]
    with open(filename, 'r') as fh:
        while True:
            name=fh.readline()#.rstrip()
            seq=fh.readline()#.rstrip()
            if len(seq) == 0:
                break
            ids.append(name.split(' ')[0].lstrip('>').rstrip('\n'))
            sequences.append(seq)
    return ids, sequences

ids,seqs=read_alignment(scaffolds)

coords=open(cds).read().splitlines()[1:]
cds_odobenus=open('ODOros_genBank_CDS.txt').read().splitlines()
blast_results=open(spp+'_cds_coords_ODOrosGenes_blastn.txt').read().splitlines()[1:]
query_blast={}
for line in blast_results:
    x=line.split('\t')
    query_blast[x[0]]=x[5:7]
#print query_blast.keys()

query_cds={}
for line in cds_odobenus:
    x=line.split('\t')
    query_cds[x[0]]=x[1:3]
#print query_cds.keys()

cds_pos_corr={}
for i in query_blast.keys():
    cds_pos_corr[i]=[int(query_cds[i][0])-int(query_blast[i][0]),int(query_cds[i][1])-int(query_blast[i][1])]
#print cds_pos_corr.keys()

#Create output file
output_file=open(spp+'_allSeqs.fas', 'w+')
logFile=open('logFile_'+spp+'_seqScaffolds.txt', 'w+')
succ_seqs = 0
#Process scaffolds and info in table to extract sequences.
for i in coords:
    ref_gene=i.split('\t')[0]
    gene=i.split('\t')[1]
    strand=i.split('\t')[2]
    cds=i.split('\t')[3].replace("', '",'-').replace("'], ['",',').replace('[','').replace(']','').replace("'",'').split(',')
    #logFile.write(cds[0]+'\n')
    #s1=''
    s2=''
    #s3=''
#    output_file.write('>'+spp+'_'+ref_gene+'\n')
 #  Sequence for first segment, checking for longer seq in start.
#    if cds_pos_corr[ref_gene][0] > 0: 
 #       if strand =='Plus' and int(cds[0].split('-')[1]) > int(cds[0].split('-')[0])+cds_pos_corr[ref_gene][0]:
  #          s1+=seqs[ids.index(gene)][int(cds[0].split('-')[0])+cds_pos_corr[ref_gene][0]-1:int(cds[0].split('-')[1])+1]
   #     if strand == 'Minus' and int(cds[0].split('-')[0]) > int(cds[0].split('-')[1])+cds_pos_corr[ref_gene][0]:
    #        s1+=seqs[ids.index(gene)][int(cds[0].split('-')[1])+cds_pos_corr[ref_gene][0]-1:int(cds[0].split('-')[0])+1]
         
   # else:
    #    if strand == 'Plus':
     #       s1+=seqs[ids.index(gene)][int(cds[0].split('-')[0]):int(cds[0].split('-')[1])+1]
      #  elif strand == 'Minus':
       #     s1+=seqs[ids.index(gene)][int(cds[0].split('-')[1]):int(cds[0].split('-')[0])+1]


    #if len(cds) > 2:
    for j in cds:
    # logFile.write(str(j))
        k=j.split('-')
        if strand == 'Plus':
            s2+=seqs[ids.index(gene)][int(k[0])-1:int(k[1])+1]
 #           print ids.index(gene)
        elif strand == 'Minus':
            s2+=seqs[ids.index(gene)][int(k[1])-1:int(k[0])+1]
  #          print ids.index(gene)
   # else:
    #    continue

#  Sequence for last segment, checking for longer seq in end.
    #if cds_pos_corr[ref_gene][1] < 0 :
     #   if strand == 'Plus' and int(cds[-1].split('-')[1])+cds_pos_corr[ref_gene][1] > int(cds[-1].split('-')[0]):
      #      s3+=seqs[ids.index(gene)][int(cds[-1].split('-')[0]):int(cds[-1].split('-')[1])+cds_pos_corr[ref_gene][1]+1]
       # elif strand == 'Minus' and int(cds[-1].split('-')[0])+cds_pos_corr[ref_gene][0] > int(cds[-1].split('-')[1]):
           # s3+=seqs[ids.index(gene)][int(cds[-1].split('-')[1]):int(cds[-1].split('-')[0])+cds_pos_corr[ref_gene][0]+1]

    #else:
     #   if strand == 'Plus':
      #      s3+=seqs[ids.index(gene)][int(cds[-1].split('-')[0]):int(cds[-1].split('-')[1])+1]
       # elif strand == 'Minus':
        #    s3+=seqs[ids.index(gene)][int(cds[-1].split('-')[1]):int(cds[-1].split('-')[0])+1]
    #print ref_gene, s1, s2, s3
    if len(s2) == 0:
        logFile.write('For gene ' + ref_gene + ' the sequence is empty. Check.'+'\n')
        #print ref_gene, strand, cds[0],cds[-1], s1, s2, s3
        #print 'cds_pos_corr: ', cds_pos_corr[ref_gene]

    if len(s2)%3 == 0:
       succ_seqs += 1
    else:
        logFile.write('For gene ' + ref_gene + ' the number of sites is not a multiple of 3. Check extracted sequence.'+'\n')
    start=1
    end=len(s2)
    print ref_gene, strand, start, end
    if cds_pos_corr[ref_gene][0]>0:
        #if strand == 'Plus':
        start+=cds_pos_corr[ref_gene][0]
        #elif strand == 'Minus':
        #    end-=cds_pos_corr[ref_gene][0]
            
    if cds_pos_corr[ref_gene][1]<0:
        #if strand == 'Plus':
        end+=cds_pos_corr[ref_gene][1]
        #elif strand == 'Minus':
         #   start+=cds_pos_corr[ref_gene][1]
    print 'New start:', start, 'New end:', end
    output_file.write('>'+spp+'_'+ref_gene+'\n') 
    output_file.write(s2.upper().replace('\n','')[start-1:end+1]+'\n')
logFile.write(str(succ_seqs) + ' genes were extracted over ' + str(len(coords))+ ' total genes.'+'\n')
output_file.close()

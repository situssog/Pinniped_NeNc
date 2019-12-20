from sys import argv

script,align = argv
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
            sequences.append(seq.replace('!','-'))
    return ids, sequences
    
ids,seqs=read_alignment(align)
species=['Arctocephalus', 'Zalophus', 'Neomonachus','Phoca', 'Odobenus','Ailuropoda', 'Canis']
scores={}

#Scores for sites
for i in range(len(seqs[0])):
    scores[i]=7
    for sp in species:
        if seqs[ids.index(sp)][i] == '-':
            scores[i]-=1
            
print scores
#Delete sites
corrSeqs=[]
out=open(align.replace('.fasta','')+'_pruned.fasta', 'w+')
for f in range(len(seqs)):
    sSplit=list(seqs[f])
    sJoin=''
    for i in range(len(seqs[0])):
        if scores[i] <= 2:
            sSplit[i]='@'
    sJoin=sJoin.join(sSplit).replace('@','') 
    print sJoin            
    out.write('>'+ids[f]+'\n')
    out.write(sJoin)
    
out.close()

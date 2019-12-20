module load bioinfo-tools
module load samtools/1.3
module load python/2.7
module load bcftools/1.3
module load bwa/0.7.8



/pica/v15/b2014050_nobackup/private/msmc/seqbility-20091110/splitfa GCF_000349705.1_LepWed1.0_genomic.fna 35 > Kmer_reads.fa 

bwa aln -R 1000000 -O 3 -E 3 -t 16 GCF_000349705.1_LepWed1.0_genomic.fna Kmer_reads.fa > Kmer_reads.sai

bwa samse GCF_000349705.1_LepWed1.0_genomic.fna Kmer_reads.sai Kmer_reads.fa | samtools view -h - | gzip > Kmer_reads.sam.gz 

gzip -dc Kmer_reads.sam.gz | /pica/v15/b2014050_nobackup/private/msmc/seqbility-20091110/gen_raw_mask.pl > rawMask_35.fa  

/msmc/seqbility-20091110/gen_mask -l 35 -r 0.5 rawMask_35.fa > mask_35_50.fa

python makeMappabilityMask.py

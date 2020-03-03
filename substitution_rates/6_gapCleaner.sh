#!/bin/bash -l

#SBATCH -A snic2017-1-601
#SBATCH -p core
#SBATCH -n 8 
#SBATCH -t 06:00:00
#SBATCH -J alignCleaner

software='/home/fboteroc/private/software'
rawAlign='/proj/uppstore2017158/b2014050/private/substitution_rates/7spp/macse/lr_aligns'
#alignCleaner/AA'

cp ${rawAlign}/*NT.fasta ${SNIC_TMP}
cp ${rawAlign}/*AA.fasta ${SNIC_TMP}
cd ${SNIC_TMP}
#module load bioinfo-tools
#module load hmmer
module load python3
#ls *HMMclean5.fasta | sed 's/_macse_NT_HMMclean5.fasta//' > files
#for i in $(cat missing.lst) ; do 
#perl ${HMMclean}/HMMcleanerV1_8/HMMcleanAA.pl --del-char @ ./${i}_macse_AA.fasta 5 ; done ;

#for i in $(cat files) ; do
for i in *NT.fasta ; do
#python3 ${software}/remplaceCodons.py ${i}_macse_NT_HMMclean5.fasta; 
python3 ${software}/remplaceCodons.py ${i}
#python3 ${software}/GapCleaner.py ${i}_macse_NT_HMMclean5.fasta 0.75 ;
done ;

#module unload python3
module load python/2.7.9

for i in *_codon.fasta ; do
#for i in *AA.fasta ; do
python ${software}/alignCleaner.py $i ; done ;

for i in *AA.fasta ; do
python ${software}/alignCleaner.py $i ; done ;
#cp *Hmm5.fasta ${rawAlign}/clean
#cp *gapCleaner75.fasta ${rawAlign}/gapCleaner/
#cp *codon.fasta ${rawAlign}/
cp *_pruned.fasta ${rawAlign}/pruned/

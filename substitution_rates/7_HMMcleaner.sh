#!/bin/bash -l

#SBATCH -A snic2017-1-601
#SBATCH -p core
#SBATCH -n 12 
#SBATCH -t 06:00:00
#SBATCH -J HMMCleaner

HMMclean='/home/fboteroc/private/software/HMMclean'
rawAlign='/proj/uppstore2017158/b2014050/private/substitution_rates/7spp/macse/lr_aligns/pruned' #lignCleaner'
#rawAlign='/proj/uppstore2017158/b2014050/private/substitution_rates/7spp/macse/alignCleaner'
#for i in $(cat ${rawAlign}/HMMclean/relFiles.lst) ; do
cp ${rawAlign}/${i}*pruned.fasta ${SNIC_TMP}
#cp ${rawAlign}/HMMclean/${i}*_Hmm5.fasta ${SNIC_TMP}
#cp ${rawAlign}/HMMclean/*Hmm5.fasta ${SNIC_TMP}
#cp ${rawAlign}/missing.lst ${SNIC_TMP}
#done ;

cd ${SNIC_TMP}
module load bioinfo-tools
module load hmmer

#ls *Hmm5.fasta | sed 's/_macse_AA_Hmm5.fasta//' > files
for i in *AA_pruned.fasta ; do 
perl ${HMMclean}/HMMcleanerV1_8/HMMcleanAA.pl --del-char @ ./${i} 5 ; done ;

ls *codon_pruned.fasta | sed 's/_NT_codon.*//' > files
head -1 files

for i in $(cat files) ; do
java -jar ${HMMclean}/report_maskAA2NT_v01.jar ${i}_NT_codon_pruned.fasta ${i}_AA_pruned_Hmm5.fasta 0.5 @ - ${i}_macse_NT_codon_pruned_Hmm5.fasta ; done;

cp *Hmm5.fasta /proj/uppstore2017158/b2014050/private/substitution_rates/7spp/macse/alignCleaner/HMMclean/
#cp *codon_pruned_Hmm5.fasta ${rawAlign}/HMMclean

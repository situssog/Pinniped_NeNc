#!/bin/bash -l

#SBATCH -A snic2017-1-601
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 02-00:00
#SBATCH -J macse_align
 
rawAlign='/proj/uppstore2017158/b2014050/private/substitution_rates/7spp'
macse='/proj/uppstore2017158/b2014050/private/substitution_rates/7spp/macse'

#for i in $(cat ${rawAlign}/7spp_aligns_02); do
cp ${rawAlign}/${1}.fas ${SNIC_TMP}
#done ;

#cp ${rawAlign}/notAlignedFiles.lst ${SNIC_TMP}
#cp ${rawAlign}/7spp_aligns_02 ${SNIC_TMP}
cd $SNIC_TMP

#name=$(basename ${1} .fas) ;
#for i in $(cat 7spp_ialigns_02); do 
java -jar ~/bin/macse_v1.2.jar -prog alignSequences -seq ${1}.fas -gap_op 3 -ext_gap_ratio 0.75 -out_NT ${1}_macse_NT.fasta -out_AA ${1}_macse_AA.fasta ;
cp ${1}*.fasta $macse/

#done ;

#cp *.fasta $macse/


#! /bin/bash -l
#SBATCH -A snic2018-3-658 
#SBATCH -p core -n 1
#SBATCH -t 20:00:00

module load bioinfo-tools
module load ANGSD/0.921

#for i in *.bamlist; do sbatch Generic_angsd_script_mafs.bash $i; done

bamlist=${1}
pop=${bamlist%.bamlist}
REF=GCF_000321225.1_Oros_1.0_genomic.fna
number_0_8=`wc -l $bamlist|awk '{x=$1*0.8; y=x==int(x)?x:int(x+1);print y  }' `


angsd -P 1 -bam $bamlist -ref $REF -out $pop"_maf" -uniqueOnly 1 -remove_bads 1 -C 50 -baq 1 -minMapQ 20 -minQ 20 -minInd $number_0_8 -GL 1 -doCounts 1 -rf $pop"_regions_for_Angsd" -doMajorMinor 1 -doMaf 1 -skipTriallelic 1 -SNP_pval 1e-3 -doGeno 32 -doPost 1


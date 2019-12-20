#! /bin/bash -l
#SBATCH -A snic2018-3-658 
#SBATCH -p core -n 1
#SBATCH -t 3-00:00:00

module load bioinfo-tools
module load ANGSD/0.921

#for i in *.bamlist; do sbatch Generic_angsd_script.bash $i; done

bamlist=${1}
pop=${bamlist%.bamlist}
REF=GCF_000321225.1_Oros_1.0_genomic.fna
number_0_8=`wc -l $bamlist|awk '{x=$1*0.8; y=x==int(x)?x:int(x+1);print y  }' `


angsd -P 1 -bam $bamlist -out $pop"_0_8" -doSaf 1 -anc $REF -ref $REF -uniqueOnly 1 -remove_bads 1 -C 50 -baq 1 -minMapQ 20 -minQ 20 -minInd $number_0_8 -GL 1 -doCounts 1 -rf $pop"_regions_for_Angsd"



realSFS $pop"_0_8".saf.idx -P 1 > $pop"_0_8"_large_autosomes_ddRAD.sfs


angsd -P 1 -bam $bamlist -out $pop"_0_8" -doSaf 1 -anc $REF -ref $REF -uniqueOnly 1 -remove_bads 1 -C 50 -baq 1 -minMapQ 20 -minQ 20 -minInd $number_0_8 -GL 1 -doCounts 1 -rf $pop"_regions_for_Angsd" -doThetas 1 -pest $pop"_0_8"_large_autosomes_ddRAD.sfs


thetaStat do_stat $pop"_0_8.thetas.idx"

thetaStat print $pop"_0_8.thetas.idx" > $pop"_0_8_per_site.thetas"
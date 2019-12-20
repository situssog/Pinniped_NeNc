#! /bin/bash -l
#SBATCH -A snic2018-3-658
#SBATCH -p core -n 1
#SBATCH -t 01:00:00

module load bioinfo-tools
module load R_packages

#for i in *.bamlist; do sbatch Submit_per_site_pi_tajD.bash $i; done

bamlist=${1}
pop=${bamlist%.bamlist}
nChr=`wc -l $bamlist|awk '{x=$1*2;print x  }' `



Rscript Per_site_pi_errors_TajD.r $pop"_0_8_per_site.thetas" $nChr $pop"_per_site_pi_tajD"


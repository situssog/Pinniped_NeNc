#!/bin/bash
#SBATCH -A snic2018-3-658 
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 15:00:00
#SBATCH -J 1dSFS_dadi

# this script run dadi using a VCF file – the script is automatised to run with a list of VCF files 
# example 1dSFS_dadi.sh file.sfs

module load bioinfo-tools 
module load vcftools
module load python/2.7.6

sfs_file=$1
out_file_ext=${sfs_file##*/}
out_file=${out_file_ext%.*}


#cp $sfs_file ./

number_sample=$(wc -w $sfs_file | awk '{print $1}')

echo "$number_sample unfolded
$(cat $sfs_file)" > $out_file_ext 

python GBS_bottle.py $out_file_ext > 1dsfs_$out_file.bootstrap


#!/bin/bash
#SBATCH -A snic2018-3-658
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 10:00
#SBATCH -J cleaning_1dSFS_1dSFS_dadi


module load bioinfo-tools

sfs_file=/proj/b2012209/nobackup/Analysis/ANGSD/Odo_ros/Odo_ros_0_8_large_autosomes_ddRAD.sfs
sfs_file=$1
out_file_ext=${sfs_file##*/}
out_file=${out_file_ext%.*}


grep Optimized 1dsfs_$out_file.bootstrap | tr -s " " | tr -d '\n' | sed -e 's/$/\n/' -e 's/Optimized/\nOptimized/g' | sed -e 's/$/\n/' -e 's/Bootstrap/\nBootstrap/g' | sed 's/Optimized //g' | tr -d '\n' | sed -e 's/$/\n/' -e 's/parameters/\nparameters/g' | sed '/^$/d' | sed 's/\[//g;s/\]//g' | sed 's/[)(]//g' | sed 's/parameters array //g' | sed 's/parameters array//g'  | tr -s " " | sed 's/log-likelihood: /, /g' | sed 's/ ,/,/g' | sed 's/,//g' > 1dsfs_data_$out_file.bootstrap.clean_withlikelihood

Rscript mean_dadi_parameters_withlikelihood.R 1dsfs_data_$out_file.bootstrap.clean_withlikelihood withlikelihood_1dsfs_mean_$out_file.txt


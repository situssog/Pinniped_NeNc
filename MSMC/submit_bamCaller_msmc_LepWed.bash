module load bioinfo-tools
module load samtools/1.3
module load bcftools/1.3
module load python/3.5.0


while read p; do

	#scaffold_name=${1}
	scaffold_name=$p
	echo $scaffold_name
	mean_cov=$(samtools depth -r $scaffold_name LepWed_merged_duprm_realigned.bam | awk '{sum += $3} END {print sum / NR}')
	echo $mean_cov

	echo "samtools mpileup -q 20 -Q 20 -C 50 -u -r $scaffold_name -f GCF_000349705.1_LepWed1.0_genomic.fna LepWed_merged_duprm_realigned.bam | bcftools call -c -V indels | python3 msmc/msmc-tools-master/bamCaller.py $mean_cov $scaffold_name"_mask.bed.gz" | gzip -c > $scaffold_name".vcf.gz""
	
	samtools mpileup -q 20 -Q 20 -C 50 -u -r $scaffold_name -f GCF_000349705.1_LepWed1.0_genomic.fna LepWed_merged_duprm_realigned.bam | bcftools call -c -V indels | python3 /msmc/msmc-tools-master/bamCaller.py $mean_cov $scaffold_name"_mask.bed.gz" | gzip -c > $scaffold_name".vcf.gz"
	
done <LepWed_msmc_scaffolds_to_include_over400kb_noX.txt

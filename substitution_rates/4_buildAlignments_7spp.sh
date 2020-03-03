#!/bin/bash -l

#SBATCH -A snic2017-1-601
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 3-00:00
#SBATCH -J otarrids_cds
data='/proj/uppstore2017158/b2014050/private/substitution_rates'

#This script incorporates the sequences for Arctocephalus and Zalophus into sequence files containing those of annotated genomes for other pinnipeds and outgroups.

cp ${data}/5spp/*fas ${SNIC_TMP}/
cp ${data}/arcGaz_allSeqs.fas ${SNIC_TMP}/
cp ${data}/zalCal_allSeqs.fas ${SNIC_TMP}/
cp ${data}/Odobenus_ids.lst ${SNIC_TMP}/

cd ${SNIC_TMP}

for j in arcGaz zalCal ; do for i in $(cat Odobenus_ids.lst | cut -d' ' -f1) ; do grep -A1 $(cat Odobenus_ids.lst | grep $i | cut -d' ' -f2) ${j}_allSeqs.fas >> ${i}.fas ; done ; done;

cp ENSG*.fas ${data}/7spp/

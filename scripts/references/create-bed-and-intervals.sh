#!/bin/bash

# Create mandatory bed files and interval_list files, referring to the whole genome.
# Requires the reference genome dict file (iGenomes; see notes.txt)

mkdir -p ~/nf/nf-core-raredisease_1.1.1/references/intervals
python dict-to-bed.py ~/nf/nf-core-raredisease_1.1.1/references/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.dict genome.dict > ~/nf/nf-core-raredisease_1.1.1/references/intervals/wgs.bed
grep ^chrY ~/nf/nf-core-raredisease_1.1.1/references/intervals/wgs.bed > ~/nf/nf-core-raredisease_1.1.1/references/intervals/chrY.bed


singularity run \
	-B `realpath ~/nf/nf-core-raredisease_1.1.1/references/`:/data \
	/home/kcoetzer/nf/nf-core-raredisease_1.1.1/singularity-images/depot.galaxyproject.org-singularity-gatk4-4.4.0.0--py36hdfd78af_0.img \
	gatk BedToIntervalList \
		-I /data/intervals/wgs.bed \
		-O /data/intervals/wgs.interval_list \
		-SD /data/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.dict

singularity run \
	-B `realpath ~/nf/nf-core-raredisease_1.1.1/references/`:/data \
	 /home/kcoetzer/nf/nf-core-raredisease_1.1.1/singularity-images/depot.galaxyproject.org-singularity-gatk4-4.4.0.0--py36hdfd78af_0.img \
	 gatk BedToIntervalList \
		-I /data/intervals/chrY.bed \
		-O /data/intervals/chrY.interval_list \
		-SD /data/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.dict


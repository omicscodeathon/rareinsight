#!/bin/bash

gunzip -c ~/nf/nf-core-raredisease_1.1.1/references/gnomad/gnomad.genomes.v3.1.2.sites.af.vcf.gz | \
    awk -F "\t" -v OFS='\t' \
         '!/^#/ {split($8,a,";"); for(i in a) if(a[i] ~ /^AF=/) {split(a[i],b,"="); print $1, $2, $4 "," $5, b[2]}}' \
    | bgzip > ~/nf/nf-core-raredisease_1.1.1/references/gnomad.genomes.v3.1.2.sites.af.vcf.gz
tabix -p vcf ~/nf/nf-core-raredisease_1.1.1/references/gnomad.genomes.v3.1.2.sites.af.vcf.gz

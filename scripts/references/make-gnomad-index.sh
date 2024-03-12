#!/bin/bash

#GNOMAD="/home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/gnomad"

#singularity exec -B $(/home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/gnomad /home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/):/home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/ \
 #   ~/nf/nf-core-raredisease_1.1.1/singularity-images/depot.galaxyproject.org-singularity-bcftools-1.17--haef29d1_0.img \
  #          tabix -p $GNOMAD/gnomad.genomes.v3.1.sites.chrM.vcf.gz

GNOMAD="/home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/gnomad"

singularity exec -B $(pwd):/workdir \
    ~/nf/nf-core-raredisease_1.1.1/singularity-images/depot.galaxyproject.org-singularity-bcftools-1.17--haef29d1_0.img \
    tabix -0 $GNOMAD/gnomad.genomes.v3.1.2.af.tab.gz

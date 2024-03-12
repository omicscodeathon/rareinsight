#!/bin/bash

CADD="/home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/CADD"

singularity exec -B $(/home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/CADD /home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/):/home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/ \
    ~/nf/nf-core-raredisease_1.1.1/singularity-images/depot.galaxyproject.org-singularity-bcftools-1.17--haef29d1_0.img \
            tabix --csi -b 2 -e 2 $CADD/whole_genome_SNVs.tsv.gz


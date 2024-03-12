#!/bin/bash

#singularity run -B `~/nf/nf-core-raredisease_1.1.1/references/ ~/nf/nf-core-raredisease_1.1.1/references/`:~/nf/nf-core-raredisease_1.1.1/references/ \
 #   ~/nf/nf-core-raredisease_1.1.1/singularity-images/depot.galaxyproject.org-singularity-bcftools-1.17--haef29d1_0.img \
  #      bash -c "gunzip -c $CLINVAR/clinvar.vcf.gz | iconv -f ISO-8859-1 -t UTF-8 | bgzip > $CLINVAR/clinvar_utf8.vcf.gz && \
   #     tabix -p vcf $CLINVAR/clinvar_utf8.vcf.gz"


CLINVAR="~/nf/nf-core-raredisease_1.1.1/references"

singularity run -B ~/nf/nf-core-raredisease_1.1.1/references/:/references \
        ~/nf/nf-core-raredisease_1.1.1/singularity-images/depot.galaxyproject.org-singularity-bcftools-1.17--haef29d1_0.img \
        bash -c "gunzip -c /references/clinvar.vcf.gz | bgzip > /references/clinvar_utf8.vcf.gz && \
        tabix -p vcf /references/clinvar_utf8.vcf.gz"

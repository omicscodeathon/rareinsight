GNOMAD_DIR=/home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/
TMP_DIR=/home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/temp
mkdir -p $TMP_DIR
FILE_LIST=""
for chrom in `seq 1 22` X Y
do
    THIS_FILE="/home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/temp/gnomad.genomes.v3.1.2.sites.chr${chrom}.af.bcf"
    singularity run  \
        -B `realpath $TMP_DIR`:/home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/temp \
        -B `realpath $GNOMAD_DIR`:/home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/ \
        /home/kcoetzer/nf/nf-core-raredisease_1.1.1/singularity-images/depot.galaxyproject.org-singularity-bcftools-1.17--haef29d1_0.img \
        bcftools annotate -Ob -x ^INFO/AF,^INFO/AF_popmax \
                -o $THIS_FILE \
                /home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/gnomad.genomes.v3.1.2.sites.chr${chrom}.vcf.bgz &
    FILE_LIST="$FILE_LIST $THIS_FILE"
done

wait

# Merge chromosomes
singularity run \
        -B `realpath $TMP_DIR`:/home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/temp \
        /home/kcoetzer/nf/nf-core-raredisease_1.1.1/singularity-images/depot.galaxyproject.org-singularity-bcftools-1.17--haef29d1_0.img \
        bcftools concat -Oz $FILE_LIST \
            -o /home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/gnomad.genomes.v3.1.2.sites.af.vcf.bgz

# Index the merged VCF file
singularity run \
        -B `realpath $TMP_DIR`:/home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/temp \
        /home/kcoetzer/nf/nf-core-raredisease_1.1.1/singularity-images/depot.galaxyproject.org-singularity-bcftools-1.17--haef29d1_0.img \
        tabix -p vcf /home/kcoetzer/nf/nf-core-raredisease_1.1.1/references/gnomad.genomes.v3.1.2.sites.af.vcf.bgz

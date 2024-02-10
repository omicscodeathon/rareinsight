#Pipeline to produce VCF file

#######################################
#Data-preprocessing using GATK workflow
#FastQC
module load chpc/BIOMODULES
module load fastqc/0.11.5
fastqc ***_forward.fq.gz -o ***_reverse.fq.gz

#DO THIS FOR ALL FILE FORMATS (if not already available)
#Create_and_index_of_the_reference
###Note - this_can_change_depending_on_the_referencing
module load chpc/BIOMODULES
module load bwa/0.7.12
bwa index -a bwtsw -p hg38idx hg38.fa

#Align using BWA mem
module load chpc/BIOMODULES
module load bwa/0.7.12
bwa mem -M -t 24 hg38 XXX_filename_1.fastq.gz XXX_filename_2.fastq.gz > XXX_filename.sam

#Create_a_BAM_file
module load chpc/BIOMODULES
module load samtools/1.6
samtools view -bS XXX_filename.sam > XXX_filename.bam

#START HERE FOR BAM FILES

#ValidateSamFile
module load chpc/BIOMODULES
module load picard/2.2.1
picard ValidateSamFile I=XXX_filename.bam MODE=SUMMARY

#AddOrReplaceReadGroups
module load chpc/BIOMODULES
module load picard/2.2.1
picard AddOrReplaceReadGroups I=XXX_filename.bam O=XXX_filename_RG_added.bam RGID=1 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20

#Sort_bam_file
module load chpc/BIOMODULES
module load samtools/1.6
samtools sort -O bam -o XXX_filename_sorted.bam -T temp XXX_filename_RG_added.bam

#Index_bamfile
#samtools is still loaded so dont need to reload module
samtools index XXX_filename_sorted.bam

#ValidateSamFile
module load chpc/BIOMODULES
module load picard/2.2.1
picard ValidateSamFile I=XXX_filename_sorted.bam MODE=SUMMARY

#Create_human_reference_dictionary
module load chpc/BIOMODULES
module load picard/2.2.1
picard CreateSequenceDictionary R=hg38.fa O=hg38.dict

#HaplotypeCaller
#hg.dict and hgidx needs to be available before this step
module load chpc/BIOMODULES
module load gatk/4.0.6.0
gatk HaplotypeCaller -I=XXX_filename_sorted.bam -R=hg38.fa --native-pair-hmm-threads 12 -O=XXX_filename_raw.vcf

#VQSR_hard_filter_SNPs_EXTRACT_SNPs
module load chpc/BIOMODULES
module load gatk/4.0.6.0
gatk SelectVariants -V XXX_filename_raw.vcf -R hg38.fa -select-type SNP -O XXX_filename_SNPS_raw.vcf

#VQSR_hard_filter_SNPs
module load chpc/BIOMODULES
module load gatk/4.0.6.0
gatk VariantFiltration -R hg38.fa -V XXX_filename_SNPS_raw.vcf -O XXX_filename_SNPS_final.vcf --filter "QD < 2.0" --filter-name "QD2" --filter "QUAL < 30.0" --filter-name "QUAL30" --filter "SOR > 3.0" --filter-name "SOR3" --filter "FS > 60.0" --filter-name "FS60" --filter "MQ < 40.0" --filter-name "MQ40" --filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" --filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8"

#VQSR_hard_filter_INDELs_EXTRACT_INDELs
module load chpc/BIOMODULES
module load gatk/4.0.6.0
gatk SelectVariants -V XXX_filename_raw.vcf -R hg38.fa -select-type INDEL -O XXX_filename_INDELs_raw.vcf

#VQSR_hard_filter_INDELS
module load chpc/BIOMODULES
module load gatk/4.0.6.0
gatk VariantFiltration -V XXX_filename_INDELs_raw.vcf -R hg38.fa -O XXX_filename_INDELs_final.vcf --filter "QD < 2.0" --filter-name "QD2" --filter "QUAL < 30.0" --filter-name "QUAL30" --filter "FS > 200.0" --filter-name "FS200" --filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20"

#Merge_all_SNP_and_INDEL_files
module load chpc/BIOMODULES
module load picard/2.2.1
picard MergeVcfs I=XXX_filename_SNPS_final.vcf I=XXX_filename_INDELs_final.vcf O=XXX_filename.vcf

#####################################
#Check number of variants in VCF file
module load chpc/BIOMODULES
module load bcftools/1.11
bcftools view -H XXX_filename.vcf | wc -l

#################################
#Use annovar to annotate VCF file
module load chpc/BIOMODULES 
module load annovar 
table_annovar.pl ~/lustre3p/Kim_OI_VCF/XXX_filename /apps/chpc/bio/annovar/humandb/ -buildver hg38 -out KTWWanno -remove -protocol refGene,cytoBand,exac03,avsnp147,dbnsfp30a -operation g,r,f,f,f -nastring . -vcfinput -polish

#########################################################
#Use vcftools to do basic filtering of annotated VCF file
module load chpc/BIOMODULES
module load vcftools
vcftools --vcf XXX_filename --remove-indels --maf 0.05 --minQ >30 --recode --recode-INFO-all --out SNPs_only_ETB21-KTWW 

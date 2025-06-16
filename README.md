# RareInsight
From Diagnosis to Dashboard: Innovations in Rare Disease Reporting using RareInsight

# Scope
Following a confirmed genetic diagnosis, rare disease patients and their families encounter significant challenges in accessing diagnostic information and support. Patients and non-specialists are increasingly expected to interpret and share test results; however, existing standards are primarily designed for specialists. These standards fail to address the needs of resource-limited populations where low genomic literacy hampers accurate dissemination of genetic results. This research introduces RareInsight, an open-source, interactive dashboard designed to enhance the accessibility, comprehension, and collaboration of genetic data among patients, caregivers, clinicians, and researchers. Developed using shinydashboard, RareInsight was evaluated using whole exome sequencing data from skeletal dysplasia patients. It allows users to input and view Variant Call Format (VCF) files and includes a searchable ClinVar variant table with filtering options, providing access to multiple resources based on search terms. RareInsight aims to simplify the dissemination of complex genetic information beyond the clinical setting. This dashboard serves as a pilot study demonstrating the potential of patient-centered interactive dashboards for the rare disease community. 

# Workflow

![Outline of main functions of the dashboard](https://github.com/omicscodeathon/rareinsight/blob/main/figures/RI_functions.png)

# Tutorial

![Video demonstrating the main functions of the dashboard](https://github.com/omicscodeathon/rareinsight/blob/main/www/RareInsight_tutorial.mp4)

# Deployment

Currently, RareInsight can be deployed by:
- Downloading the GitHub repository
- Opening the folder in RStudio
- Running the 01_rareinsight.R script

# User input

*Input User Information panel:* Users can input patient information to this panel.

*Search Panel:* Once the dashboard is initiated, the latest ClinVar variant summary file will automatically download. Users can only access the functions of the dashboard once the download has been completed. 

*VCF Panel:* Users can input a vcf.gz file that was ideally produced with the nf-core/raredisease pipeline. Files created with GATK can also be uploaded. Users can optionally input a filtered VCF file. Currently the script produces a filtered VCF file from the nf-core/raredisease pipeline. Users can filter their files using the filter_vcf.py script (found in the scripts folder). It includes the CSQ information from VEP, clinical diagnosis (CLNDN) and clinical significance (CLNSIG). 

# Outputs

*Input User Information panel:* Users can export the information in PDF format.

*VCF Panel:* Users can expect to visualize a VCF file in table format. Two plots are also generated to show the quality of the VCF file. 

*Search Panel:* Users can see and filter the ClinVar variant summary file. This file can be filtered according to a given gene, variant, disorder, ClinVar accession or dbSNP accession. It can then be further filtered by searching for specific information in the table.

*Diagnostic report:* Based on the search term used in the Search Panel, users can access links specific to this search term. Resources include PubMed, ClinVar, dbSNP, GeneReviews, LitVar2, gnomAD, Varsome and NORD. Patient-specific resources are also available such as RareConnect, RAReSOURCE, GARD and NORD patient organizations. 

# Contributors
- [Kimberly Christine Coetzer](https://github.com/Kimmiecc19) : PhD student, Division of Molecular Biology and Human Genetics, Department of Biomedical Sciences, Faculty of Medicine and Health Sciences, Stellenbosch University, Cape Town, South Africa
  
- [Firas Zemzem](https://github.com/Zemzemfiras1) : PhD student ,Laboratory of Cytogenetics, Molecular Genetics and Biology of Reproduction CHU Farhat Hached Sousse, Higher institute of Biotechnology of Monastir, University of Monastir, Tunisia

- [Eva Akurut](https://github.com/AkurutEva) : African Centre of Excellence in Bioinformatics and Data-intensive Sciences, Infectious Disease Institute, Makerere University, Kampala, Uganda
  
- [Gideon Akuamoah Wiafe](https://github.com/Giddoo) : MSc student, Neurogenomics Lab, Neuroscience Institute, University of Cape Town, Cape Town, South Africa; Department of Medicine, Faculty of Health Sciences, University of Cape Town, Cape Town, South Africa; Department of Biomedical Sciences, University of Cape Coast, Cape Coast, Ghana

- [Olaitan I Awe](https://github.com/laitanawe) : Training officer, ASBCB, Cape Town, South Africa

# Thank you to the following organizations: 

- African Society for Bioinformatics and Computational Biology (ASBCB)

- National Institutes of Health (NIH) Office of Data Science Strategy (ODSS)

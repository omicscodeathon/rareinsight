# RareInsight

<p style="text-align: center;"><strong>Simplifying the communication of genetic results for rare disease patients</strong></p>

<p style="text-align: justify;">
RareInsight is an open-source, interactive dashboard that bridges the gap between genetic diagnosis and patient understanding. Built with <code>shinydashboard</code>, it is designed to improve access to and interpretation of genetic test results by patients, caregivers, clinicians, and researchers—especially in resource-limited settings.
</p>

## Overview

<p style="text-align: justify;">
Following a confirmed genetic diagnosis, rare disease patients and their families encounter significant challenges in accessing diagnostic information and support. Patients and non-specialists are increasingly expected to interpret and share test results; however, existing standards are primarily designed for specialists. These standards fail to address the needs of resource-limited populations where low genomic literacy hampers accurate dissemination of genetic results. This research introduces RareInsight, an open-source, interactive dashboard designed to enhance the accessibility, comprehension, and collaboration of genetic data among patients, caregivers, clinicians, and researchers. Developed using shinydashboard, RareInsight was evaluated using whole exome sequencing data from skeletal dysplasia patients. It allows users to input and view Variant Call Format (VCF) files and includes a searchable ClinVar variant table with filtering options, providing access to multiple resources based on search terms. RareInsight aims to simplify the dissemination of complex genetic information beyond the clinical setting. This dashboard serves as a pilot study demonstrating the potential of patient-centered interactive dashboards for the rare disease community.
</p>

<p align="center"><b>RareInsight Functions</b><br />
<img src="https://github.com/omicscodeathon/rareinsight/blob/main/figures/rareinsight_services.png" alt="RareInsight Functions" /></p>

<p align="center"><b>RareInsight Tutorial Video</b><br />
  <img src="[https://github.com/omicscodeathon/rareinsight/blob/main/figures/rareinsight_services.pn](https://github.com/omicscodeathon/rareinsight/blob/main/www/RareInsight_tutorial.mp4" alt="RareInsight Tutorial Video" /></p>

## Getting Started

### Installation

To deploy RareInsight locally:

1. Clone the repository:
   ```bash
   git clone https://github.com/omicscodeathon/rareinsight.git
   cd rareinsight
   ```

2. Open the project in RStudio

3. Run the application script:

   ```r
   source("01_rareinsight.R")
   ```

---

## User Input

### Input User Information

Enter patient-specific data and export a formatted PDF report.

### Search Panel

Automatically downloads the latest ClinVar variant summary file. Enables variant lookup by gene, disorder, ClinVar/dbSNP accession, etc.

### VCF Panel

Upload a `.vcf.gz` file.

* Please note that there is a file size limit of 60MB. 
* You can filter your VCF using our example script in `scripts/filter_vcf.py`

---

## Outputs

* **VCF Table View** with quality control plots
* **Filtered ClinVar Variant Summary**
* **Diagnostic Report** with relevant clinical and patient resources including:

  * **Specialist:** ClinVar, dbSNP, PubMed, GeneReviews, Varsome, gnomAD, LitVar2, OMIM
  * **Non-specialist:** RareConnect, RAReSOURCE, RDSA, GARD, NORD

---

## Contributors

* [**Kimberly Christine Coetzer**](https://github.com/Kimmiecc19) – Stellenbosch University, South Africa
* [**Firas Zemzem**](https://github.com/Zemzemfiras1) – University of Monastir, Tunisia
* [**Eva Akurut**](https://github.com/AkurutEva) – Makerere University, Uganda
* [**Gideon Akuamoah Wiafe**](https://github.com/Giddoo) – University of Cape Town, South Africa & University of Cape Coast, Ghana
* [**Olaitan I Awe**](https://github.com/laitanawe) – ASBCB, South Africa

---

## Acknowledgments

This project was supported by:

* **African Society for Bioinformatics and Computational Biology (ASBCB)**
* **NIH Office of Data Science Strategy (ODSS)**

---

## License

This project is open-source and available under the [MIT License](LICENSE).

---

## Contact

For questions, contributions, or collaborations, please open an [issue](https://github.com/omicscodeathon/rareinsight/issues) or contact the lead contributor at [Kimmiecc19](https://github.com/Kimmiecc19).

---

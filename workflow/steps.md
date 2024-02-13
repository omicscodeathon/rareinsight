# Steps: 

### Generating the VCF File:

1. **Prepare the raw Data**: Gather the whole exome sequencing fastq data from skeletal dysplasia fetuses (See data folder)

2. **Download reference data**: Using https://github.com/fa2k/raredisease-configs/archive/refs/heads/main/

3. **Create the samplesheet**: Samplesheet for nf-core/raredisease pipeline

4. **Run the nf-core/raredisease pipeline**: nextflow run main.nf -profile apptainer --input ~/test_SD.csv --outdir ~/nf-core-raredisease_1.1.1/ -params-file ~/nf_params/raredisease/RD.yml -c ~/nf_params/raredisease/RD.config -resume

### Creating a ShinyDashboard:

1. **Install R, Shiny, and Shinydashboard**: Install required packages

2. **Set Up Project (RareInsight)**: Make rareinsight.R file 

3. **Define UI**: In the `rareinsight.R` file, define the user interface (UI) of ShinyDashboard. 

4. **Define Server Logic**: Write the server-side logic for ShinyDashboard in rareinsight.R file.

5. **Run the Application**: Run ShinyDashboard application locally to test it. shinyApp(ui, server)

6. **Customize and Refine**: EDIT

7. **Deploy**: Figure out best way to deploy dashboard

8. **Maintenance and Updates**: Regularly maintain and update ShinyDashboard as needed, incorporating new features, fixing bugs, and ensuring compatibility with R and Shiny updates.

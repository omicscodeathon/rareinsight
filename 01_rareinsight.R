#Check if packages are downloaded
if (!require("shiny"))
  install.packages("shiny")
if (!require("shinydashboard"))
  install.packages("shinydashboard")
if (!require("shinyalert"))
  install.packages("shinyalert")
if (!require("progress"))
  install.packages("progress")
if (!require("data.table"))
  install.packages("data.table")
if (!require("vcfR"))
  install.packages("vcfR")
if (!require("DT"))
  install.packages("DT")
if (!require("rmarkdown"))
  install.packages("rmarkdown")
if (!require("shinyjs"))
  install.packages("shinyjs")
if (!require("shinyWidgets"))
  install.packages("shinyWidgets")

#Load packages
library(shiny)
library(shinydashboard)
library(shinyalert)
library(progress)
library(data.table)
library(vcfR)
library(DT)  # For interactive tables
library(rmarkdown)
library(shinyjs)
library(shinyWidgets)

# Increase file size
options(shiny.maxRequestSize = 60 * 1024^2)

# Render Rmd to HTML once before the app runs
# Set up paths relative to the app file location
app_dir <- getwd()
rmds <- list(
  glossary = "glossary.Rmd",
  basic_genetics = "basic_genetics.Rmd",
  rare_diseases = "rare_diseases.Rmd",
  genetic_resources_guide = "genetic_resources_guide.Rmd"
)

# Create output dir
if (!dir.exists(file.path(app_dir, "www"))) dir.create(file.path(app_dir, "www"))

# Render Rmds to www/*.html
for (rmd in rmds) {
  input_file <- file.path(app_dir, rmd)
  output_file <- file.path(app_dir, "www", sub("\\.Rmd$", ".html", basename(rmd)))
  rmarkdown::render(input_file, output_file = output_file, output_format = "html_document")
}

#Set UI function
ui <- fluidPage(
  useSweetAlert(),  # Important for confirmSweetAlert
  #textOutput("user_type"),
  dashboardPage(
    dashboardHeader(title = span(
      img(src = "rareinsight_final.png", height = 50), "RareInsight"
    )),
    dashboardSidebar(sidebarMenu(
      menuItem("Home ", tabName = "home", icon = icon("home")),
      menuItem(
        "Understanding your genetics",
        tabName = "understanding_genetics",
        icon = icon("education", lib = "glyphicon")
      ),
      menuItem(
        "Services",
        icon = icon("bar-chart"),
        menuSubItem(
          "Input User Information",
          tabName = "input_user_info",
          icon = icon("user-circle")
        ),
        menuSubItem("VCF Panel", tabName = "vcfpanel", icon = icon("file")),
        menuSubItem(
          "Search Panel",
          tabName = "Search",
          icon = icon("search", lib = "glyphicon")
        ),
        menuSubItem(
          "Diagnostic Report",
          tabName = "diagnostic_report",
          icon = icon("line-chart"))
      ),
      
      menuItem(
        "Acknowledgement",
        tabName = "acknow",
        icon = icon("handshake"))
    )
    ),
    dashboardBody(
      useShinyjs(),
      useShinyalert(),
      tags$head(tags$style(
        HTML(
          '
                                /* logo */
                                .skin-blue .main-header .logo {
                                background-color: #030637;
                                }

                                /* navbar (rest of the header) */
                                .skin-blue .main-header .navbar {
                                background-color: #030637;
                                }

                                /* logo when hovered */
                                .skin-blue .main-header .logo:hover {
                                background-color: #030637;
                                }

                                /* main sidebar */
                                .skin-blue .main-sidebar {
                                background-color: #3C0753;
                                }

                                /* active selected tab in the sidebarmenu */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                                background-color: #9f16db;
                                }

                                /* other links in the sidebarmenu */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu a{
                                background-color: ;
                                color: #FFFFFF
                                }

                                /* other links in the sidebarmenu when hovered */
                                .skin-blue .main-sidebar .sidebar .sidebar-menu a:hover{
                                background-color: #030637;
                                }
                                /* toggle button when hovered  */
                                .skin-blue .main-header .navbar .sidebar-toggle:hover{
                                background-color: #3C0753;
                                }

                                /* body */
                                .content-wrapper, .right-side {
                                background-color: #FFFFFF ;
                                }

                                '))),
      tabItems(
        tabItem(
          tabName = "home",
          fluidRow(
            h3("About RareInsight"),
            p(
              style = "text-align: justify;",
              "Following a confirmed genetic diagnosis, rare disease patients and their families encounter significant challenges in accessing diagnostic information and support. Patients and non-specialists are increasingly expected to interpret and share test results; however, existing standards are primarily designed for specialists. These standards fail to address the needs of resource-limited populations where low genomic literacy hampers accurate dissemination of genetic results. This research introduces RareInsight, an open-source, interactive dashboard designed to enhance the accessibility, comprehension, and collaboration of genetic data among patients, caregivers, clinicians, and researchers. Developed using shinydashboard, RareInsight was evaluated using whole exome sequencing data from skeletal dysplasia patients. It allows users to input and view Variant Call Format (VCF) files and includes a searchable ClinVar variant table with filtering options, providing access to multiple resources based on search terms. RareInsight aims to simplify the dissemination of complex genetic information beyond the clinical setting. This dashboard serves as a pilot study demonstrating the potential of patient-centred interactive dashboards for the rare disease community."
            ),
            h3("By promoting knowledge exchange, RareInsight aims to:"),
            p(
              "1- Simplify the complex process of understanding rare disease diagnoses as a patient or caregiver."
            ),
            p(
              "2- Present ClinVar variant data in a user-friendly, searchable format, accessible to both specialists and non-specialists."
            ),
            p(
              "3- Encourage patient empowerment by improving genomic literacy in the rare disease community, specifically in Africa."
            ),
            p(
              "4- Bridge the gap between clinical data and personal understanding through intuitive data visualization and educational resources."
            ),
            p(
              "5- Serve as a template for future rare disease tools, promoting open-source."
            ),
            column(width = 12, div(
              style = "text-align: center;",
              tags$img(
                src = "pic.jpg",
                width = "20%",
                height = 150
              )  # Adjust width and height as needed
            )),
            fluidRow(column(
              width = 12,
              tags$video(
                src = "https://github.com/omicscodeathon/rareinsight/blob/main/www/RareInsight_tutorial.mp4",
                type = "video/mp4",
                width = "100%",
                controls = TRUE
              ))
            )
          )
        ),
        
        tabItem(tabName = "understanding_genetics",
                tabsetPanel(
                  tabPanel("Glossary",
                           downloadButton("download_glossary", "Download Glossary (HTML)"),
                           uiOutput("view_glossary")
                  ),
                  tabPanel("Basic Genetics",
                           downloadButton("download_basic_genetics", "Download Basic Genetics (HTML)"),
                           uiOutput("view_basic_genetics")
                  ),
                  tabPanel("Rare Diseases",
                           downloadButton("download_rare_diseases", "Download Rare Diseases (HTML)"),
                           uiOutput("view_rare_diseases")
                  )
                )
        ),
        
        tabItem(tabName = "service", h1("User Data Inputs")),
        tabItem(
          tabName = "input_user_info",
          h1(" User Data Inputs"),
          fluidRow(
            column(6, textInput(inputId = "name", label = "Name")),
            column(6, textInput(inputId = "surname", label = "Surname")),
            column(6, textInput(inputId = "ethnicity", label = "Ethnicity")),
            column(6, dateInput(inputId = "dob", label = "Date of Birth")),
            #TODO: User must be able to select year from search
            column(
              12,
              textInput(inputId = "clinical_diagnosis", label = "Clinical Diagnosis")
            ),
            column(12, textInput(inputId = "phenotype", label = "Phenotype")),
            column(
              12,
              selectInput(
                inputId = "test_performed",
                label = "Test Performed",
                choices = c("WES", "WGS", "Gene Panel")
              )
            ),
            downloadButton(outputId = "download_button", label = "Download User Info")
          )
        ),
        
        tabItem(tabName = "Search", h1("Search Panel"), fluidRow(
          wellPanel(
            selectInput(
              "search_type",
              "Search Type:",
              choices = c("Gene", "Variant", "Disorder", "dbSNP", "ClinVar"),
              selected = "Gene"
            ),
            textInput("search_input", "Enter Search Term:", ""),
            actionButton("search_button", "Search"),
            DTOutput("search_results"),
            # Warning
            tags$h4(
              "REMINDER: This tool is for educational purposes only and does not replace professional medical or genetic consultation. Users are strongly encouraged to consult a genetic counsellor or clinician before drawing conclusions from variant information."
            ),
            # Heading with examples
            tags$h4(style = "opacity: 0.5;", "Examples:"),
            tags$p(style = "opacity: 0.5;", "For ClinVar enter the accession e.g. RCV000007523."),
            tags$p(
              style = "opacity: 0.5;",
              "For dbSNP enter the accession number only (remove rs) e.g. 137854557."
            ),
            tags$p(style = "opacity: 0.5;", "For Gene enter a GeneSymbol e.g. BRCA1."),
            tags$p(
              style = "opacity: 0.5;",
              "For Disorder enter the name of the disorder e.g. Noonan Syndrome."
            ),
            tags$p(
              style = "opacity: 0.5;",
              "For Variant enter the amino acid change (c.44C>T), protein change (p.Pro15Leu) or the reference sequence from the GenBank database (NM_004006.3)."
            )
          )
        )),
        
        tabItem(
          tabName = "vcfpanel",
          h1("VCF Panel"),
          
          fileInput("input_file", "Upload VCF File", accept = c(".vcf.gz")),
          
          tabsetPanel(tabPanel("Results", fluidRow(
            wellPanel(
              title = "Variant Information",
              solidHeader = TRUE,
              status = "primary",
              div(style = "overflow-x: scroll; width: 100%;", dataTableOutput("variant_table"))
            )
          )), tabPanel("Graphs", fluidRow(
            tabsetPanel(box("plot1", plotOutput("PLOT1")), box("plot2", plotOutput("PLOT2")))
          )))
        ),
        tabItem(tabName = "diagnostic_report", tabsetPanel(
          tabPanel(
            "Disorder Information",
            h2("Disorder Information"),
            p(
              "Here is some information on the selected disorder, accession or gene from the Clinvar search panel."
            ),
            p(
              "REMINDER: This tool is for educational purposes only and does not replace professional medical or genetic consultation. Users are strongly encouraged to consult a genetic counsellor or clinician before drawing conclusions from variant information."
            ),
            fluidRow(
              column(
                width = 12,
                actionButton(
                  "buttonOMIM",
                  label = "OMIM",
                  icon = icon("up-right-from-square")
                ),
                p(
                  style = "text-align: justify;",
                  "Online Mendelian Inheritance in Man (OMIM) is a comprehensive database of human genes and genetic phenotypes. It catalogues information about genetic disorders and their associated genes, including clinical descriptions, molecular mechanisms, and inheritance patterns. Clinicians and researchers can use OMIM to explore the genetic basis of rare diseases and access curated information about specific disorders."
                ),
                p(
                  style = "text-align: justify;",
                  "This button works if you entered: Gene, ClinVar, dbSNP or Disorder"
                )
              ),
              column(
                width = 12,
                actionButton(
                  "buttonPubMed",
                  label = "PubMed",
                  icon = icon("up-right-from-square")
                ),
                p(
                  style = "text-align: justify;",
                  "PubMed provides clinicians with a repository of literature, aiding in  evidence-based practices into patient care, particularly in rare diseases where information is limited. For researchers, PubMed is useful for conducting literature reviews, identifying research gaps, and fostering collaboration to advance understanding and treatment of rare diseases."
                ),
                p(style = "text-align: justify;", "This button works if you entered: Gene")
              ),
              column(
                width = 12,
                actionButton(
                  "buttonNORD",
                  label = "NORD",
                  icon = icon("up-right-from-square")
                ),
                p(
                  style = "text-align: justify;",
                  "NORD's rare disease database is a comprehensive resource providing information on various rare disorders, including their symptoms, causes, treatments, and available support services. It serves as a valuable tool for  clinicians and researchers seeking reliable information and resources."
                ),
                p(style = "text-align: justify;", "This button works if you entered: Disorder")
              )
            )
          ),
          tabPanel(
            "Clinician and Researcher Support",
            h2("Information for clinician and researchers"),
            p("This is the content for Clinician and Researcher Support."),
            fluidRow(
              column(
                width = 6,
                actionButton("buttonClinVar", label = "ClinVar", icon = icon("up-right-from-square")),
                p(style = "text-align: justify;",
                  "ClinVar is a public archive of reports and interpretations of the clinical significance of genomic variants. It aggregates data from various sources. It can be used to evaluate the significance of genetic variants in the context of rare diseases, aiding in diagnosis, treatment decisions, and research investigations."),
                p(style = "text-align: justify;", "This button works if you entered: Gene or a ClinVar accession")
              ),
              column(
                width = 6,
                actionButton("buttongenomAD", label = "genomAD", icon = icon("up-right-from-square")),
                p(style = "text-align: justify;",
                  "The Genome Aggregation Database is a  resource that aggregates sequencing data from a diverse range of populations. It provides  information about genetic variation, including allele frequencies, functional annotations, and population-specific patterns. The frequency and distribution of genetic variants across populations can be assessed aiding in interpretation of rare and common variants in many populations."),
                p(style = "text-align: justify;", "This button works if you entered: Gene")
              ),
              column(
                width = 6,
                actionButton("buttonPubMed1", label = "PubMed", icon = icon("up-right-from-square")),
                p(style = "text-align: justify;",
                  "PubMed provides clinicians and researchers with an updated repository of literature on disorders and genes aiding in an improved understanding of rare diseases."),
                p(style = "text-align: justify;", "This button works if you entered: Gene or Disorder")
              ),
              column(
                width = 6,
                actionButton("buttonGeneReviews", label = "GeneReviews", icon = icon("up-right-from-square")),
                p(style = "text-align: justify;",
                  "GeneReviews is a comprehensive resource providing expert-authored, peer-reviewed information about genetic conditions. It offers detailed summaries of specific genes and the associated diseases. It can be used to inform patient care and research efforts."),
                p(style = "text-align: justify;", "This button works if you entered: Gene")
              ),
              column(
                width = 6,
                actionButton("buttonVarsome", label = "Varsome", icon = icon("up-right-from-square")),
                p(style = "text-align: justify;",
                  "Varsome is a variant interpretation tool that helps clinicians and researchers analyze and interpret genetic variants. It integrates data from various sources to provide  variant annotations and interpretations which can be used to assess the clinical significance of variants in rare diseases."),
                p(style = "text-align: justify;", "This button works if you entered: Gene, dbSNP, or Disorder")
              ),
              column(
                width = 6,
                actionButton("buttonLitVar", label = "LitVar", icon = icon("up-right-from-square")),
                p(style = "text-align: justify;",
                  "LitVar is a database that aggregates information about variants, genes and disorders mentioned in  literature. It provides annotations and links to relevant publications, helping researchers and clinicians stay updated on the latest findings related to rare diseases."),
                p(style = "text-align: justify;", "This button works if you entered: Gene, dbSNP, or Disorder")
              ),
              column(
                width = 6,
                actionButton("buttondbSNP", label = "dbSNP", icon = icon("up-right-from-square")),
                p(style = "text-align: justify;",
                  "The Single Nucleotide Polymorphism Database (dbSNP) is a repository that catalogs genetic variation. It can be used to explore genetic variation across populations and understand how specific variants may be associated with rare diseases."),
                p(style = "text-align: justify;", "This button works if you entered: Gene or dbSNP")
              ),
              column(
                width = 6,
                actionButton("buttonNORD1", label = "NORD", icon = icon("up-right-from-square")),
                p(style = "text-align: justify;",
                  "NORD provides a comprehensive resource for information on rare disorders, including their symptoms, causes, treatments, etc. It serves as a valuable tool for seeking reliable information and resources."),
                p(style = "text-align: justify;", "This button works if you entered: Disorder")
              )
            )
          ),
          
          tabPanel(
            "Patient Support",
            h2("Patient Support"),
            p("Support page for rare disease patients and families"),
            fluidRow(
              column(
                width = 6,
                actionButton("buttonRareConnect", label = "RareConnect", icon = icon("up-right-from-square")),
                p(style = "text-align: justify;",
                  "RareConnect is an online platform that connects people affected by rare diseases worldwide. It hosts various disease-specific communities where patients, caregivers, and advocates can share experiences, ask questions, and provide support to each other.")
              ),
              column(
                width = 6,
                actionButton("buttonRAReSOURCE", label = "RAReSOURCE", icon = icon("up-right-from-square")),
                p(style = "text-align: justify;",
                  "RARe-SOURCE provides a list of rare diseases with their gene associations, links to related features within the database and links to external data sources.")
              ),
              column(
                width = 6,
                actionButton("buttonRDSA", label = "RDSA", icon = icon("up-right-from-square")),
                p(style = "text-align: justify;",
                  "Rare Diseases South Africa is a non-profit organisation which advocates for rare disease patients to achieve greater recognition, support, improved health service and better overall quality of life. It allows patients and families to access local support groups, advocacy organizations, and healthcare resources.")
              ),
              column(
                width = 6,
                actionButton("buttonGARD", label = "GARD", icon = icon("up-right-from-square")),
                p(style = "text-align: justify;",
                  "The Genetic and Rare Diseases Information Center (GARD) provides access to comprehensive information about rare diseases. It allows users to search for specific diseases and access resources such as overviews, symptoms, causes, treatment options, and research updates."),
                p(style = "text-align: justify;", "This button works if you entered: Disorder")
              ),
              column(
                width = 6,
                actionButton("buttonNORDORG", label = "NORD Patient Organizations", icon = icon("up-right-from-square")),
                p(style = "text-align: justify;",
                  "NORD's patient organizations database raises awareness about rare disorders by connecting affected individuals and families  with relevant support groups and advocacy organizations around the world.")
              )
            )
          ),
          
          tabPanel("Genetic Resources Guide",
                   h3("RareInsight: Simplifying Online Genetic Resources"),
                   downloadButton("download_genetic_resources", "Download as HTML"),
                   br(), br(),
                   uiOutput("view_genetic_resources")
          ),
          
          
          tabItem(
            tabName = "acknow",
            h2("Contributors:"),
            h4(
              HTML(
                "<a href='https://github.com/Kimmiecc19'>KC Coetzer</a>: Division of Molecular Biology and Human Genetics, Department of Biomedical Sciences, Faculty of Medicine and Health Sciences, Stellenbosch University, Cape Town, South Africa"
              )
            ),
            h4(
              HTML(
                "<a href='https://github.com/Zemzemfiras1'>F Zemzem</a>: Laboratory of Cytogenetics, Molecular Genetics and Biology of Reproduction CHU Farhat Hached Sousse, Higher Institute of Biotechnology of Monastir, University of Monastir, Tunisia"
              )
            ),
            h4(
              HTML(
                "<a href='https://github.com/AkurutEva'>E Akurut</a>: African Centre of Excellence in Bioinformatics and Data-intensive Sciences, Infectious Disease Institute, Makerere University, Kampala, Uganda"
              )
            ),
            h4(
              HTML(
                "<a href='https://github.com/gwiafe'>G Wiafe</a>: Department of Biomedical Sciences, University of Cape Coast, Cape Coast, Ghana"
              )
            ),
            h4(
              HTML(
                "<a href='https://github.com/laitanawe'>OI Awe</a>: African Society for Bioinformatics and Computational Biology, Cape Town, South Africa"
              )
            ),
            h2("Thank you to the following organizations for their support:"),
            h4(
              "African Society for Bioinformatics and Computational Biology",
              img(
                src = "asbcb-logo.png",
                height = 50,
                width = 50
              )
            ),
            h2("For more information: "),
            h4(
              HTML(
                "<a href='https://github.com/omicscodeathon/rareinsight/'>GitHub</a>: Read more about this research and access all our scripts."))
          ) # close ackowledgements tab
        ) # Clost tabitem (diagnostic report)
        ) # close diagnostic_report panel
      ) # close tabItems
    ) # close dashboardBody
  )) # Close fuidPage and dashboardPage

# Define server logic
server <- function(input, output, session) {
  
  # Download files as HTML
  
  output$download_glossary <- downloadHandler(
    filename = function() {
      paste0("Glossary_", Sys.Date(), ".html")
    },
    content = function(file) {
      file.copy("www/glossary.html", file)
    },
    contentType = "text/html"
  )
  
  output$download_basic_genetics <- downloadHandler(
    filename = function() {
      paste0("Basic_Genetics_", Sys.Date(), ".html")
    },
    content = function(file) {
      file.copy("www/basic_genetics.html", file)
    },
    contentType = "text/html"
  )
  
  output$download_rare_diseases <- downloadHandler(
    filename = function() {
      paste0("Rare_Diseases_", Sys.Date(), ".html")
    },
    content = function(file) {
      file.copy("www/rare_diseases.html", file)
    },
    contentType = "text/html"
  )
  
  output$download_genetic_resources <- downloadHandler(
    filename = function() {
      paste0("Genetic_Resources_Guide_", Sys.Date(), ".html")
    },
    content = function(file) {
      file.copy("www/genetic_resources_guide.html", file)
    },
    contentType = "text/html")
  
  # Display HTML in dashboard
  output$view_glossary <- renderUI({
    tags$iframe(src = "glossary.html", style = "width:100%;height:800px;border:none;")
  })
  
  output$view_basic_genetics <- renderUI({
    tags$iframe(src = "basic_genetics.html", style = "width:100%;height:800px;border:none;")
  })
  
  output$view_rare_diseases <- renderUI({
    tags$iframe(src = "rare_diseases.html", style = "width:100%;height:800px;border:none;")
  })
  
  output$view_genetic_resources <- renderUI({
    tags$iframe(src = "genetic_resources_guide.html", style = "width:100%;height:800px;border:none;")
  })
  
  # Trigger role selection on startup
  observeEvent(TRUE, {
    confirmSweetAlert(
      inputId = "role_select",
      title = "Welcome to RareInsight",
      text = "Are you a patient/caregiver or clinician/researcher?",
      btn_labels = c("Clinician/Researcher", "Patient/Caregiver"),
      swalType = "question",
      danger_mode = FALSE,
      closeOnClickOutside = FALSE,
      showCloseButton = FALSE,
      timer = NULL
    )
  }, once = TRUE)
  
  # Handle Patient/Caregiver selection
  observeEvent(input$role_select, {
    if (input$role_select) {  # TRUE = Patient/Caregiver, FALSE = Clinician
      showModal(modalDialog(
        title = "Tell us a bit more",
        radioButtons("q1", "Have you seen a geneticist?", choices = c("Yes", "No")),
        radioButtons("q2", "Have you undergone any testing?", choices = c("Yes", "No")),
        radioButtons("q3", "Do you have a confirmed diagnosis?", choices = c("Yes", "No")),
        checkboxInput("disclaimer_ack",
                      "I understand this tool is for educational purposes only and does not replace professional consultation.",
                      value = FALSE),
        footer = tagList(
          actionButton("confirm_patient", "Continue", class = "btn-primary")
        ),
        easyClose = FALSE
      ))
    }
  })
  
  # Validate patient input
  observeEvent(input$confirm_patient, {
    if (!input$disclaimer_ack) {
      showNotification("Please acknowledge the disclaimer to continue.", type = "error")
    } else {
      removeModal()
      output$user_type <- renderText("You selected: Patient/Caregiver")
    }
  })
  
  # For clinician selection
  observeEvent(input$role_select, {
    if (!input$role_select) {
      output$user_type <- renderText("You selected: Clinician/Researcher")
    }
  })
  
  # Define variant_summary
  variant_summary <- reactiveVal(NULL)
  
  observe({
    withProgress(
      message = 'Downloading and processing data...',
      detail = 'This may take a while...',
      value = 0,
      {
        # File paths
        gz_file <- "www/variant_summary.txt.gz"
        txt_file <- "www/variant_summary.txt"
        
        # Function to download file if it doesn't exist
        download_file <- function(url, dest_file) {
          if (!file.exists(dest_file)) {
            tryCatch({
              download.file(url, destfile = dest_file, mode = "wb")
              cat("...download complete...\n")
            }, error = function(e) {
              cat("Error downloading file:", e$message, "\n")
            })
          } else {
            cat("...File already exists...\n")
          }
        }
        
        # Download only if txt file doesn't exist
        if (!file.exists(txt_file)) {
          cat("...Checking for gz file to download...\n")
          download_file(
            "https://ftp.ncbi.nlm.nih.gov/pub/clinvar/tab_delimited/variant_summary.txt.gz",
            gz_file
          )
        } else {
          cat("...Text file already exists. Skipping download and unzip...\n")
        }
        
        # Unzip only if txt file doesn't exist but gz does
        if (!file.exists(txt_file) && file.exists(gz_file)) {
          cat("...Unzipping the file...\n")
          tryCatch({
            con <- gzfile(gz_file, "rt")
            writeLines(readLines(con), txt_file)
            close(con)
            cat("...Unzipped successfully...\n")
          }, error = function(e) {
            cat("Error unzipping file:", e$message, "\n")
          })
        }
        
        # Load data
        if (file.exists(txt_file)) {
          cat("...Reading the file into memory...\n")
          variant_summary_data <- read.delim(txt_file, stringsAsFactors = FALSE)
          variant_summary(variant_summary_data)
        } else {
          cat("ERROR: variant_summary.txt not found.\n")
        }
      }
    )
  })
  
  # Downloadable user info content
  output$download_button <- downloadHandler(
    filename = function() {
      paste(input$name, input$surname, Sys.Date(), ".pdf", sep = "")
    },
    content = function(file) {
      # Create the R Markdown content
      rmd_content <- sprintf(
        'RAREINSIGHT REPORT

                            User Information :
                            __________________

                            Name: %s
                            Surname: %s
                            Ethnicity: %s
                            Date of Birth: %s
                            Clinical Diagnosis (OMIM): %s
                            Phenotype (HPO Terms): %s
                            Test Performed:  %s',
        input$name,
        input$surname,
        input$ethnicity,
        input$dob,
        input$clinical_diagnosis,
        input$phenotype,
        input$test_performed
      )
      img(src = "rareinsight_final.png", height = 50)
      
      # Create a temporary file to store the R Markdown content
      temp_rmd_file <- tempfile(fileext = ".Rmd")
      # Write the R Markdown content to the temporary file
      writeLines(rmd_content, temp_rmd_file)
      
      # Render the R Markdown file to PDF
      rmarkdown::render(temp_rmd_file, output_file = file)
      # Remove the temporary R Markdown file
      unlink(temp_rmd_file)
    },
    contentType = "application/pdf"  # Set content type to PDF
  )
  
  # Observing search button click
  observeEvent(input$search_button, {
    search_term <- input$search_input
    search_type <- input$search_type
    
    req(search_term, search_type) # Ensure search term and type are available
    
    if (nchar(search_term) > 0) {
      # Define the column to search based on search type
      search_column <- switch(
        search_type,
        "Gene" = "GeneSymbol",
        "Variant" = "Name",
        "Disorder" = "PhenotypeList",
        "dbSNP" = "RS...dbSNP.",
        "ClinVar" = "RCVaccession"
      )
      
      # Filter data based on search term and column
      indices <- grep(search_term, variant_summary()[[search_column]], ignore.case = TRUE)
      if (length(indices) > 0) {
        filtered_data <- variant_summary()[indices, ]
        output$search_results <- renderDT({
          datatable(filtered_data, options = list(scrollX = TRUE))
        })
      } else {
        output$search_results <- renderDT({
          HTML("<p>No matching results found.</p>")
        })
      }
    } else {
      # If there's no search term, show an alert message
      showModal(
        modalDialog(
          title = "Error",
          "Please enter a search term in the Search Panel first.",
          easyClose = TRUE
        )
      )
      return()
    }
  })
  
  observeEvent(input$buttonOMIM, {
    search_term <- isolate(input$search_input)
    search_type <- isolate(input$search_type)
    
    if (nchar(search_term) > 0) {
      omim_search_url <- ""
      
      if (search_type %in% c("Gene", "ClinVar", "Disorder")) {
        # Construct the OMIM search URL based on the search type
        omim_search_url <- paste0(
          "https://www.omim.org/search?index=entry&start=1&search=",
          URLencode(search_term),
          "&sort=score+desc%2C+prefix_sort+desc&limit=10&date_created_from=&date_created_to=&date_updated_from=&date_updated_to="
        )
      } else if (search_type == "dbSNP") {
        # Check if "rs" is in the search term, if not, add it
        if (!grepl("rs", search_term, ignore.case = TRUE)) {
          search_term <- paste0("rs", search_term)
        }
        # Construct the OMIM search URL for dbSNP
        omim_search_url <- paste0(
          "https://www.omim.org/search?index=entry&start=1&search=",
          URLencode(search_term),
          "&sort=score+desc%2C+prefix_sort+desc&limit=10&date_created_from=&date_created_to=&date_updated_from=&date_updated_to="
        )
      }
      
      browseURL(omim_search_url)
    } else {
      showModal(
        modalDialog(
          title = "Error",
          "Please enter a search term in the Search Panel first.",
          easyClose = TRUE
        )
      )
    }
  })
  
  
  ### buttonClinVar
  observeEvent(input$buttonClinVar, {
    search_term <- isolate(input$search_input)
    search_type <- isolate(input$search_type)
    if (search_type %in% c("Gene", "ClinVar")) {
      if (nchar(search_term) > 0) {
        if (search_type == "Gene") {
          # Construct the Clinvar search URL for gene
          ClinVar_search_url <- paste0(
            "https://www.ncbi.nlm.nih.gov/clinvar/?term=",
            URLencode(search_term),
            "%5Bgene%5D&redir=gene"
          )
        } else if (search_type == "ClinVar") {
          # Construct the Clinvar search URL for RCVaccession
          ClinVar_search_url <- paste0(
            "https://www.ncbi.nlm.nih.gov/clinvar/?term=",
            URLencode(search_term),
            "&redir=rcv"
          )
        }
        browseURL(ClinVar_search_url)
      } else {
        showModal(
          modalDialog(
            title = "Error",
            "Please enter a search term in the Search Panel first.",
            easyClose = TRUE
          )
        )
      }
    }
  })
  
  ### buttonPubMed
  observeEvent(input$buttonPubMed, {
    search_term <- isolate(input$search_input)
    search_type <- isolate(input$search_type)   # Get the search term from the Search Panel
    if (search_type %in% c("Gene")) {
      if (nchar(search_term) > 0) {
        if (search_type == "Gene") {
          # Construct the PubMed search URL for gene only
          PubMed_search_url <- paste0("https://pubmed.ncbi.nlm.nih.gov/?term=",
                                      URLencode(search_term))
        }
        browseURL(PubMed_search_url)
      } else {
        showModal(
          modalDialog(
            title = "Error",
            "Please enter a search term in the Search Panel first.",
            easyClose = TRUE
          )
        )
      }
    }
  })
  ### buttonPubMed1 in Clinician and research support panel
  observeEvent(input$buttonPubMed1, {
    search_term <- isolate(input$search_input)
    search_type <- isolate(input$search_type)   # Get the search term from the Search Panel
    if (search_type %in% c("Gene", "Disorder")) {
      if (nchar(search_term) > 0) {
        # Construct the PubMed search URL for gene only
        PubMed_search_url <- paste0("https://pubmed.ncbi.nlm.nih.gov/?term=",
                                    URLencode(search_term))
        browseURL(PubMed_search_url)
      } else {
        showModal(
          modalDialog(
            title = "Error",
            "Please enter a search term in the Search Panel first.",
            easyClose = TRUE
          )
        )
      }
    }
  })
  ### buttonGeneReviews
  observeEvent(input$buttonGeneReviews, {
    search_term <- isolate(input$search_input)
    search_type <- isolate(input$search_type)   # Get the search term from the Search Panel
    if (search_type %in% c("Gene")) {
      if (nchar(search_term) > 0) {
        if (search_type == "Gene") {
          # Construct the GeneReviews search URL for gene only
          GeneReviews_search_url <- paste0(
            "https://www.ncbi.nlm.nih.gov/books/NBK1116/?term=",
            URLencode(search_term),
            "gene%20review"
          )
        }
        browseURL(GeneReviews_search_url)
      } else {
        showModal(
          modalDialog(
            title = "Error",
            "Please enter a search term in the Search Panel first.",
            easyClose = TRUE
          )
        )
      }
    }
  })
  
  ### buttonLitVar
  observeEvent(input$buttonLitVar, {
    search_term <- isolate(input$search_input)
    search_type <- isolate(input$search_type) # Get the search term from the Search Panel
    if (search_type %in% c("Gene", "Disorder")) {
      if (nchar(search_term) > 0) {
        # Construct the LitVar search URL for gene or disorder
        if (length(strsplit(search_term, " ")[[1]]) > 1) {
          search_term <- gsub(" ", "%20", search_term)
        }
        LitVar_search_url <- paste0(
          "https://www.ncbi.nlm.nih.gov/research/litvar2/docsum?text=",
          URLencode(search_term)
        )
        browseURL(LitVar_search_url) # Moved browseURL here
      } else {
        showModal(
          modalDialog(
            title = "Error",
            "Please enter a search term in the Search Panel first.",
            easyClose = TRUE
          )
        )
      }
    } else if (search_type == "dbSNP") {
      if (nchar(search_term) > 0) {
        # Check if "rs" is in the search term, if not, add it
        if (!grepl("rs", search_term, ignore.case = TRUE)) {
          search_term <- paste0("rs", search_term)
        }
        # Construct the LitVar search URL for dbSNP
        LitVar_search_url <- paste0(
          "https://www.ncbi.nlm.nih.gov/research/litvar2/docsum?variant=litvar@",
          URLencode(search_term),
          "%23%23&query="
        )
        browseURL(LitVar_search_url) # Moved browseURL here
      } else {
        showModal(
          modalDialog(
            title = "Error",
            "Please enter a search term in the Search Panel first.",
            easyClose = TRUE
          )
        )
      }
    }
  })
  
  ### buttonVarsome
  observeEvent(input$buttonVarsome, {
    search_term <- isolate(input$search_input)
    search_type <- isolate(input$search_type)
    if (search_type %in% c("Gene", "dbSNP", "Disorder")) {
      if (nchar(search_term) > 0) {
        if (search_type == "Gene") {
          # Construct the Varsome search URL for gene
          Varsome_search_url <- paste0("https://varsome.com/gene/hg38/",
                                       URLencode(search_term))
        } else if (search_type == "dbSNP") {
          # Construct the Varsome search URL for dbSNP
          Varsome_search_url <- paste0("https://varsome.com/variant/hg38/",
                                       URLencode(search_term))
        } else if (search_type == "Disorder") {
          # Check if search term has more than one word, replace spaces with %20
          if (length(strsplit(search_term, " ")[[1]]) > 1) {
            search_term <- gsub(" ", "%20", search_term)
          }
          # Construct the Disorder search URL for disease name
          Varsome_search_url <- paste0("https://varsome.com/search-results/",
                                       URLencode(search_term))
        }
        browseURL(Varsome_search_url)
      } else {
        showModal(
          modalDialog(
            title = "Error",
            "Please enter a search term in the Search Panel first.",
            easyClose = TRUE
          )
        )
      }
    }
  })
  
  ### buttondbSNP
  observeEvent(input$buttondbSNP, {
    search_term <- isolate(input$search_input)
    search_type <- isolate(input$search_type)
    if (search_type %in% c("Gene", "dbSNP")) {
      if (nchar(search_term) > 0) {
        if (search_type == "Gene") {
          # Construct the dbSNP search URL for gene
          dbSNP_search_url <- paste0("https://www.ncbi.nlm.nih.gov/snp/?term=",
                                     URLencode(search_term))
        } else if (search_type == "dbSNP") {
          # Construct the dbSNP search URL for dbSNP
          dbSNP_search_url <- paste0(
            "https://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?rs=",
            URLencode(search_term)
          )
        }
        browseURL(dbSNP_search_url)
      } else {
        showModal(
          modalDialog(
            title = "Error",
            "Please enter a search term in the Search Panel first.",
            easyClose = TRUE
          )
        )
      }
    }
  })
  
  ### buttonNORD
  observeEvent(input$buttonNORD, {
    search_term <- isolate(input$search_input)
    search_type <- isolate(input$search_type)
    if (search_type %in% c("Disorder")) {
      if (nchar(search_term) > 0) {
        if (search_type == "Disorder") {
          # Check if search term has more than one word, replace spaces with -
          if (length(strsplit(search_term, " ")[[1]]) > 1) {
            search_term <- gsub(" ", "-", search_term)
          }
          # Construct the NORD search URL for disorder
          NORD_search_url <- paste0("https://rarediseases.org/rare-diseases/",
                                    URLencode(search_term))
        }
        browseURL(NORD_search_url)
      } else {
        showModal(
          modalDialog(
            title = "Error",
            "Please enter a search term in the Search Panel first.",
            easyClose = TRUE
          )
        )
      }
    }
  })
  ### buttonNORD in Clinician and Researcher Support panel
  observeEvent(input$buttonNORD1, {
    search_term <- isolate(input$search_input)
    search_type <- isolate(input$search_type)
    if (search_type %in% c("Disorder")) {
      if (nchar(search_term) > 0) {
        if (search_type == "Disorder") {
          # Check if search term has more than one word, replace spaces with -
          if (length(strsplit(search_term, " ")[[1]]) > 1) {
            search_term <- gsub(" ", "-", search_term)
          }
          # Construct the NORD search URL for disorder
          NORD_search_url <- paste0("https://rarediseases.org/rare-diseases/",
                                    URLencode(search_term))
        }
        browseURL(NORD_search_url)
      } else {
        showModal(
          modalDialog(
            title = "Error",
            "Please enter a search term in the Search Panel first.",
            easyClose = TRUE
          )
        )
      }
    }
  })
  #buttongnomAD
  observeEvent(input$buttongenomAD, {
    search_term <- isolate(input$search_input)
    search_type <- isolate(input$search_type)  # Get the search term from the Search Panel
    if (nchar(search_term) > 0) {
      # If there's a search term, query Ensembl REST API to get Ensembl ID
      ensembl_api_url <- paste0(
        "https://rest.ensembl.org/lookup/symbol/human/",
        URLencode(search_term),
        "?content-type=application/json"
      )
      ensembl_response <- httr::GET(ensembl_api_url)
      if (httr::http_error(ensembl_response)) {
        # If there's an error in API response, show an alert message
        showModal(
          modalDialog(
            title = "Error",
            "There was an error retrieving data from Ensembl.",
            easyClose = TRUE
          )
        )
      } else {
        ensembl_data <- httr::content(ensembl_response, as = "parsed")
        if (length(ensembl_data) > 0) {
          # If Ensembl ID found, construct the gnomAD search URL with the Ensembl ID and open it in the browser
          ensembl_id <- ensembl_data$id
          gnomad_search_url <- paste0("https://gnomad.broadinstitute.org/gene/",
                                      ensembl_id)
          browseURL(gnomad_search_url)
        } else {
          # If Ensembl ID not found, show an alert message
          showModal(
            modalDialog(
              title = "Error",
              "No matching gene found in Ensembl.",
              easyClose = TRUE
            )
          )
        }
      }
    } else {
      # If there's no search term, show an alert message
      showModal(
        modalDialog(
          title = "Error",
          "Please enter a search term in the Search Panel first.",
          easyClose = TRUE
        )
      )
    }
  })
  
  ### buttonRareConnect
  observeEvent(input$buttonRareConnect, {
    browseURL("https://www.rareconnect.org/en")
  })
  ### buttonRAReSOURCE
  observeEvent(input$buttonRAReSOURCE, {
    browseURL("https://raresource.nih.gov/diseases")
  })
  ### buttonRDSA
  observeEvent(input$buttonRDSA, {
    browseURL("https://www.rarediseases.co.za/support-groups-index")
  })
  ### buttonNORDORG
  observeEvent(input$buttonNORDORG, {
    browseURL("https://rarediseases.org/rare-diseases/")
  })
  
  
  ### buttonGARD
  observeEvent(input$buttonGARD, {
    search_term <- isolate(input$search_input)
    search_type <- isolate(input$search_type)
    if (search_type %in% c("Disorder")) {
      if (nchar(search_term) > 0) {
        if (search_type == "Disorder") {
          # Check if search term has more than one word, replace spaces with %20
          if (length(strsplit(search_term, " ")[[1]]) > 1) {
            search_term <- gsub(" ", "%20", search_term)
          }
          # Construct the GARD search URL for disorder
          GARD_search_url <- paste0(
            "https://rarediseases.info.nih.gov/diseases?category=&page=1&letter=&search=",
            URLencode(search_term)
          )
        }
        browseURL(GARD_search_url)
      } else {
        showModal(
          modalDialog(
            title = "Error",
            "Please enter a search term in the Search Panel first.",
            easyClose = TRUE
          )
        )
      }
    }
  })
  
  # User message
  observeEvent(input$input_file, {
    shinyWidgets::sendSweetAlert(
      session = session,
      title = "Processing File",
      text = "Uploading and parsing your VCF file. This may take a minute or two.",
      type = "info"
    )})
  
  ## VCF upload parser
  vcf_data <- reactive({
    req(input$input_file)
    vcf_file <- input$input_file$datapath
    vcf_data <- read.vcfR(vcf_file)
    return(vcf_data)
  })
  
  
  
  output$variant_table <- renderDataTable({
    req(vcf_data())
    
    # Extract and filter VCF
    full_info <- as.data.frame(vcf_data()@fix)
    # pass_filter <- full_info$FILTER %in% c("PASS", ".")
    pass_filter <- rep(TRUE, nrow(full_info))
    variant_info <- full_info[pass_filter, c("CHROM", "POS", "REF", "ALT")]
    info_raw <- full_info$INFO[pass_filter]
    
    # Parse INFO field
    parse_info_field <- function(info) {
      if (is.na(info)) return(list())
      info_list <- strsplit(info, ";")[[1]]
      parsed <- list()
      for (entry in info_list) {
        if (grepl("=", entry)) {
          key_val <- strsplit(entry, "=")[[1]]
          key <- key_val[1]
          val <- paste(key_val[-1], collapse = "=")
          parsed[[key]] <- val
        } else {
          parsed[[entry]] <- TRUE
        }
      }
      return(parsed)
    }
    
    info_parsed <- lapply(info_raw, parse_info_field)
    all_keys <- unique(unlist(lapply(info_parsed, names)))
    info_df <- as.data.frame(do.call(rbind, lapply(info_parsed, function(x) {
      filled <- sapply(all_keys, function(k) ifelse(!is.null(x[[k]]), x[[k]], NA))
      return(filled)
    })), stringsAsFactors = FALSE)
    
    variant_info_clean <- cbind(variant_info, info_df)
    
    # Handle SnpEff ANN field
    if ("ANN" %in% names(info_df)) {
      ann_cols <- c(
        "Allele", "Effect", "Impact", "Gene_Name", "Gene_ID",
        "Feature_Type", "Feature_ID", "Transcript_BioType", "Rank",
        "HGVS.c", "HGVS.p", "cDNA.pos", "CDS.pos", "AA.pos",
        "Distance", "Errors"
      )
      
      ann_split <- strsplit(info_df$ANN, ",")
      ann_df <- do.call(rbind, lapply(ann_split, function(x) {
        if (is.na(x[1]) || x[1] == "") {
          return(rep(NA, length(ann_cols)))
        }
        ann_entry <- unlist(strsplit(x[1], "\\|"))
        len_diff <- length(ann_cols) - length(ann_entry)
        if (len_diff > 0) {
          ann_entry <- c(ann_entry, rep(NA, len_diff))
        } else if (len_diff < 0) {
          ann_entry <- ann_entry[1:length(ann_cols)]
        }
        return(ann_entry)
      }))
      colnames(ann_df) <- ann_cols
      variant_info_clean <- cbind(variant_info_clean, ann_df)
    }
    
    # Handle VEP CSQ field
    if ("CSQ" %in% names(info_df)) {
      vep_cols <- c(
        "Allele", "Consequence", "IMPACT", "SYMBOL", "Gene",
        "Feature_type", "Feature", "BIOTYPE", "EXON", "INTRON",
        "HGVSc", "HGVSp", "cDNA_position", "CDS_position", "Protein_position"
      )
      
      csq_split <- strsplit(info_df$CSQ, ",")
      csq_df <- do.call(rbind, lapply(csq_split, function(x) {
        if (is.na(x[1]) || x[1] == "") {
          return(rep(NA, length(vep_cols)))
        }
        csq_entry <- unlist(strsplit(x[1], "\\|"))
        len_diff <- length(vep_cols) - length(csq_entry)
        if (len_diff > 0) {
          csq_entry <- c(csq_entry, rep(NA, len_diff))
        } else if (len_diff < 0) {
          csq_entry <- csq_entry[1:length(vep_cols)]
        }
        return(csq_entry)
      }))
      colnames(csq_df) <- vep_cols
      variant_info_clean <- cbind(variant_info_clean, csq_df)
    }
    
    # Handle ANNOVAR fields if present
    if ("Func.refGene" %in% names(info_df)) {
      annovar_cols <- c(
        "Func.refGene", "Gene.refGene", "ExonicFunc.refGene", "AAChange.refGene",
        "cytoBand", "avsnp150", "CLINSIG", "CLNDBN", "CLNREVSTAT"
      )
      for (col in annovar_cols) {
        if (!col %in% colnames(variant_info_clean)) {
          variant_info_clean[[col]] <- info_df[[col]]
        }
      }
    }
    
    # Render table
    print(dim(variant_info_clean))
    DT::datatable(
      variant_info_clean,
      options = list(
        pageLength = 10,
        scrollX = TRUE,
        searchHighlight = TRUE
      ),
      filter = "top",
      rownames = FALSE
    )
  })
  
  
  # Generate  PLOT2
  output$PLOT1 <- renderPlot({
    vcf <- vcf_data()
    plot(vcf)
    chrom <- create.chromR(name = 'Supercontig', vcf = vcf)
    plot(chrom)
    chrom <- proc.chromR(chrom, verbose = TRUE)
    plot(chrom)
  })
  
  # Generate PLOT2
  output$PLOT2 <- renderPlot({
    vcf <- vcf_data()
    plot(vcf)
    chrom <- create.chromR(name = 'Supercontig', vcf = vcf)
    plot(chrom)
    chrom <- proc.chromR(chrom, verbose = TRUE)
    plot(chrom)
    chromoqc(chrom, dp.alpha = 20)
    #      chromoqc(chrom, xlim=c(5e+05, 6e+05))
    
  })
}

shinyApp(ui, server)

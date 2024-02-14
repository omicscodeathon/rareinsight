library(shiny)
library(DT)  # For interactive tables

# Load the variant summary data obtained from https://ftp.ncbi.nlm.nih.gov/pub/clinvar/tab_delimited/variant_summary.txt.gz and unzipped
variant_summary <- read.delim("variant_summary.txt", stringsAsFactors = FALSE)

# Define the UI
ui <- fluidPage(
  titlePanel("Clinvar Variant Search"),
  sidebarLayout(
    sidebarPanel(
      selectInput("search_type", "Search Type:",
                  choices = c("Gene", "Variant", "Disorder"),
                  selected = "Gene"),
      textInput("search_input", "Enter Search Term:", ""),
      actionButton("search_button", "Search")
    ),
    mainPanel(
      DTOutput("search_results")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  observeEvent(input$search_button, {
    search_term <- input$search_input
    search_type <- input$search_type
    # Define the column to search based on search type
    search_column <- switch(
      search_type,
      "Gene" = "GeneSymbol",
      "Variant" = "Name",
      "Disorder" = "PhenotypeList"
    )
    # Filter data based on search term and column
    filtered_data <- variant_summary[grep(search_term, variant_summary[[search_column]], ignore.case = TRUE), ]
    output$search_results <- renderDT({
      if(nrow(filtered_data) == 0) {
        # Display a message if no results are found
        HTML("<p>No matching results found.</p>")
      } else {
        datatable(filtered_data, options = list(scrollX = TRUE))
      }
    })
  })
}

# Run the application
shinyApp(ui = ui, server = server)

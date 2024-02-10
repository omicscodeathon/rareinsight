library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "RareInsight"),
  dashboardSidebar(
    textInput("disorder_name", "Enter genetic disorder name"),
    textInput("hgvs_variant", "Enter HGVS variant"),
    actionButton("proceed_button", "Proceed")
  ),
  dashboardBody(
    tabBox(
      title = "Results",
      id = "tabset1",
      width = "100%",
      tabPanel("Disorder", "Clinical information will be displayed here"),
      tabPanel("ACMG Classification", "ACMG classification information will be displayed here"),
      tabPanel("Clinician and Researcher Support", "Clinician and researcher support information will be displayed here"),
      tabPanel("Patient Support", "Patient support information will be displayed here"),
      tabPanel("Export", "Export options will be displayed here")
    )
  )
)

server <- function(input, output, session) {
  # Search ClinVar for the input disorder name
  disorder_search_result <- reactive({
    disorder_name <- input$disorder_name
    clinvar_url <- paste0("https://www.ncbi.nlm.nih.gov/clinvar/?term=", URLencode(disorder_name))
    clinvar_response <- getURL(clinvar_url)
    clinvar_data <- fromJSON(clinvar_response)
    clinvar_data
  })

  # Trigger the search when the "Proceed" button is clicked
  observeEvent(input$proceed_button, {
    message("Searching ClinVar for disorder:", input$disorder_name)
  })

  # Display the search results on the "Disorder" tab
  output$disorder_info <- renderUI({
    disorder_search_result <- disorder_search_result()
    if (length(disorder_search_result$result_set$result) == 0) {
      "No results found."
    } else {
      first_result <- disorder_search_result$result_set$result[[1]]
      disorder_name <- first_result$condition$name
      paste("Disorder: ", disorder_name)
    }
  })
}

shinyApp(ui = ui, server = server)
#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    # Application title
    titlePanel("St Andrews Weather"),
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        # The side panel ----------------------------------------------------------
        sidebarPanel(
            # simple file uploader
            fileInput("file", label = h3("Upload a CSV file")),
            hr(),
            selectInput('variance', 'Select a column', ""),
            hr(),
            fluidRow(column(12, verbatimTextOutput("mean"),"")),
            hr(),
            fluidRow(column(12, verbatimTextOutput("ci"),""))
            # fluidRow(column(3, verbatimTextOutput("ci"))),
        ),
        # The main panel (with tabs) ----------------------------------------------
        # I'll put our results here
        mainPanel(
        # lets have some tabs
            tabsetPanel(
            # one tab - just a plot
              tabPanel("Plot", 
                  plotOutput("distPlot"))
            ) # end of tabsetPanel
        ) # end of main panel
    ) # end of sidebarLayout
)) # end fluidpage and UI

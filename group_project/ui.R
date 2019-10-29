# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
library(shiny)
library(parallel)
library(foreach)
library(doParallel)
library(iterators)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
    shinyjs::useShinyjs(),
    shinyjs::extendShinyjs(text = "shinyjs.refresh = function() { location.reload(); }"),
    # Application title
    titlePanel("St Andrews Weather and Bootstrapping"),
        sidebarPanel(
            # simple file uploader
            fileInput("file",label = "Click the button to upload a CSV file", accept = c('text/csv','text/comma-separated-values,text/plain','.csv')),
            hr(),
            uiOutput("independent"),
            hr(),
            uiOutput('action1') ,
            hr(),
            uiOutput('action2') ,
            hr(),
            uiOutput('action3') ,
            hr(),
            p("MEAN"),
            verbatimTextOutput("mean"),
            hr(),
            hr(),
            p("CI"),
            verbatimTextOutput("ci")
        ),
        # The main panel 
        # I'll put the distribution figure here
        mainPanel(
            # lets have some tabs
            tabsetPanel(
                # one tab - just a plot
                tabPanel("Plot",plotOutput("distPlot")),
                tabPanel("Weather in St Andrews", tableOutput("table"),
                         h4(), actionButton("refresh", "Refresh"))
            ) # end of tabsetPanel
        ) # end of main panel
)) # end fluidpage and UI


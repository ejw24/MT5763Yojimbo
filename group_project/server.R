# This is the server definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
library(shiny)
library(parallel)
library(foreach)
library(doParallel)
library(iterators)
nCores <- detectCores()
myClust <- makeCluster(nCores-1, type = "PSOCK") 
registerDoParallel(myClust)
# Define server logic required to draw a histogram
shinyServer(function(input,output,session){
  data <- reactive({
    req(input$file)
    userfile <- input$file
    userdata <- read.csv(userfile$datapath)
    return(userdata)
  })
  output$mean <- renderPrint({
    if (is.null(input$action1))return()
    if (input$action1==0)return()
    isolate({
      df <- data()
      if(is.null(df))return(NULL)
      x <- df[, c(input$independent)]
      bootmean <- foreach(i = 1:1000)%dopar%{
        bootData <- x[sample(1:length(x), length(x), replace = T)]
        mean <- mean(bootData)
        return(mean)
      }
      mean <- do.call(mean,bootmean)
      print(mean)
    })
  })
  output$ci <- renderPrint({
    if (is.null(input$action2))return()
    if (input$action2==0)return()
    isolate({
      df <- data()
      if(is.null(df))return(NULL)
      x <- df[, c(input$independent)]
      bootmean <- foreach(i = 1:1000)%dopar%{
        bootData <- x[sample(1:length(x), length(x), replace = T)]
        mean <- mean(bootData)
        return(mean)
      }
      bootmean <- unlist(bootmean,use.names=FALSE)
      ci <- quantile(bootmean,probs = c(0.025, 0.975))
      ci <- as.character(ci)
      print(ci)
    })
  })
  output$distPlot <- renderPlot({
    if (is.null(input$action3))return()
    if (input$action3==0)return()
    isolate({
      df <- data()
      if(is.null(df))return(NULL)
      x <- df[, c(input$independent)]
      bootmean <- foreach(i = 1:1000)%dopar%{
        bootData <- x[sample(1:length(x), length(x), replace = T)]
        mean <- mean(bootData)
        return(mean)
      }
      bootmean <- unlist(bootmean,use.names=FALSE)
      hist(bootmean,xlab = input$independent)
    })
  })
  output$action1 <- renderUI({
    if (is.null(data())) return(NULL)
    actionButton("action1", "Calculate the mean")
  })
  output$action2 <- renderUI({
    if (is.null(data())) return(NULL)
    actionButton("action2", "Calculate the confidence interval")
  })
  output$action3 <- renderUI({
    if (is.null(data())) return(NULL)
    actionButton("action3", "Plot the distrbution")
  })
  output$independent <- renderUI({
    df <- data()
    if (is.null(df)) return(NULL)
    items=names(df)
    selectInput("independent","Select ONE Variable:",items)
  })
  output$table <- renderTable({
    head(api())
  })
  observeEvent(input$refresh, {
    shinyjs::js$refresh()
  })
}) # end of server def


#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
# Define server logic required to draw a histogram
shinyServer(function(input,output,session){
    data <- reactive({
      req(input$file)
      userfile <- input$file
      userdata <- read.csv(userfile$datapath)
      updateSelectInput(session, inputId = 'variance', label = 'Select a column',
                        choices = names(userdata), selected = names(userdata))
      return(userdata)
    })
    library(parallel)
    library(foreach)
    nCores <- detectCores()
    myClust <- makeCluster(nCores-1, type = "PSOCK") 
    doParallel::registerDoParallel(myClust)
     output$distPlot <- renderPlot({
         x <- data()[, c(input$variance)]
         bootmean <- foreach(i = 1:length(x))%dopar%{
           bootData <- x[sample(1:length(x), length(x), replace = T)]
           mean <- mean(bootData)
           return(mean)
         }
         bootmean <- unlist(bootmean,use.names=FALSE)
         hist(bootmean)
     })
     output$mean <- renderPrint({
         x <- data()[, c(input$variance)]
         bootmean <- foreach(i = 1:length(x))%dopar%{
          bootData <- x[sample(1:length(x), length(x), replace = T)]
          mean <- mean(bootData)
          return(mean)
         }
         mean <- do.call(mean,bootmean)
         print(mean)
     })
     output$ci <- renderPrint({
         x <- data()[, c(input$variance)]
         bootmean <- foreach(i = 1:length(x))%dopar%{
          bootData <- x[sample(1:length(x), length(x), replace = T)]
          mean <- mean(bootData)
          return(mean)
         }
         bootmean <- unlist(bootmean,use.names=FALSE)
         ci <- quantile(bootmean,probs = c(0.025, 0.975))
         ci <- as.character(ci)
         print(ci)
     })
         #     bootData <- x[sample(1:nrow(x), nrow(x), replace = T),]
         #     mean <- mean(bootData)
         #     mean
         # })
         # variance <- input$text
         # x <- data()[,1]
         # bootData <- x[sample(1:nrow(x), nrow(x), replace = T),]
         # hist(bootData,col = 'blue', border = 'white')})

    # output$ci <- renderPrint({as.character(quantile(bootData, probs = c(0.025, 0.975)))})
}) # end of server def


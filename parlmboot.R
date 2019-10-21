library(profvis)
library(parallel)
library(foreach)
library(doParallel)

# initialize the parallel computing environment
nCores <- detectCores()
myClust <- makeCluster(nCores-1, type = "PSOCK") 
registerDoParallel(myClust)

set.seed(5763)
# create testing data
x <- runif(1000)
y <- 20 + 2*x + rnorm(1000, 0, 2.5)
regData <- data.frame(x, y)

parlmBoot <- function(inputData, nBoot){
  # use parallel computing function
  output <- foreach(i = 1:nBoot)%dopar%{
    
    # resample our data with replacement
    bootData <- inputData[sample(1:nrow(inputData), nrow(inputData), replace = T),]
    
    # fit the model under this alternative reality
    bootLM <- lm(y~., data = bootData)
    
    # store the coefs
    coef(bootLM)
  }
  
  # combine the results
  output <- do.call(rbind,output)
  
  return(output)
}

# test
parlmBoot(regData,1000)
system.time(parlmBoot(regData, 1000))

# close parallelization
stopCluster(myClust)

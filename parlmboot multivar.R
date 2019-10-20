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
z <- runif(1000)
y <- 20 + 2*x + 0.5*z + rnorm(1000, 0, 2.5)
regData <- data.frame(x, z, y)

parlmBoot <- function(inputData, nBoot){
  # use parallel computing function
  n <- nrow(inputData)
  nc <- ncol(inputData)
  output <- foreach(i = 1:nBoot) %dopar% {
    
    # resample our data with replacement
    bootData <- inputData[sample(1:n, n, replace = T),]
    
    # fit the model under this alternative reality
    bootLM <- lm(y~., data = bootData)
    
    # store the coefs
    coef(bootLM)
  }
  
  # combine the results
  output <- do.call(rbind,output)
  means <- c()
  lCI <- c()
  uCI <- c()
  for (i in 1:nc) {
    means[i] <- mean(output[,i])
    lCI[i] <- quantile(output[,i], probs = 0.025)
    uCI[i] <- quantile(output[,i], probs = 0.975)
}
  v <- data.table::data.table(Mean = means, lowerCI = lCI, upperCI = uCI)
        
  # m1 <- mean(output[,1])
  # CI1 <- quantile(output[,1], probs = c(0.025, 0.975))
  # vector1 <- c(m1, CI1)
  # m2 <- mean(output[,2])
  # CI2 <- quantile(output[,2], probs = c(0.025, 0.975))
  # vector2 <- c(m2, CI2)
  # m3 <- mean(output[,3])
  # CI3 <- quantile(output[,3], probs = c(0.025, 0.975))
  # vector3 <- c(m3, CI3)
  # vector <- c(vector1, vector2, vector3)
  # hist(output[,1])
  # hist(output[,2])
  # hist(output[,3])
  return(v)
}


# test
parlmBoot(regData,1000)
system.time(parlmBoot(regData, 1000))

# close parallelization
stopCluster(myClust)

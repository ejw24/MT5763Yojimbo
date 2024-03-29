# Global.R

library(shiny)
library(parallel)
library(foreach)
library(doParallel)
library(iterators)
library(httr)
library(jsonlite)
library(lubridate)
library(owmr)
library(data.table)
options(stringsAsFactors = F)
api <- function() {
  Sys.setenv(OWM_API_KEY = "692e04e9067881354b3e825e8e51eff3")
  # getting the current data for St Andrews
  res <- get_current(2638864, units = "metric")
  # time of weather update
  currentdatetime <- as_datetime(res$dt)
  currentdatetime <- as.character(currentdatetime)
  # time the table is rendered
  now <- as.character(now())
  # temperature now
  currenttemp <- res$main$temp
  # max temp now
  maxtemp <- res$main$temp_max
  # min temp now
  mintemp <- res$main$temp_min
  # sunrise today
  sunrisetoday <- as_datetime(res$sys$sunrise)
  sunrisetoday <- as.character(sunrisetoday)
  # sunset today
  sunsettoday <- as_datetime(res$sys$sunset)
  # calculating time until sunset
  timeuntilsunset <- hms::as.hms(sunsettoday - now())
  timeuntilsunset <- floor(timeuntilsunset)
  timeuntilsunset <- hms::as.hms(timeuntilsunset)
  timeuntilsunset <- as.character(timeuntilsunset)
  sunsettoday <- as.character(sunsettoday)
  # description of weather today
  lookslike <- as.character(res$weather$description)
  # humidity today
  humidity <- as.character(res$main$humidity)
  
  table <- data.table("Current Time" = now,
                      "Last updated" = currentdatetime,
                      "Sunrise" = sunrisetoday,
                      "Sunset" = sunsettoday,
                      "Looks like" = lookslike,
                      "Current Temp (°C)" = currenttemp,
                      "Minimum Temp (°C)" = mintemp,
                      "Maximum Temp (°C)" = maxtemp,
                      "Humidity (%)" = humidity,
                      "Time until Sunset (HH:MM:SS)" = timeuntilsunset)
  return(table)
}

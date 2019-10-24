#API

# St Andrews city id: 2638864
# API call: http://api.openweathermap.org/data/2.5/forecast?id=263886&APPID=692e04e9067881354b3e825e8e51eff3
install.packages(c("httr", "jsonlite", "lubridate", "owmr", "data.table"))
library(httr)
library(jsonlite)
library(lubridate)
library(owmr)
library(data.table)
options(stringsAsFactors = F)
Sys.setenv(OWM_API_KEY = "692e04e9067881354b3e825e8e51eff3")
res <- get_current(2638864, units = "metric")
currentdatetime <- as_datetime(res$dt)
currentdatetime <- as.character(currentdatetime)
now <- as.character(now())
currenttemp <- res$main$temp
maxtemp <- res$main$temp_max
mintemp <- res$main$temp_min
sunrisetoday <- as_datetime(res$sys$sunrise)
sunrisetoday <- as.character(sunrisetoday)
sunsettoday <- as_datetime(res$sys$sunset)
timeuntilsunset <- hms::as.hms(sunsettoday - now())
timeuntilsunset <- floor(timeuntilsunset)
timeuntilsunset <- hms::as.hms(timeuntilsunset)
timeuntilsunset <- as.character(timeuntilsunset)
sunsettoday <- as.character(sunsettoday)
lookslike <- as.character(res$weather$description)
humidity <- as.character(res$main$humidity)
Name <- c("Current time",
          "Last updated",
          "Sunrise",
          "Sunset",
          "Looks like",
          "Current Temp (Celsius)",
          "Minimum Temp (Celsius)",
          "Maximum Temp (Celsius)",
          "Humidity",
          "Time until Sunset (HH:MM:SS)")
Value <-  c(now,
           currentdatetime,
           sunrisetoday,
           sunsettoday,
           lookslike,
           currenttemp,
           mintemp,
           maxtemp,
           humidity,
           timeuntilsunset)
table <- data.table(Name, Value)
table

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
# our api key
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
                      "Current Temp (Celsius)" = currenttemp,
                      "Minimum Temp (Celsius)" = mintemp,
                      "Maximum Temp (Celsius)" = maxtemp,
                      "Humidity" = humidity,
                      "Time until Sunset (HH:MM:SS)" = timeuntilsunset)
  return(table)
}
a <- api()
names(a)
#download.file(get_icon_url(res$weather$icon), 'icon.png')


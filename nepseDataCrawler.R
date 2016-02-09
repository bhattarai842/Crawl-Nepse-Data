# https://github.com/ropensci/RSelenium
# file:///home/bhattarai/R/x86_64-pc-linux-gnu-library/3.1/RSelenium/doc/RSelenium-basics.html

require(RSelenium)
require(lubridate)

remDr <- remoteDriver(remoteServerAddr = 'localhost', port = 4444, browserName = 'firefox')
remDr$open()
remDr$getStatus()
url = "http://www.nepalsharemarket.com/NepalShareMarket/nepse/analysis/history.aspx"
remDr$navigate(url)
#Sending Element to web-driver

start_date <- "2008/01/01"
end_date <- "2014/10/31"
dates <- (seq(as.Date(start_date), as.Date(end_date), "day"))
date_conversion <- function(date){
  paste0(day(date), "/", month(date), "/", year(date))
}
dates <-unlist(lapply(dates, function(x){ date_conversion(x)}))


data_all <-data.frame(Companies = factor(),
                      Tran. = factor(),
                      Max. = factor(),
                      Min. = factor(),
                      Close = factor(),
                      Volume = factor(),
                      Amount = factor(),
                      Last.Close = factor(),
                      Net.Chg = factor(),
                      Date = as.Date(character())) 
  
for(date in dates){
  webElem.text <- remDr$findElement(using = 'id', value = 'txtDate')
  webElem.text$sendKeysToElement(list(date))
  # Click the button
  webElem.button <- remDr$findElement(using = "id", value = 'btnGo')
  webElem.button$clickElement()
  print("Click button")
  
  # Read table data
  print("Scrapte table")
  table <- remDr$executeScript("return NepseGrid.outerHTML;")[[1]]
  print("Read table")
  data <- readHTMLTable(table, header = T)$NepseGrid
  data <- data[!is.na(data$Tran.),]
  colnames(data)[8:9] <- c("Last.Close", "Net.Chg")
  data$Date <- date
  data_all <- rbind(data, data_all)
  remDr$executeScript("document.getElementById('txtDate').value = ''")
}

webElem<- remDr$findElement(using = 'id', value = 'txtDate')

webElem$sendKeysToElement(list("1/9/2014"))
# Click the button
webElem <- remDr$findElement(using = "id", value = 'btnGo')
webElem$clickElement()

# Read table data
webElem <- remDr$findElement(using = 'id', value = 'NepseGrid')
table <- remDr$executeScript("return NepseGrid.outerHTML;")[[1]]
data <- readHTMLTable(table, header = T)$NepseGrid
data <- data[!is.na(data$Tran.),]
colnames(data)[8:9] <- c("Last.Close", "Net.Chg")

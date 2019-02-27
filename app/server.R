library(shiny)
library(DT)
library(varhandle)
library(magrittr)
library(sp)
library(leaflet)
library(dplyr)
library(rgdal)
library(Rcpp)

load("data/subdat.RData")
zips=read.csv("data/zips3.csv",stringsAsFactors = F)
#subdat$ZIPCODE=zips$zip[52:102]
#subdat$zip=zips2$zip[52:109]
#subdat$value=zips$maxsala[52:102]
labels_sales <- sprintf(
  "Zip Code: <strong>%s</strong><br/>Average Annual Salary (AAS): <strong>$%g/yr<sup></sup></strong>",
  as.character(subdat$ZIPCODE), subdat$value
) %>% lapply(htmltools::HTML)

category=c("Administration & Human Resources",
           "Building Operations & Maintenance",
           "Clerical & Administrative Support",
           "Communications & Intergovernmental Affairs",
           "Community & Business Services",
           "Constituent Services & Community Programs",
           "Engineering, Architecture, & Planning",
           "Finance, Accounting & Procurement",
           "Health",
           "Information Technology & Telecommunications",
           "Legal Affairs",
           "Policy, Research & Analysis",
           "Public Safety, Inspections, & Enforcement",
           "Social Services",
           "Technology, Data & Innovation")
jobs=read.csv('data/jobs.csv')
subway <- read.csv('data/subwayinfo.csv', header=TRUE)
bar <- read.csv('data/Bars.csv', header=TRUE)
bus <- read.csv('data/bus_stop.csv', header=TRUE)
Cinema <- read.csv('data/theatre_dxy.csv', header=TRUE)
trans_time <- read.csv('data/trans_time1.csv', header=TRUE)
subway$on <- 1
bus$on <- 1
Cinema$on <- 1


server=function(input, output) {
  output$mymap <- renderLeaflet({
    m <- leaflet(data = subdat) %>%
      addTiles() %>%
      setView(lng=-73.98928, lat = 40.75042 , zoom =12)%>%
      addProviderTiles("Stamen.Toner")})
  pal <- colorNumeric(
    palette = "Reds",
    domain = subdat$value
  )
  leafletProxy("mymap",data=subdat)%>%
    addPolygons(layerId = ~ZIPCODE,
                stroke = T, weight=1,
                fillOpacity = 0.95,
                color = ~pal(value),
                highlightOptions = highlightOptions(color='#ff0000', opacity = 0.5, weight = 4, fillOpacity = 0.9,bringToFront = TRUE, sendToBack = TRUE),label = labels_sales,
                labelOptions = labelOptions(
                  style = list("font-weight" = "normal", padding = "3px 8px"),
                  textsize = "15px",
                  direction = "auto"))%>%
    addLegend(pal = pal, values = ~value, opacity = 1)
  median=jobs$medium
  
  output$NYC_jobs=renderDataTable(
    merge(trans_time[,c('X',paste('X',input$'zip_input',sep=""))],jobs%>%filter(median>input$slider1[1] & median<input$slider1[2]&
                                                                                  jobs$'score' <= input$crime & jobs$'Full.Time.Part.Time.indicator' == input$fulltime & (jobs$'Main.Skill' %in% input$variable) & jobs$'Job.Category' == input$'speech1'),  by.x='X', by.y='zip')  
    ,options = list(pageLength=5, scrollX = TRUE, scrollY = TRUE
    ))
  output$mymap2 <- renderLeaflet({
    m <- leaflet(data=jobs) %>%
      addTiles() %>%
      setView(lng=-73.98928, lat=40.75042 , zoom=12)%>%
      addProviderTiles("Stamen.Toner")%>%
      addMarkers(lng = ~bus[bus$on == ifelse((2 %in% input$map_select),1,0),]$LONGITUDE,
                 lat = ~bus[bus$on == ifelse((2 %in% input$map_select),1,0),]$LATITUDE,
                 icon = list(iconUrl='lib/bus.png',iconSize=c(15,15)))%>%
      addMarkers(lng = ~(Cinema[Cinema$on == ifelse((3 %in% input$map_select),1,0),])$lon,
                 lat = ~(Cinema[Cinema$on == ifelse((3 %in% input$map_select),1,0),])$lat,
                 icon = list(iconUrl='lib/Movie.png',iconSize=c(15,15)))%>%
      addMarkers(lng = ~(subway[subway$on == ifelse((1 %in% input$map_select),1,0),])$Station.Longitude,
                 lat = ~(subway[subway$on ==ifelse((1 %in% input$map_select),1,0),])$Station.Latitude,
                 icon = list(iconUrl='lib/metro.png',iconSize=c(15,15)))%>%
      addCircleMarkers(lng = ~ (jobs%>%filter(median>input$slider1[1] & median<input$slider1[2]&
                                                jobs$'score' <= input$crime & jobs$'Full.Time.Part.Time.indicator' == input$fulltime & (jobs$'Main.Skill' %in% input$variable) & jobs$'Job.Category' == input$'speech1')) $geocodes.lon,
                       lat = ~(jobs%>%filter(median>input$slider1[1] & median<input$slider1[2]&
                                               jobs$'score' <= input$crime & jobs$'Full.Time.Part.Time.indicator' == input$fulltime & (jobs$'Main.Skill' %in% input$variable) & jobs$'Job.Category' == input$'speech1') )$geocodes.lat,
                       stroke = FALSE, fillOpacity = 0.5
      )
    
    m
  })
  
}
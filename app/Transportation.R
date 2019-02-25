

library(shiny)
library(ggmap)
library(dplyr)
library(leaflet)
library(revgeo)

###Load data###
bus_count = read.csv('/Users/MacBook/Desktop/Data/bus_count.csv')
subway_count = read.csv('/Users/MacBook/Desktop/Data/subway_count.csv')
bus_stops = read.csv('/Users/MacBook/Desktop/Data/bus_stops.csv')
subway_stops = read.csv('/Users/MacBook/Desktop/Data/subway_stops.csv')
job = read.csv('/Users/MacBook/Desktop/job.csv')

###Boroughs###
subway_count <- 
  transform(
    subway_count,
    Boroughs =
      ifelse( zipcode %in% c(10026,10027, 10030, 10037, 10039) , 'Central Harlem' ,
              ifelse( zipcode %in% c(10001, 10011, 10018, 10019, 10020, 10036) , 'Chelsea and Clinton' ,
                      ifelse( zipcode %in% c(10029, 10035) , 'East Harlem' ,
                              ifelse( zipcode %in% c(10010, 10016, 10017, 10022), 'Gramercy Park and Murray Hill', 
                                      ifelse( zipcode %in% c(10004, 10005, 10006, 10007, 10038, 10280), 'Lower Manhattan' ,
                                              ifelse( zipcode %in% c(10002, 10003, 10009), 'Lower East Side' ,
                                                      ifelse( zipcode %in% c(10021, 10028, 10044, 10065, 10075, 10128), 'Upper East Side' ,
                                                              ifelse( zipcode %in% c(10023, 10024, 10025), 'Upper West Side', 'Inwood and Washington Heights')))))))))

str(subway_count) 
subway_count$Boroughs

bus_count <- 
  transform(
    bus_count,
    Boroughs =
      ifelse( zipcode %in% c(10026,10027, 10030, 10037, 10039) , 'Central Harlem' ,
              ifelse( zipcode %in% c(10001, 10011, 10018, 10019, 10020, 10036) , 'Chelsea and Clinton' ,
                      ifelse( zipcode %in% c(10029, 10035) , 'East Harlem' ,
                              ifelse( zipcode %in% c(10010, 10016, 10017, 10022), 'Gramercy Park and Murray Hill', 
                                      ifelse( zipcode %in% c(10004, 10005, 10006, 10007, 10038, 10280), 'Lower Manhattan' ,
                                              ifelse( zipcode %in% c(10002, 10003, 10009), 'Lower East Side' ,
                                                      ifelse( zipcode %in% c(10021, 10028, 10044, 10065, 10075, 10128), 'Upper East Side' ,
                                                              ifelse( zipcode %in% c(10023, 10024, 10025), 'Upper West Side', 'Inwood and Washington Heights')))))))))

str(bus_count) 
bus_count$Boroughs



  

ui = fluidPage(
  
  # Copy the line below to make a text input box
  textInput("text", label = h3("Transportation"), value = "123 West 116th Street"),
  
  hr(),
  fluidRow(column(3, verbatimTextOutput("value")))
  
)

server = function(input, output) {
  
  # You can access the value of the widget with input$text, e.g.
  output$value <- renderPrint({
    ###Stops count###
    geodata = geocode('input$text')
    geodata = as.data.frame(geodata)
    str(geodata)
    zip = revgeo(longitude=geodata$lon, latitude=geodata$lat, provider = 'google', API = "AIzaSyBiAeAiiRtpYFflQxXa5S9vr6sOM0wZBGQ", output = 'hash', item = 'zip')
    subway_count$V1[which(subway_count$zipcode==as.numeric(zip))]
    bus_count$count[which(bus_count$zipcode==as.numeric(zip))]
    
    for (i in subway_count$V1) {
      for (j in bus_count$count) {
        if(i+j >= 5) {
          print('Convenient')
        } else if(i+j == c(2:4)) {
          print('Not bad')
        } else {
          print('Terrible')
        }
      }}
  })
  
}



# Run the application 
shinyApp(ui = ui, server = server)


library(shiny)
library(DT)
library(varhandle)
library(magrittr)
library(sp)
library(leaflet)
library(dplyr)
library(rgdal)
library(Rcpp)


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


ui=fluidPage(includeCSS("style.css"),navbarPage(p(class="h","SuperHunt"),id = "inTabset",
                                                       tabPanel("All about Jobs",
                                                                leafletOutput("mymap",height = 1000)),
                                                       tabPanel("Recommendation",
                                                                selectInput("speech1","Category:" ,category
                                                                ),
                                                                sliderInput("slider1", label='Median Salary'
                                                                            ,min=20000,max=250000,value=c(10000,20000)),
                                                                selectInput("variable", "Skills:",
                                                                            c("Policy & Regulation" = "Policy & Regulation", 
                                                                              "Engineering" = "Engineering", "Database" = "Database", 
                                                                              "Legal" = "Legal", "Communication & Writing" = "Communication & Writing",
                                                                              "Systems & Technology" = "Systems & Technology", 
                                                                              "Leadership" = "Leadership", "Teamwork" = "Teamwork",
                                                                              "Data Analysis" = "Data Analysis", 
                                                                              "Microsoft Office" = "Microsoft Office"), multiple=TRUE),
                                                                selectInput("fulltime", "Full Time/Part Time:",
                                                                            c("Full Time" = "F",
                                                                              "Part Time" = "P")),
                                                                selectInput("crime", "Safety:",
                                                                            c("High" = '18', 
                                                                              "Medium" = '30', 
                                                                              "Low" = '99', 
                                                                              "All" = 'NA')),
                                                                textInput('zip_input', "Zip:"),
                                                                checkboxGroupInput("map_select", "Select:",
                                                                                   c("Subway" = '1',
                                                                                     "Bus" = '2',
                                                                                     "Cinema" = '3'
                                                                                   )),
                                                                absolutePanel(top=20,left=380,width=1000,height=3,tags$head(tags$style("#NYC_jobs {white-space: nowrap;}")),
                                                                              dataTableOutput("NYC_jobs"),leafletOutput("mymap2",height = 450))
                                                       ),
                                                       tabPanel("Contact",fluidPage(
                                                         sidebarLayout(
                                                           sidebarPanel(h1("Contact Information")),
                                                           mainPanel(
                                                             # only the last output works
                                                             
                                                             hr(),
                                                             h1(("If you are interested in our project, you can contact us.")),
                                                             hr(),
                                                             h6(("Qianqian Wu")),
                                                             h6(("qw2284@columbia.edu")),
                                                             h6(("Feng Su")),
                                                             h6(("fs2658@columbia.edu")),
                                                             h6(("Hui Chiang Tay")),
                                                             h6(("ht2490@columbia.edu")),
                                                             h6(("Shaofu Wang")),
                                                             h6(("sw3294@columbia.edu"))))
                                                       ))))

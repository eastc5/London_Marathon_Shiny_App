#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(tags$style(type="text/css",".recalculating {opacity: 1.0;}"),
       
        sidebarLayout(
          sidebarPanel(
              sliderInput("slidertime", "What is your goal finishing time?",
                          min = as.POSIXlt("1970-01-01 02:00:00",tz="GMT"), 
                          max = as.POSIXlt("1970-01-01 09:00:00",tz="GMT"),
                          value = as.POSIXlt("1970-01-01 04:00:00",tz="GMT"),
                          timeFormat = "%T"),
              selectInput("AgeCat",
                          "Select your age range:",
                          c("All","18-39","40-44","45-49","50-54","55-59","60-64","65-69","70+")),
              selectInput("Sex","Sex:", c("Male" =  "M", "Female" = "W")),
              checkboxInput("showMedianW", "Show/Hide Women's Median", value = FALSE),
              checkboxInput("showMedisnM", "Show/Hide Men's median", value = FALSE)
                    ),
    mainPanel(h1("London Marathon 2016 histogram and quantile calculator"),
                p("Below is an interactive histogram and
                quantile calculator for the 2016 London Marathon.
                It has been designed so that a potential London Marathon 
                runner can see where their predicted/desired finish time
                will place them in the in the field against all runners and those 
                in their age & sex category."),
                h2("Instructions"),
                p("To use the page simply drag the slider
                bar on the left to your desired time, select your age category
                (you can leave this as All to compare yourself against all runners)
                and then select your sex. The histogram below will display 
                the finishing times for men and women in your selected category with the
                black line showing your desired finishing time. Below the histogram in 
                text format are the calculated quantiles against all runners and your 
                selected category for your goal/desired time.
                Additionally, the two buttons on the left display the median (50% quantile)
                for men and women."),
                                   
            plotlyOutput("distPlot"), 
            tags$b(textOutput("quantile")),
                tags$div(class = "header", checked = NA,
                tags$p(),
                tags$br(),
                tags$br(),
                tags$p("The data was collected from the Virgin London Marathon website ",
                tags$a(href = "http://results-2016.virginmoneylondonmarathon.com/2016/","here"),
                "and was collected using the code in the github repo",
                tags$a(href = "https://github.com/eastc5/London_marathon_results_scraper", "here.")),
                tags$p("The code to create this webpage is in the github repo ",
                       tags$a(href = "https://github.com/eastc5/London_Marathon_Shiny_App", "here."))
                    )
                )        
        )))
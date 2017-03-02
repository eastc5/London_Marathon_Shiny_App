library(shiny)
library(plotly)
#load data
Rdata<-read.csv("./data/VLM2016.csv")

Running1<-Rdata
#convert finish time from charater to datetime format
Running1$FINISH<- paste('1970-01-01 ',Running1$FINISH)
Running1$FINISH<-strptime(Running1$FINISH,format = "%Y-%m-%d %H:%M:%S",tz="GMT")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlotly({
    
          # draw the histogram with the specified number of bins
      if (input$AgeCat != "All"){Running1<-Running1[Running1$Category == input$AgeCat,]}
    p <- ggplot(Running1, aes(x=FINISH, fill = Gender))
    p <- p + geom_histogram(binwidth=300,position = "dodge") 
    p <- p + scale_x_datetime(date_labels = "%H:%M:%S", date_breaks = "1 hour")
   
    
    #add goal time
     p <- p + geom_vline(xintercept = as.numeric(input$slidertime),size = 2)
    
    #Add women's median if selected
    if (input$showMedianW){
    p <- p + geom_vline(xintercept = as.numeric(median(Running1$FINISH[Running1$Gender == "W"])), 
                        color = "#00BFC4", size = 2, linetype = "dashed")
    }
    #add men's Median if selected
    if (input$showMedisnM){
     p <- p + geom_vline(xintercept = as.numeric(median(Running1$FINISH[Running1$Gender == "M"])), 
                        color = "#F8766D", size = 2, linetype = "dashed")
    }
     #extract the plotly build so the popup text can be adjusted to remove the date from the time
    g <- plotly_build(p)
    
    #for men[[1]] and women[[2]]
    for (i in 1:2) { 
        
        #extract txt and replace date time with time HH:MM:SS fomat
        b<- g$x$data[[i]]$x %>% as.POSIXlt(origin = "1970-01-01", tz ="GMT") %>% format("%H:%M:%S") 
        
        #recreate the text string
        v<-paste("Count: ",g$x$data[[i]]$y, "<br>","Finish: ",
                 b,"<br>", "Gender: ",g$x$data[[i]]$name)
        
        #sub it back in to the plotly build list
        g$x$data[[i]]$text<-v
        
    }
    #change the popup diplay if the verticle lines to show time
    for (j in 3:length(g$x$data)){
        d<- g$x$data[[j]]$x %>% as.POSIXlt(origin = "1970-01-01", tz = "GMT") %>% format("%H:%M:%S")
        g$x$data[[j]]$text<- d
    }
    
    ggplotly(g)
    
  })
  #create the string to describe the quantile mean(x<=y) for the age and sex categories
   output$quantile <- renderText({
       paste("The time", 
             format(input$slidertime,"%H:%M:%S"),
       "puts you in the top " ,
       round(mean(Running1$FINISH <= as.POSIXlt(input$slidertime, tz ="GMT"))*100),
       "% of all runners",
            "and in the top ",
      if (input$AgeCat != "All")
          {round(mean(Running1$FINISH[Running1$Category == input$AgeCat & 
                                          Running1$Gender == input$Sex] 
                  <= as.POSIXlt(input$slidertime, tz ="GMT"))*100)}
      else {round(mean(Running1$FINISH[Running1$Gender == input$Sex] 
                       <= as.POSIXlt(input$slidertime, tz ="GMT"))*100)},
      
     if (input$AgeCat != "All")
          {paste("% of runners in the ",
       input$AgeCat, 
       "age category for", 
       if(input$Sex == "M"){"men."} else {"women."})
        }else {
            paste("% for",if(input$Sex == "M"){"men."} else {"women."})
        })
       })
  })


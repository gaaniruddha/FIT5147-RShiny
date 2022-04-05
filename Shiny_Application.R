# Question 3 and 5
# Q3 - Creating interactive visualisations using shiny
# Q5 - Merging map into the interactive shiny visualisation 

# Loading the required libraries
library(shiny)
library(datasets)
library(ggplot2)
library(leaflet)
library(shiny)
library(RColorBrewer) 

# Loading the dataset into R
coral_data <- read.csv("assignment-02-data-formated.csv")

# Removing the % symbol 
# Converting the bleaching value into a numeric datatype
coral_data$value <- as.numeric(sub("%", "", as.character(coral_data$value)))

# Converting the longitute and latitude values into numeric datatype
coral_data$longitude <- as.numeric(coral_data$longitude)
coral_data$latitude <- as.numeric(coral_data$latitude)

# Reordering data according to latitude
coral_data$location <- reorder(coral_data$location, coral_data$latitude)

# Creating a palette and assigning colours for different sites
pal <- colorFactor(palette = "Accent", domain = (coral_data$location))

# defing the ui code 
ui <- fluidPage(
  
  titlePanel("Coral Bleaching Percentages over the years in various sites (%)"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      # Defining the input for the coral type 
      selectInput("type", "Coral Type", c( "Blue Corals" = "blue corals","Hard Corals" = "hard corals", "Sea Fans" = "sea fans",
                                           "Sea Pens" = "sea pens","Soft Corals" = "soft corals")),
      
      # Defining the input for the smoother type 
      selectInput( "smoother", "Smoother Type", c( "None" = 'none',"Linear Model" = 'lm',
                                                   "Local Regression" = 'loess', "Generalised Linear Model" = 'glm'))
    ),
   
    # Outputs of ggplot and leaflet 
    mainPanel(
      plotOutput("my_plot"),
      leafletOutput("my_map")
    )
  ),
  
)


# Defining the server code 
server <- function(input, output) {
  
     output$my_plot <- renderPlot({
      
      # Taking only the needed data according to the type selected     
      coral_data <- coral_data[coral_data$coralType == input$type,]
    
      # Plotting using ggplot2 
      ggplot(data = coral_data, aes(x = year, y = value)) +
      geom_point(aes(color = location),size = 3) +
      geom_smooth(method = input$smoother) +
      facet_grid(input$type~location) +  
      ggtitle("Bleaching over the years in various sites") +
      ylab(label = "Bleaching percentages (%)") +
      xlab(label = "Year") + 
      theme(axis.text.x = element_text(angle=90,hjust = 1)) +  
      scale_colour_brewer(palette = "Accent") })
     
      # Plotting using leaflet
      output$my_map <- renderLeaflet({
      
      leaflet(data = coral_data[coral_data$coralType == input$type,]) %>%
          
      addCircleMarkers(
        color = ~pal(location),
        lng = ~ longitude,
        lat = ~ latitude,
        label = ~ as.character(location),
        labelOptions = labelOptions(noHide = T, textsize = "10px")) %>%
          
      addProviderTiles(providers$Esri.NatGeoWorldMap) %>%    
      addLegend(pal = pal,values = ~location, opacity = 1) })
  
}

# Running the shiny application 
shinyApp(ui, server)
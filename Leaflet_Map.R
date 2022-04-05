# Question 4
# Q4 - Creating a map using leaflet

# Importing the required libraries
library(leaflet)

# Reading the dataset into R
coral_data <- read.csv("assignment-02-data-formated.csv")

# Creating datamap in R using leaflet 
leaflet(data = coral_data) %>% addTiles() %>%
  addMarkers(
    lng = ~longitude, 
    lat = ~latitude, 
    label = ~as.character(location),
    popup = ~as.character(location),
    labelOptions = labelOptions(noHide=T,textsize = "10px")
  ) %>%  
  addProviderTiles(providers$Esri.NatGeoWorldMap)
# Question 1 and 2
# Q1 - Reading data into R
# Q2 - Creating Static Visualisations using ggplot2

# Importing the required libraries
require(ggplot2)

# Reading the dataset into R
coral_data <- read.csv("assignment-02-data-formated.csv")

# Removing the percentage symbol 
coral_data$value = gsub("%","",coral_data$value)

# Converting our required data to numeric values
coral_data$value <- as.numeric(coral_data$value)
coral_data$longitude <- as.numeric(coral_data$longitude)
coral_data$latitude <- as.numeric(coral_data$latitude)

# Ordering the sites by latitude
coral_data$location <- reorder(coral_data$location, coral_data$latitude)

# Generating the ggplot2
my_graph <- ggplot(data = coral_data, aes(x=year,y=value))

# Using faceting for each site for the given time period 
# geom_smooth has been used to fit smooth lines to the data to identify trends
g1 <- my_graph + 
  geom_point(aes(colour = coralType)) + 
  facet_grid(coralType~location) +
  labs(x = 'Year', y = 'Bleaching %', title = "Static Visualisation using ggplot2 ") +
  geom_smooth(aes(group = 1),
              method = "lm",
              colour = "black",
              formula = y~poly(x,2),
              size = 0.5) + 
  theme(axis.text.x = element_text(angle=90,hjust = 1))
g1
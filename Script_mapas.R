# Script para criação de mapas do Brasil e dos estados usando shapefiles do IBGE
## Instalando e carregando os pacotes necessários:

# install.packages("maptools")     
# install.packages("spdep")          
# install.packages("cartography")    
# install.packages("tmap")           
# install.packages("leaflet")        
# install.packages("tidyverse")
# install.packages("rgdal")
# install.packages("RColorBrewer") 

library("maptools")     
library("spdep")          
library("cartography")    
library("tmap")           
library("leaflet")        
library("tidyverse")
library("rgdal")
library("RColorBrewer") 
library("readxl")

# Importing shapefile into R ----
shape <- readOGR("shapefile path", stringsAsFactors=FALSE, encoding="UTF-8")

# Importing dataset----

map_data <- read_excel("dataset pathway" )

# Merging shapefile to dataset: 

shape_data <- merge(shape,
                    map_data,
                    by.x = "NAME",
                    by.y = "Location")

# Formatting shape_data----
## Adding coordinates:
proj4string(shape_data) <- CRS("+proj=longlat +datum=WGS84 +no_defs") 

# Encoding the object:

Encoding(shape_data$state_name) <- "UTF-8"


# Generating the map ----
## First, choose your color pallete and if you want a continuous gradient:

map_pallete <- colorBin("Spectral") 

# Interactive map
## Setting the pop ups:

state_popup <- paste0("<strong>Country: </strong>", shape_data$NAME, 
                      "<br><strong>% of DALYs: </strong>", shape_data$Value)
## Plotting the map:

leaflet(data = shape_data) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(fillColor = ~pal(shape_data$Value), 
              fillOpacity = 0.8, 
              color = "#BDBDC3", 
              weight = 1, 
              popup = state_popup) %>%
  addLegend("bottomright", pal = pallete, values = ~shape_data$Value,
            title = "Map",
            opacity = 1)

## Static maps
spplot(shape_data, "Value",col.regions=rev(mypallete),cuts=6)






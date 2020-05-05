library(ggplot2)
library(readr)
library(tidyverse)
library(readxl)
library(dplyr)
library(geojsonR)
library(sf)
library(leaflet)
library(geojsonio)
library(sp)
library(viridis)
library(htmltools)

rm(list = ls())
getwd()

dir()

df= read.csv('Covid19arData - Prov_CABA.csv',encoding = 'UTF-8')
df<- select(df,-c(prov,depto,altas,fuente,fechaact))
df <- df %>% rename(
  'Barrio' = localidad
)
df$Barrio <- df$Barrio %>% toupper()
df$Barrio[df$Barrio=='VILLA PUYERREDON'] <- 'VILLA PUEYRREDON'
df$Barrio[df$Barrio=='VILLA GRAL MITE'] <- 'VILLA GRAL MITRE'

View(df)

unique(df$Barrio) #48 barrios

barrios<- st_read("http://cdn.buenosaires.gob.ar/datosabiertos/datasets/barrios/barrios.geojson")
barrios <- barrios %>% rename(
  'Barrio' = barrio
)
barrios$Barrio <- as.character(barrios$Barrio)
barrios$Barrio[barrios$Barrio=='VILLA GRAL. MITRE'] <- 'VILLA GRAL MITRE'

view(barrios)
dfnew <- merge(barrios,df)
view(dfnew)

barrios_centroides <- sf::st_centroid(barrios)
barrios_xy <- as.data.frame(sf::st_coordinates(barrios_centroides))
barrios_xy = barrios_xy %>% mutate(nombre = barrios$Barrio)


pal <- colorBin("OrRd", domain = dfnew$casos)


  leaflet(data = dfnew) %>%
  addTiles() %>%
  addPolygons(label = ~casos,
              fillColor = ~pal(casos),
              color = "#444444",
              weight = 1,
              smoothFactor = 0.5,
              opacity = 1.0,
              fillOpacity = 0.5,
              highlightOptions = highlightOptions(color = "white",
                                                  weight = 2,
                                                  bringToFront = TRUE)
              )

  #En caso de utilizar ggplot para armar los barrios:
  #esta funcion guarda el mapa como jpg,  quizas nos sea util tenerla a mano
  #ggsave("mapa_barrios_poligonos.jpg", width = 50, height = 20, units = "cm", dpi = 200, limitsize = TRUE) #guardar mapa en jpg 

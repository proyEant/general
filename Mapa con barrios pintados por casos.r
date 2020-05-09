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

#Iniciación
rm(list = ls())
getwd()
dir()

#DF Casos CABA
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

#DF Barrios
barrios <- st_read("http://cdn.buenosaires.gob.ar/datosabiertos/datasets/barrios/barrios.geojson")
barrios <- barrios %>% rename(
  'Barrio' = barrio)
barrios$Barrio <- as.character(barrios$Barrio)
barrios$Barrio[barrios$Barrio=='VILLA GRAL. MITRE'] <- 'VILLA GRAL MITRE'

view(barrios)


#DF Molinetes y limpieza

molinetes <- read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/general/molinetes.csv',stringsAsFactors = F, encoding = 'UTF-8')
molinetes$fecha = as.Date(molinetes$fecha,'%Y-%m-%d')
molinetes$estacion <- toupper(molinetes$estacion)
#molinetes$desde <- substring(molinetes$desde,1,5)
molinetes$desde <- substring(molinetes$desde,1,2)
molinetes$hasta <- substring(molinetes$hasta,1,5)
molinetes <- molinetes %>% select(desde,estacion,fecha,total)
molinetes <- molinetes %>% group_by(estacion,desde,fecha) %>% 
  summarise(total = sum(total))
#molinetes <- molinetes %>% group_by(estacion,desde,fecha) 
molinetes <- molinetes %>% filter(fecha > '2020-02-01' & fecha < '2020-06-01' & total>quantile(molinetes$total,0.75))
molinetes$desde <- as.numeric(molinetes$desde)
?summarise
view(molinetes)

#DF Estaciones Subte

subte <- st_read('http://cdn.buenosaires.gob.ar/datosabiertos/datasets/subte-estaciones/subte_estaciones.geojson')
view(subte)

#DF Hospitales y clínicas privadas
Hospitales<- read.csv('hospitales.csv',encoding = 'UTF-8')
Privados<- read.csv('centros-de-salud-privados.csv',encoding = 'UTF-8')

#Mezcla barrios con casos
dfnew <- merge(barrios,df)
view(dfnew)

#DF con barrios, estaciones de subte y tren, y cantidades en horario matutino y vespertino
view(dfmapa)
dfmapa <- molinetes
dfmapa <- dfmapa %>% 
  mutate('horario'=
           case_when(desde >= 16 & desde <= 20 ~ 'vespertino',
                     desde >= 06 & desde <= 10 ~ 'matutino',
                     TRUE ~ 'borrar')
         )

dfmapa <- dfmapa %>% group_by(estacion,fecha,horario) %>% 
  select(-desde) %>%
  filter(!horario=='borrar') %>%
  summarise(sum(total))
names(dfmapa) = c('ESTACION','fecha','horario','total')
view(dfmapa)


# Mezcla barrios con estaciones
gf

#   Limpieza DF y Environment
Hospitales <- Hospitales %>% select(lat,long,nombre,tipo,telefono,barrio)
view(head(Hospitales))
Privados <- Privados %>% select(lat,long,nombre,telefonos,barrio)
view(head(Privados))

rm(df,barrios)
view(subte1)

#Centroids (en caso de aplicar los casos de los infectados como heatmap en el centro de cada barrio)
#barrios_centroides <- sf::st_centroid(barrios)
#barrios_xy <- as.data.frame(sf::st_coordinates(barrios_centroides))
#barrios_xy = barrios_xy %>% mutate(nombre = barrios$Barrio)

subte_xy <- sf::st_coordinates(subte)
subte_xy <- as.data.frame(subte_xy)
subte <- mutate(subte,'lat'=subte_xy$Y,'lng'=subte_xy$X)

rm(subte_xy)
view(subte)

#Addons para visualización
icon.fa <- makeAwesomeIcon(icon = 'flag', markerColor = 'red', library='fa', iconColor = 'black')
pal <- colorBin("OrRd", domain = dfnew$casos)

#Visualización

  #Concurrencia subte

ggplot(data = molinetes, aes(x=desde,y=estacion,size=total,color=total))+
  geom_jitter()+
  scale_size_continuous(limits=c(2000, 10000), breaks=seq(2000, 10000, by=3000))+
  scale_color_continuous(limits=c(2000, 10000), breaks=seq(2000, 10000, by=3000))+
  guides(color= guide_legend(), size=guide_legend())+
  scale_x_continuous(breaks = seq(5,22,by = 1))

  #Mapa
leaflet(data = dfnew) %>%
  addTiles() %>%
  #addProviderTiles(provider = 'CartoDB.Positron') %>%
  
  addPolygons(label = ~casos,
              fillColor = ~pal(casos),
              color = "#444444",
              weight = 1,
              smoothFactor = 0.5,
              opacity = 1.0,
              fillOpacity = 0.5,
              highlightOptions = highlightOptions(color = "white",
                                                  weight = 2,
                                                  bringToFront = F)
  ) %>% 
  addCircleMarkers(lng = Hospitales$long,
                   lat = Hospitales$lat,
                   clusterOptions = markerClusterOptions(),
                   radius = 18,
                   color = 'blue',
                   label = Hospitales$nombre
  ) %>%
  addCircleMarkers(lng = Privados$long,
                   lat = Privados$lat,
                   clusterOptions = markerClusterOptions(),
                   radius = 12,
                   color = 'red',
                   label = Privados$nombre) %>% 
  addMarkers(lng = subte$lng,
             lat = subte$lat,
             icon = icon.fa,
             label = subte$ESTACION
  )
  

?addMarkers

  #En caso de utilizar ggplot para armar los barrios:
  #esta funcion guarda el mapa como jpg,  quizas nos sea util tenerla a mano
  #ggsave("mapa_barrios_poligonos.jpg", width = 50, height = 20, units = "cm", dpi = 200, limitsize = TRUE) #guardar mapa en jpg#

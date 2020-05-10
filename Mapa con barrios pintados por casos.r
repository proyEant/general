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
molinetes$desde <- as.numeric(molinetes$desde)
molinetes <- molinetes %>% filter(fecha > '2020-02-01' & fecha < '2020-02-29')
molinetes <- molinetes %>% select(desde,estacion,total)
molinetes <- molinetes %>% group_by(estacion,desde) %>% 
  summarise(total = sum(total))
#molinetes <- molinetes %>% group_by(estacion,desde,fecha) 
#molinetes <- molinetes %>% filter(fecha > '2020-02-01' & fecha < '2020-02-29' & desde >= 5 & desde <= 21 & total>quantile(molinetes$total,0.95))
molinetes <- molinetes %>% filter(desde >= 5 & desde <= 21 & total>quantile(molinetes$total,0.85))
molinetes$total <- round(molinetes$total/29)

unique(molinetes$estacion) #66
view(molinetes)
#quantile(molinetes$total,0.83)


# Máximos diarios (promedio mensual) de tránsito de personas en febrero 2020  ## VER SI SIRVE PROMEDIO##
molinetesmapa<- molinetes %>% group_by(estacion) %>% top_n(1,total) %>% arrange(desc(total))

molinetesmapa <- molinetesmapa %>% 
  mutate('horario'=
           case_when(desde >= 16 & desde <= 21 ~ 'vespertino',
                     desde >= 05 & desde <= 12 ~ 'matutino',
                     TRUE ~ 'borrar')
  )

molinetesmapa<- molinetesmapa %>% group_by(estacion,horario) %>% top_n(1,total) %>% arrange(desc(total))
names(molinetesmapa) = c('ESTACION','desde','total','horario')

view(molinetesmapa)



#DF Molinetes 2019 y limpieza
molinetes2019 <- read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/general/molinetes122019.csv',stringsAsFactors = F, encoding = 'UTF-8')
molinetes2019$fecha = as.Date(molinetes2019$fecha,'%Y-%m-%d')
molinetes2019$estacion <- toupper(molinetes2019$estacion)
#molinetes$desde <- substring(molinetes$desde,1,5)
molinetes2019$desde <- substring(molinetes2019$desde,1,2)
molinetes2019 <- molinetes2019 %>% select(desde,estacion,fecha,total)
molinetes2019 <- molinetes2019 %>% group_by(estacion,desde,fecha) %>% 
  summarise(total = sum(total))
#molinetes <- molinetes %>% group_by(estacion,desde,fecha) 
#molinetes2019feb <- molinetes2019 %>% filter(fecha > '2019-02-01' & fecha < '2019-02-29' & total>quantile(molinetes2019$total,0.75))
molinetes2019 <- molinetes2019 %>% filter(fecha > '2019-06-01' & fecha < '2019-06-30' & total>quantile(molinetes2019$total,0.75))
molinetes2019$desde <- as.numeric(molinetes2019$desde)
#molinetes2019feb$desde <- as.numeric(molinetes2019feb$desde)


#DF Estaciones Subte

subte <- st_read('http://cdn.buenosaires.gob.ar/datosabiertos/datasets/subte-estaciones/subte_estaciones.geojson')
view(subte)

#DF Hospitales y clínicas privadas
Hospitales<- read.csv('hospitales.csv',encoding = 'UTF-8')
Privados<- read.csv('centros-de-salud-privados.csv',encoding = 'UTF-8')


#DF Tráfico Vehicular
getwd()
"C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/general"

df_flujoVehic = read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/flujo-vehicular-por-radares-2020.csv', header = T, encoding = 'UTF-8', stringsAsFactors = F)

#suma la cantidad por dispo_nombre por dia
df_mapAccesos= df_flujoVehic %>% 
  group_by(fecha, autopista_nombre, disp_nombre, lat, long) %>% 
  summarise(totalDia= sum(cantidad))

#nrow(df_mapAccesos)

#ahora quiero analizar los 40 dias para atras

today= Sys.Date()
df_accesos_40=data.frame()
df_accesos_40 = df_mapAccesos[ (as.Date(today) - as.Date(df_mapAccesos$fecha))<=40,] #solo me quedo con las filas que cumplen la condicion.



#Mezclas de DF
  #Barrios con casos
dfnew <- merge(barrios,df)
view(dfnew)

  #DF con barrios, estaciones de subte y tren, y cantidades en horario matutino y vespertino
  # 2020
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

  #2019
view(dfmapa)
dfmapa2019 <- molinetes2019
dfmapa2019 <- dfmapa2019 %>% 
  mutate('horario'=
           case_when(desde >= 16 & desde <= 20 ~ 'vespertino',
                     desde >= 06 & desde <= 10 ~ 'matutino',
                     TRUE ~ 'borrar')
  )

dfmapa2019 <- dfmapa2019 %>% group_by(estacion,fecha,horario) %>% 
  select(-desde) %>%
  filter(!horario=='borrar') %>%
  summarise(sum(total))
names(dfmapa2019) = c('ESTACION','fecha','horario','total')
view(dfmapa2019)

# Mezcla barrios con estaciones

view(dfmapa)
view(dfnew)
view(subte)
dfgeneral <- merge(molinetesmapa,subte,by = 'ESTACION')
dfgeneral <- dfgeneral %>% select(c(-ID,-geometry)) %>% 
  arrange(desc(total))
view(dfgeneral)
# dfgeneral <- 
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
  scale_size_continuous(limits=c(750, 7000), breaks=seq(1000, 10000, by=500))+
  scale_color_continuous(limits=c(750, 7000), breaks=seq(1000, 10000, by=500))+
  guides(color= guide_legend(), size=guide_legend())+
  scale_x_continuous(breaks = seq(5,21,by = 1))+
  labs(title = 'Focos de concentración en estaciones',
       x = 'Horarios de ingreso al molinete por día',
       y = 'Estaciones'
  )+
  theme_bw()

ggplot(data = molinetesmapa, aes(x=desde,y=estacion,size=total,color=total))+
  geom_jitter()+
  scale_size_continuous(limits=c(250, 7000), breaks=seq(500, 10000, by=500))+
  scale_color_continuous(limits=c(250, 7000), breaks=seq(500, 10000, by=500))+
  guides(color= guide_legend(), size=guide_legend())+
  scale_x_continuous(breaks = seq(5,21,by = 1))+
  labs(title = 'Focos de concentración en estaciones',
       x = 'Horarios de ingreso al molinete por día',
       y = 'Estaciones'
  )+
  theme_bw()

ggplot(data = molinetes2019, aes(x=desde,y=estacion,size=total/30,color=total/30))+
  geom_jitter()+
  scale_size_continuous(limits=c(50, 700), breaks=seq(50, 600, by=50))+
  scale_color_continuous(limits=c(50, 700), breaks=seq(50, 600, by=50))+
  guides(color= guide_legend(), size=guide_legend())+
  scale_x_continuous(breaks = seq(5,22,by = 1))+
  labs(title = 'Focos de concentración en estaciones',
       x = 'Horarios de ingreso al molinete',
       y = 'Total de personas')


  #Mapa
    # Salud
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

    # Tránsito

barrioslabels <- sprintf(
  "<strong>%s</strong><br/>%g casos",
  dfnew$Barrio, dfnew$casos
) %>% lapply(htmltools::HTML)

estacioneslabels <- sprintf(
  "<strong>Estación: %s</strong><br/>%g casos",
  dfgeneral$ESTACION, dfgeneral$total
) %>% lapply(htmltools::HTML)

leaflet(data = dfnew) %>%
  addTiles() %>%
  #addProviderTiles(provider = 'CartoDB.Positron') %>%
  
  addPolygons(label = barrioslabels,
              fillColor = ~pal(casos),
              color = "#444444",
              weight = 1,
              smoothFactor = 0.5,
              opacity = 1.0,
              fillOpacity = 0.5,
              highlightOptions = highlightOptions(color = "white",
                                                  weight = 2,
                                                  bringToFront = F)
              #popup = paste0('Barrio: ',dfnew$Barrio)
  ) %>% 
  addCircleMarkers(lng = dfgeneral$lng,
             lat = dfgeneral$lat,
             radius = dfgeneral$total/500,
             color = 'red',
             label = estacioneslabels
             #popup = paste0('Estación: ', dfgeneral$ESTACION)
  ) %>% 
  addLegend(pal = pal, values = ~dfnew$casos,opacity = 0.7,position = 'bottomright')
            


#grafica con puntos INTERACTIVO CON PLOTLY.
#muestra por dia los accesos a una autopiesta. los puntos del mismo color son los diferentes accesos
#podemos observar que hay mas cantidad de autos en Dellepiane
#se apagan capas
p=ggplot(df_accesos_40,aes(x = fecha, y = totalDia, color=autopista_nombre, text = paste("Acceso:",disp_nombre)))+
  geom_point()+
  geom_point()+
  scale_color_viridis(discrete = T, option = 'D',
                      direction = 1)+
  theme(axis.text.x = element_text(angle = 90))+
  geom_hline(yintercept = 20000, colour="orange")+
  geom_hline(yintercept = 40000, colour="red")
ggplotly(p)



# Las estaciones de subte y tren deben estar por día, considerando el total de pases por 1 día.

?addMarkers

  #En caso de utilizar ggplot para armar los barrios:
  #esta funcion guarda el mapa como jpg,  quizas nos sea util tenerla a mano
  #ggsave("mapa_barrios_poligonos.jpg", width = 50, height = 20, units = "cm", dpi = 200, limitsize = TRUE) #guardar mapa en jpg#

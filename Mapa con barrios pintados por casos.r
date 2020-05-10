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
library(stringi)

#Iniciación
rm(list = ls())
getwd()
dir()

#DF Casos CABA y nueva fuente con datos 7 de Mayo 2020
df= read.csv('Covid19arData - Prov_CABA.csv',encoding = 'UTF-8')
dfcabanew <- read_xlsx('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/casos_caba_7mayo.xlsx')

df<- select(df,-c(prov,depto,altas,fuente,fechaact))
df <- df %>% rename(
  'Barrio' = localidad
)
df$Barrio <- df$Barrio %>% toupper()
df$Barrio[df$Barrio=='VILLA PUYERREDON'] <- 'VILLA PUEYRREDON'
df$Barrio[df$Barrio=='VILLA GRAL MITE'] <- 'VILLA GRAL MITRE'

dfcabanew$Barrio <- toupper(dfcabanew$Barrio)
names(dfcabanew) = c('Comunas','Barrio','Casos7_5')
dfcabanew <- dfcabanew %>% drop_na() %>% select(-Comunas)
dfcabanew$Barrio <- stri_trans_general(dfcabanew$Barrio,"Latin-ASCII")
dfcabanew$Barrio[dfcabanew$Barrio=='NUNEZ'] <- 'NUÑEZ'
dfcabanew$Barrio[dfcabanew$Barrio=='VILLA GENERAL MITRE'] <- 'VILLA GRAL MITRE'
dfcabanew$Barrio[dfcabanew$Barrio=='MONTSERRAT'] <- 'MONSERRAT'
dfcabanew$Barrio[dfcabanew$Barrio=='LA PATERNAL'] <- 'PATERNAL'
dfcabanew$Barrio[dfcabanew$Barrio=='LA BOCA'] <- 'BOCA'

df$casos7_5 <- merge(df,dfcabanew)
View(df)
view(dfcabanew)
view(dfnew)
unique(df$Barrio) #48 barrios


#DF Barrios (mapeo geográfico)
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

df_flujoVehic2020 = read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/flujo-vehicular-por-radares-2020.csv', header = T, encoding = 'UTF-8', stringsAsFactors = F)
df_flujoVehic2019 = read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/flujo-vehicular-por-radares-2019.csv', header = T, encoding = 'UTF-8', stringsAsFactors = F)

#suma la cantidad por dispo_nombre por dia
df_mapAccesos= df_flujoVehic2020 %>% 
  group_by(fecha, autopista_nombre, disp_nombre, lat, long) %>% 
  summarise(totalDia= sum(cantidad))

#nrow(df_mapAccesos)

#ahora quiero analizar los 40 dias para atras

today= Sys.Date()
df_accesos_40=data.frame()
df_accesos_40 = df_mapAccesos[ (as.Date(today) - as.Date(df_mapAccesos$fecha))<=40,] #solo me quedo con las filas que cumplen la condicion.

#DF Estaciones de Tren
df_trenes= read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/estaciones-de-ferrocarril.csv',encoding = 'UTF-8', stringsAsFactors = F)

view(df_trenes)
df_trenescaba= df_trenes%>%
  select(long,lat,nombre,linea,ramal,barrio,comuna) %>% 
  filter(comuna %in% c('Comuna 14','Comuna 13','Comuna 12', 'Comuna 11', 'Comuna 10', 'Comuna 9','Comuna 8', 'Comuna 7','Comuna 6', 'Comuna 5','Comuna 4', 'Comuna 3','Comuna 2', 'Comuna 1','Comuna 15'))

view(df_trenescaba)


#Mezclas de DF
  #Barrios con casos
dfnew <- merge(barrios,df)
view(dfnew)

  #DF Casos nuevos con DF casos anterior
dfnew<- merge(dfnew,dfcabanew)
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


######## CODIGO MAPA PROMEDIO ACCESO PARA JUNIO 2019 SENTIDO A Y B################

##Armo el data frame por dia. obtengo valor por acceso por dia.


df_accesos2019 = na.omit(df_flujoVehic2019) %>%
  group_by(fecha, autopista_nombre, disp_nombre, seccion_sentido, lat, long) %>% 
  summarise(totalDia= sum(cantidad))

##armo loa data Frame de junio por acceso y promedio por mes

df_sentidoA_junio19 = na.omit(df_accesos2019) %>%
  filter(fecha>='2019-06-01' && fecha<='2019-06-30', seccion_sentido == 'A' ) %>% 
  group_by(autopista_nombre, disp_nombre, seccion_sentido, lat, long) %>% 
  summarise(promedioMes = round(sum(totalDia)/30))

df_sentidoB_junio19 = na.omit(df_accesos2019) %>%
  filter(fecha>='2019-06-01' && fecha<='2019-06-30', seccion_sentido == 'B' ) %>% 
  group_by(autopista_nombre, disp_nombre, seccion_sentido, lat, long) %>% 
  summarise(promedioMes = round(sum(totalDia)/30))


#Addons para visualización
icon.fa <- makeAwesomeIcon(icon = 'flag', markerColor = 'red', library='fa', iconColor = 'black')
pal <- colorBin("OrRd", domain = dfnew$casos)
pal2 <- colorBin("OrRd", domain = dfnew$Casos7_5)
#Visualización

#Iconos
transitoiconos <- iconList(
  tren = makeIcon("trenes.png", 18, 18)
  #subte = makeIcon("danger-24.png", "danger-24@2x.png", 24, 24)
)


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
  dfnew$Barrio, dfnew$Casos7_5
) %>% lapply(htmltools::HTML)

estacioneslabels <- sprintf(
  "<strong>Estación: %s</strong><br/><strong>Horario:</strong> %s<br/><strong>Pasajeros:</strong> %g",
  dfgeneral$ESTACION, dfgeneral$horario, dfgeneral$total
) %>% lapply(htmltools::HTML)

leaflet(data = dfnew) %>%
  addTiles() %>%
  addProviderTiles('CartoDB.Positron') %>% 
  addPolygons(label = barrioslabels,
              fillColor = ~pal2(Casos7_5),
              color = "#444444",
              weight = 1,
              smoothFactor = 0.5,
              opacity = 1.0,
              fillOpacity = 0.5,
              highlightOptions = highlightOptions(color = "white",
                                                  weight = 2,
                                                  bringToFront = F)
              ) %>% 
  addCircleMarkers(lng = dfgeneral$lng,
             lat = dfgeneral$lat,
             radius = dfgeneral$total/500,
             color = 'red',
             label = estacioneslabels
             ) %>% 
  addCircleMarkers(lng = df_sentidoA_junio19$long,
                   lat = df_sentidoA_junio19$lat,
                   clusterOptions = markerClusterOptions(), 
                   popup = paste0("<b>Acceso: </b>",df_sentidoA_junio19$disp_nombre, "<br>",
                                  "<b>Sentido: </b>",df_sentidoA_junio19$seccion_sentido, "<br>",
                                  "<b>Cant: </b>",df_sentidoA_junio19$promedioMes),
                   radius= df_sentidoA_junio19$promedioMes/1000,
                   color = "red",
                   group = "SentidoA") %>%
  
  addCircleMarkers(lng = df_sentidoB_junio19$long,
                   lat = df_sentidoB_junio19$lat,
                   clusterOptions = markerClusterOptions(), 
                   popup = paste0("<b>Acceso: </b>",df_sentidoB_junio19$disp_nombre, "<br>",
                                  "<b>Sentido: </b>",df_sentidoB_junio19$seccion_sentido, "<br>",
                                  "<b>Cant: </b>",df_sentidoB_junio19$promedioMes),
                   radius= df_sentidoB_junio19$promedioMes[1]/1000,
                   color = "blue",
                   group = "SentidoB") %>%
  addMarkers(lng = ~ df_trenescaba$long,
             lat = ~ df_trenescaba$lat,
             icon = ~transitoiconos,
             popup = ~ htmlEscape(paste('Línea:',df_trenescaba$linea,' Estación:',df_trenescaba$nombre))) %>% 
#  addCircles(lng =  ~ df_trenescaba$long,
#             lat = ~ df_trenescaba$lat,
#             color ="purple",
#             radius = 110,
#             weight = 10) %>% 
  
  addLayersControl(
    overlayGroups = c("Autopistas: Acceso a CABA", "Autopistas: Salida de CABA"),
    options = layersControlOptions(collapsed = FALSE)
    ) %>% 

  addLegend(pal = pal2,
            values = ~dfnew$Casos7_5,
            opacity = 0.7,
            position = 'bottomright',
            title = 'Cantidad de casos:'
            )
  
            


# Las estaciones de subte y tren deben estar por día, considerando el total de pases por 1 día.

?addMarkers

  #En caso de utilizar ggplot para armar los barrios:
  #esta funcion guarda el mapa como jpg,  quizas nos sea util tenerla a mano
  #ggsave("mapa_barrios_poligonos.jpg", width = 50, height = 20, units = "cm", dpi = 200, limitsize = TRUE) #guardar mapa en jpg#

#Mapas

#Addons para visualización
TilesBA <- 'https://servicios.usig.buenosaires.gob.ar/mapcache/tms/1.0.0/amba_con_transporte_3857@GoogleMapsCompatible/{z}/{x}/{-y}.png'
pal <- colorBin("OrRd", domain = df$casos)
pal2 <- colorBin("YlOrRd", domain = df$Casos7_5)
pal3 <- colorBin("OrRd", domain = censo10$densidad)

#Iconos
iconos <- iconList(
  tren = makeIcon("trenes.png", 18, 18),
  subte = makeIcon("metro.png", 18, 18),
  farmacias = makeIcon('farmacia.png',16, 16),
  cajeros = makeIcon('atm.png', 16, 16),
  vacunatorios = makeIcon('vacunatorios.png', 15, 15)
)

# Salud (con Vacunatorios y Cajeros)
farmaciaslabels <- sprintf(
  "<strong>Farmacia</strong><br>%s %g<br/>%s",
  df_far$calle, df_far$altura, df_far$CP
) %>% lapply(htmltools::HTML)

leaflet(data = df) %>%
  addTiles() %>%
  addProviderTiles('CartoDB.Positron',
                   group = 'Cartografía Limpia') %>% 
  addPolygons(label = barrioslabels,
              fillColor = ~pal2(Casos7_5),
              color = "#444444",
              weight = 1,
              smoothFactor = 0.5,
              opacity = 1.0,
              fillOpacity = 0.5,
              group = 'Casos por Barrio',
              highlightOptions = highlightOptions(color = "white",
                                                  weight = 2,
                                                  bringToFront = F)
  ) %>% 
  addCircles(lng = Hospitales$long,
             lat = Hospitales$lat,
             #clusterOptions = markerClusterOptions(),
             radius = 600,
             color = 'blue',
             label = Hospitales$nombre,
             group = 'Hospitales'
  ) %>%
  addCircles(lng = Privados$long,
             lat = Privados$lat,
             #clusterOptions = markerClusterOptions(),
             radius = 300,
             color = 'red',
             label = Privados$nombre,
             group = 'Clínicas Privadas'
             ) %>% 
  addCircleMarkers(lng =  ~ df_cajeros$long,
                   lat = ~ df_cajeros$lat,
                   color = 'black',  #"purple",
                   radius = 2,
                   weight = 4,
                   label =paste0(df_cajeros$banco,'. Red: ',df_cajeros$red),
                   group = 'Cajeros'
                   ) %>% 
  addMarkers(lng = ~ df_vacunatorios$long,
             lat = ~ df_vacunatorios$lat,
             label = df_vacunatorios$tipo,
             icon = iconos$vacunatorios,
             group = 'Vacunatorios'
             ) %>% 
  # A las farmacias habría que filtrarlas porque son muchas
  
  addCircleMarkers(lng = ~ df_far$long,
                   lat = ~ df_far$lat,
                   label = farmaciaslabels,
                   #icon = iconos$farmacias,
                   color = 'green',
                   radius = 2,
                   weight = 4,
                   group = 'Farmacias'
                   ) %>% 
  #  addMarkers(lng = df_far$long,
  #             lat = df_far$lat,
  #             icon = iconos$farmacias) %>% 
  addLayersControl(
    overlayGroups = c('Hospitales','Clínicas Privadas','Farmacias','Vacunatorios','Cajeros','Casos por Barrio','Cartografía Limpia'),
    options = layersControlOptions(collapsed = FALSE)
  ) %>% 
  
  addLegend(pal = pal2,
            values = ~df$Casos7_5,
            opacity = 0.7,
            position = 'bottomright',
            title = 'Cantidad de casos:'
            )


# Tránsito

barrioslabels <- sprintf(
  "<strong>%s</strong><br/>%g casos",
  df$Barrio, df$Casos7_5
) %>% lapply(htmltools::HTML)

estacioneslabels <- sprintf(
  "<strong>Estación: %s</strong><br/><strong>Horario:</strong> %s<br/><strong>Pasajeros:</strong> %g",
  dfgeneral$ESTACION, dfgeneral$horario, dfgeneral$total
) %>% lapply(htmltools::HTML)

estacionestrenlabels <- sprintf(
  "<strong>Estación: %s</strong><br/><strong>Línea: </strong>%s<br/><strong>Ramal: </strong>%s",
  df_trenescaba$nombre, df_trenescaba$linea, df_trenescaba$ramal
) %>% lapply(htmltools::HTML)

leaflet(data = df) %>%
  addTiles(urlTemplate = TilesBA) %>% 
  #addProviderTiles('CartoDB.Positron',
  #                 group = 'Cartografía Limpia') %>% 
  addPolygons(label = barrioslabels,
              fillColor = ~pal2(Casos7_5),
              color = "#444444",
              weight = 1,
              smoothFactor = 0.5,
              opacity = 1.0,
              fillOpacity = 0.42,
              group = 'Casos por Barrio',
              highlightOptions = highlightOptions(color = "white",
                                                  weight = 2,
                                                  bringToFront = F)
  ) %>% 
  addCircleMarkers(lng = dfgeneral$lng,
                   lat = dfgeneral$lat,
                   radius = dfgeneral$total/400,
                   color = 'red',
                   icons(iconos$subte),
                   group = 'Estaciones de subte',
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
                   group = "Autopistas: Acceso a CABA") %>%
  
  addCircleMarkers(lng = df_sentidoB_junio19$long,
                   lat = df_sentidoB_junio19$lat,
                   clusterOptions = markerClusterOptions(), 
                   popup = paste0("<b>Acceso: </b>",df_sentidoB_junio19$disp_nombre, "<br>",
                                  "<b>Sentido: </b>",df_sentidoB_junio19$seccion_sentido, "<br>",
                                  "<b>Cant: </b>",df_sentidoB_junio19$promedioMes),
                   radius= df_sentidoB_junio19$promedioMes/1000, #Tenía el [1]
                   color = "blue",
                   group = "Autopistas: Salida de CABA") %>%
  addMarkers(lng = ~ df_trenescaba$long,
             lat = ~ df_trenescaba$lat,
             icon = iconos$tren,
             group = 'Estaciones de tren',
             label = estacionestrenlabels
             #popup = ~ htmlEscape(paste('Línea:',df_trenescaba$linea,' Estación:',df_trenescaba$nombre))) %>% 
             #  addCircles(lng =  ~ df_trenescaba$long,
             #             lat = ~ df_trenescaba$lat,
             #             color ="purple",
             #             radius = 110,
             #             weight = 10) %>% 
  ) %>% 
  addLayersControl(
    overlayGroups = c("Autopistas: Acceso a CABA", "Autopistas: Salida de CABA",'Casos por Barrio','Estaciones de tren','Estaciones de subte'),
    options = layersControlOptions(collapsed = FALSE)
  ) %>% 
  
  addLegend(pal = pal2,
            values = ~df$Casos7_5,
            opacity = 0.7,
            position = 'bottomright',
            title = 'Cantidad de casos:'
  )



# Las estaciones de subte y tren deben estar por día, considerando el total de pases por 1 día.


# Mapa de calor de barrios infectados (no tiene utilidad)

leaflet(data = df) %>%
  addTiles(urlTemplate = TilesBA) %>%
  #addProviderTiles('CartoDB.Positron',
                   #group = 'Cartografía Limpia') %>% 
  addPolygons(label = barrioslabels,
              fillColor = ~pal2(Casos7_5),
              color = "#444444",
              weight = 1,
              smoothFactor = 0.5,
              opacity = 1.0,
              fillOpacity = 0.3,
              group = 'Casos por Barrio',
              highlightOptions = highlightOptions(color = "black",
                                                  weight = 2,
                                                  bringToFront = F)
  ) %>% 
  
  addHeatmap(lng = ~df$lon, 
             lat = ~df$lat, 
             intensity = ~df$Casos7_5,
             blur = 1, 
             max = max(df$Casos7_5)
             #radius = 20
  ) %>% 
  
  addLayersControl(
    overlayGroups = c('Casos por Barrio','Cartografía Limpia'),
    options = layersControlOptions(collapsed = FALSE)
  ) 


# Densidad poblacional (requiere el df limpio sin quitar columnas)

leaflet(data = censo10) %>%
  addTiles(urlTemplate = TilesBA) %>%
  addPolygons(#label =censo10$BARRIO,
    fillColor = ~pal3(densidad),
    color = "#444444",
    weight = 1,
    smoothFactor = 0.5,
    opacity = 1.0,
    fillOpacity = 0.75,
    label = ~densidad,
    #group = 'Casos por Barrio',
    highlightOptions = highlightOptions(color = "white",
                                        weight = 2,
                                        bringToFront = F)) %>% 
  addLegend(pal = pal3,
            values = ~densidad,
            opacity = 0.7,
            position = 'bottomright',
            title = 'Cantidad de habitantes:'
  )


#En caso de utilizar ggplot para armar los barrios:
#esta funcion guarda el mapa como jpg,  quizas nos sea util tenerla a mano
#ggsave("mapa_barrios_poligonos.jpg", width = 50, height = 20, units = "cm", dpi = 200, limitsize = TRUE) #guardar mapa en jpg#
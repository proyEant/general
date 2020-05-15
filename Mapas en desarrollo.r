# Mapa de calor de barrios infectados (no tiene utilidad)

leaflet(data = df) %>%
  addTiles(urlTemplate = TilesBA) %>%
  addProviderTiles('CartoDB.Positron',
                   group = 'Cartografía Limpia') %>% 
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

leaflet(data = densidad_casos) %>%
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
                                        bringToFront = F)
  ) %>% 
  addLegend(pal = pal3,
            values = ~densidad,
            opacity = 0.7,
            position = 'bottomright',
            title = 'Cantidad de habitantes:'
  )



#En caso de utilizar ggplot para armar los barrios:
#esta funcion guarda el mapa como jpg,  quizas nos sea util tenerla a mano
#ggsave("mapa_barrios_poligonos.jpg", width = 50, height = 20, units = "cm", dpi = 200, limitsize = TRUE) #guardar mapa en jpg#
source('https://raw.githubusercontent.com/proyEant/general/master/Iniciacion.r')
source('https://raw.githubusercontent.com/proyEant/general/master/Creacion de DF y limpieza.r')
source('Mapas.r')
#source('Graficas.r') # todavía no está listo


##########SE DEFINEN LOS DATA FRAMES PARA LEVANTAR 

#Levantar csv
getwd()
setwd()

df_flujoVehic2020 = read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/flujo-vehicular-por-radares-2020.csv', header = T, encoding = 'UTF-8', stringsAsFactors = F)
df_flujoVehic2019 = read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/flujo-vehicular-por-radares-2019.csv', header = T, encoding = 'UTF-8', stringsAsFactors = F)


### df para el plotly

######## CODIGO GRAFICO comparando 2020/2019 DESDE 13/3 AL 27/3 ################

#suma la cantidad por dispo_nombre por dia
##2020

df_mapAccesos2020= df_flujoVehic2020 %>% 
  group_by(fecha, autopista_nombre, disp_nombre, lat, long) %>% 
  summarise(totalDia= sum(cantidad))



#TOMO SOLO del 13 al 27 DE MARZO.
df_accesos_marzo2020=data.frame()
df_accesos_marzo2020 = df_mapAccesos2020 %>%
  filter(as.Date(fecha)>='2020-03-13' && as.Date(fecha)<='2020-03-27') #solo me quedo con las filas que cumplen la condicion.




##########df para el mapa


df_ = na.omit(df_flujoVehic2019) %>%
  group_by(fecha, autopista_nombre, disp_nombre, seccion_sentido, lat, long) %>% 
  summarise(totalDia= sum(cantidad))

##armo loa data Frame de junio por acceso y promedio por mes

df_sentidoA_junio = na.omit(df_) %>%
  filter(fecha>='2019-06-01' && fecha<='2019-06-30', seccion_sentido == 'A' ) %>% 
  group_by(autopista_nombre, disp_nombre, seccion_sentido, lat, long) %>% 
  summarise(promedioMes = round(sum(totalDia)/30))

df_sentidoB_junio = na.omit(df_) %>%
  filter(fecha>='2019-06-01' && fecha<='2019-06-30', seccion_sentido == 'B' ) %>% 
  group_by(autopista_nombre, disp_nombre, seccion_sentido, lat, long) %>% 
  summarise(promedioMes = round(sum(totalDia)/30))



##############









#UI

ui<- fluidPage( 
  
  
  h1(img( src='https://images.unsplash.com/photo-1584118624012-df056829fbd0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1000&q=80',
          
          height="30%", 
          width="30%", 
          strong('COVID19 en CABA'), align= "center",
          br() ) ),
  h2("Qué tenes que saber antes de que se levante la Cuarentena.", align="center",
     hr()),
  
  br(),
  
  tabsetPanel(
    tabPanel("Covid19: Analisis",
             br(),
             fluidRow(
               column(2),
               column(8,
                      h3('¿Cómo afectaría la apertura de la cuarentena en ', strong('CABA'), '?', height="30%", width="30%"),
                      tags$br(),
                      tags$div(
                        tags$p('CABA fué declarada bajo aislamiento social, preventivo y obligatorio a partir del día 19 de
                        marzo de 2020, con el propósito de frenar esta pandemia que afecta al mundo entero.
                        Sólo determinados sectores y profesionales habilitados, tienen permitida la libre circulación dentro de
                        la Ciudad Autónoma.
                        Si bien se está aperturando la circulación de modo controlado y bajo ciertos criterios por edades y 
                        franja horaria, hemos realizado un análisis sobre el impacto al liberar el libre transito sobre cada
                        barrio bonaerense.'),
                        
                        tags$br(),
                        tags$p('Nos hemos basado en la siguiente información para recaudar datos:'),
                        tags$ul(
                          tags$li('Casos de infectados por barrio.'),
                          tags$li('Servicios sanitarios disponibles, ya sea hospitales como clínicas privadas.'),
                          tags$li('Servicios farmaceúticos.'),
                          tags$li('Vacunatorios.'),
                          tags$li('Acceso a Cajeros.'),
                          tags$li('Puntos de accesos a la Ciudad Autónoma.'),
                          tags$li('Volumen de pasajeros en subtes.'),
                          tags$li('Volumen vehicular en accesos a autopistas.'),
                          tags$li('Líneas de Trenes.'),
                          
                        ),#cierre ul
                      ),#cierre del div
                      tags$br(),
                      tags$br(),
                      tags$div(
                        
                        img( src='https://images.unsplash.com/photo-1534126874-5f6762c6181b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1000&q=80',
                             height="80%", 
                             width="80%",
                             align= "center",
                             HSPACE=3,
                             VSPACE= 3,
                             align= "right"),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                      ),  
                      
                      
               ),#CIERRA 8
             ),
    ),
    
    tabPanel("Análisis según transporte",
             
             navlistPanel(
               tabPanel("Mapa Circulación por medio de transporte", 
                        tags$br(),
                        tags$h1('Cuáles son los barrios más afectados y su relación con el transporte'),
                        tags$br(),
                        tags$br(),
                        tags$p('En el siguiente mapa te mostramos cuáles son los barrios que tienen más casos confirmados de 
                               COVID19 y su relación con los medios de transporte.'),
                        tags$p('Ahora, teniendo en cuenta esas cifras y a la vez si sumamos la cantidad de circulantes en las
                               zonas aledañas de acceso a los barrios porteños, podemos ver el nivel de circulación que existiría a la 
                               hora de comenzar con la libre circulación.'),
                        tags$p('Se puede observar una clara relación entre la cantidad de pasajeros que circulan (en ascenso al subte) por 
                        las estaciones de mayor caudal, y los barrios con mayor afectación por el COVID-19.
                        Los barrios de Flores, Retiro, Palermo, y Belgrano concentran más del 50% [A COLOCAR DATO CORRECTO] de los casos de 
                        la ciudad de Buenos Aires, siendo 3 de ellos las que poseen cabeceras de 3 líneas de subte (con picos de accesos).
                        A su vez, toda la franja barrial de las líneas A y D (que concentran la mayor circulación de pasajeros) se vio 
                        considerablemente más afectada que el resto de los barrios, esto se explica por la abundante circulación y 
                               aglomeración de personas..'),
                        tags$br(), 
                        tags$p('Se observan que las siguientes zonas serian las mas expuestas:'),
                        tags$ul(
                          tags$li('Barrio de Flores'),
                          tags$li('Barrio de Retiro'),
                          tags$li('Barrio de Palermo'),
                          tags$li('Barrio de Balvanera'),
                          tags$li('Barrio de Belgrano '),
                          tags$li(' '),
                          tags$li(' .'),
                          tags$li(' .'),
                          
                        ),#cierre ul
                        tags$br(),
                        tags$br(),
                        leafletOutput(outputId = 'mapa_t'),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                        tags$br()
               ),
               
               tabPanel("Subte: Estaciones y su concentración por horario", 
                        tags$br(),
                        tags$h1('Cuáles son los barrios más afectados y su relación con el transporte'),
                        tags$br(),
                        tags$br(),
                        tags$p('texto.'),
                        tags$p('texto.'),
                        tags$br(), 
                        tags$p('Se observan que las siguientes zonas serían las más expuestas:'),
                        
                        plotlyOutput(outputId = 'graf_subte'),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                        tags$br()
               ),
               
               
               tabPanel("Accesos: Comparación de circulacion",
                        tags$br(),
                        tags$h1('Cómo se redujo el volumen de circulación.'),
                        tags$br(),
                        tags$br(),
                        tags$p('Realizamos una comparativa según el volumen de circulación proveniente de los diferentes
                          accesos a las autopistas bonaerenses que comunican el conurbano con CABA.
                          Teniendo en cuenta que la cuarentena fué declarada el 19 de Marzo de 2020, tomamos el período
                          del 13 de marzo al 20 de marzo para hacer una observación comparativa del flujo de accesos entre
                          el 2019 y el 2020.'),
                        tags$br(), 
                        tags$p('Se observa como se redujo notablemente a partir del día 20 de marzo de 2020 la cantidad de 
                          circulación dentro de la Ciudad Autónoma.
                          Por otro lado, podemos observar comparando con el mismo peródo del 2019, la diferencia en circulantes
                          que hubiera tenido para las mismas fechas de la muestra.'),
                        tags$br(), 
                        tags$p('Con este dato, queremos dejar en evidencia que al momento que se levante el confinamiento social 
                              obligatorio, cuál podría ser el flujo de circulantes ingresantes a CABA provenientes de los
                              alrededores.'),
                        tags$br(),
                        tags$br(),
                        plotlyOutput(outputId = 'id_grc_2020'),
                        tags$br(),
                        tags$br(),
                        plotlyOutput(outputId = 'id_grc_2019'),
                        tags$br(),
                        tags$br()
                        
                        
               ),
               
               tabPanel("Accesos: Circulación dos primeras semanas de cuarentena",
                        tags$br(),
                        tags$h1('Qué pasó con el flujo de circulación durante las dos primeras semana de confinamiento'),
                        tags$br(),
                        tags$br(),
                        tags$p('En estos gráficos se observa la variación de actividad en las bajadas y subidas de cada acceso 
                               a las autopistas.'),
                        tags$br(), 
                        tags$p('En la gráfica de las bajadas, tanto Lugones como Dellepiane son las que mayor caudal de tráfico
                               cuenta por lo que los barrios donde desemboca la misma son barrios que requerirán particular atención.'),
                        tags$br(),
                        tags$br(),
                        plotlyOutput(outputId = 'id_grc_A'),
                        tags$br(),
                        tags$p('En cambio para las subidas, Cantilo y Dellepiane son las que mayor caudal de tráfico
                               manejan.'),
                        tags$br(),
                        plotlyOutput(outputId = 'id_grc_B'),
                        tags$br(),
                        tags$br()
                        
                        
               )
               
             ),#fin navlistPanel 
             h1(img( src='https://images.unsplash.com/photo-1580094687196-cbc2bdab67e4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1000&q=80',
                     
                     height="30%", 
                     width="30%", 
                     br() ) ),
             
             
    ),#fin tab panel analisis transporte
    
    
    
    tabPanel("Análisis según Servicios",
             
             navlistPanel(
               tabPanel("Mapa de ubicación Servicios", 
                        tags$br(),
                        tags$h1('Cuáles son los barrios más afectados y su relación con los Servicios'),
                        tags$br(),
                        tags$br(),
                        tags$p('Así como para transporte, en el siguiente mapa tenemos visibilidad de los barrios con mayor
                               cantidad de contagiados y los puntos de concentración posibles de personas, tal como son los
                               hospitales, clínicas, farmacias, vacunatorios y cajeros automáticos.'),
                        tags$br(), 
                        tags$p('	Se puede observar que la mayor concentración de casos confirmados se da en las ubicaciones con mayor
                        cantidad de cajeros y farmacias (incluso en proporción). Existen algunas excepciones que se explican por la 
                        movilidad urbana y la densidad poblacional de cada barrio, ya que el microcentro concentra una gran densidad 
                               poblacional solo a efectos de actividad laboral, mientras que esa población se traslada a los barrios 
                               con mayor densidad de hogares.'),
                        tags$br(), 
                        tags$br(),
                        tags$br(),
                        leafletOutput(outputId = 'mapa_s'),
                        tags$br(),
                        tags$br(),
                        tags$br()
               ),
               
               tabPanel("Mapa de barrios más comprometidos",
                        br(),
                        plotOutput(outputId = 'id_mapaC')
               )
             )#fin navlispanel   
             
             
             
    ), # fin tabPanel Analsis servicios
    
    
    
    
    tabPanel("Conclusiones",
             column(2),
             column(8, 
                    tags$br(),
                    tags$h1('Ahora que tenes esta info que pensás?'),
                    tags$br(),
                    tags$br(),
                    tags$p('Repasemos cuáles son los barrios que poseen más casos de infectados confirmados hasta la fecha:'),
                    tags$br(), 
                    tags$ul(
                      tags$li('zona1.'),
                      tags$li('zona2'),
                      tags$li(' '),
                      tags$li(' .'),
                      tags$li(' '),
                      tags$li(' '),
                      tags$li(' .'),
                      tags$li(' .'),
                      
                    ),#cierre ul
                    
                    tags$br(),
                    tags$p('Teniendo en cuenta los focos de concentración de personas según lo estudiado, cuando se libere 
                      completamente la cuarentena, los sectores que tendrán mayor circulación de peatones son:'),
                    tags$br(), 
                    tags$ul(
                      tags$li('zona1.'),
                      tags$li('zona2'),
                      tags$li(' '),
                      tags$li(' .'),
                      tags$li(' '),
                      tags$li(' '),
                      tags$li(' .'),
                      tags$li(' .'),
                    ), #fin ul
                    
                    tags$br(), 
                    tags$br(),
                    tags$p('Por lo que si no tenemos los cuidados necesarios, podrían propagarse los contagios rapidamente y perder todo el trabajo
                      logrado en cuestion de días.'),
                    tags$br(),
                    tags$p('Para evitar esto tenemos algunas sugerencias:'),
                    tags$p('Como individuos, tenemos la obligación de seguir cumpliendo con las recomendaciones del uso de tapa bocas,
                      alcohol en gel, guantes descartables, higienizarte las manos con agua y jabón, limpiar bien lo que uses o 
                      traigas de la calle según recomendaciones.'),
                    tags$p('Como tarea por parte del estado, deberá incrementar el personal de vigilancia para recordar a los circulantes
                      las medidas de distanciamiento social, el uso obligatorio de tapa boca.'),
                    
                    tags$p('Es importante realizar campañas para que las entidades u organizaciones de atención al público brinden los elementos 
                      necesarios para ayudar a las personas con la higiene y los cuidados correspondientes, facilitando el 
                      acceso al alcohol en gel, guantes de latex y en caso de accidente con la mascarilla poder proporcionar 
                      una de emergencia.'),
                    
                    tags$p('En caso de entidades como bancos, clínicas, hospitales y vacunatorios lograr un manejo de distribución 
                      de las personas alternativo. Para esto es importante conocer cuáles son las zonas con menor circulación de personas.'),
                    
                    tags$p('Concientizar a los ciudadanos que la circulación únicamente sea si es necesario, y de tener la posibilidad
                      de elegir, elegir zonas que sean aquellas donde menos concentración haya.'),
                    
                    tags$p('Sabemos Qué accesos son los de mayor caudal, por lo que se debería agilizar los controles pertinentes
                      para el ingreso a CABA, para así no resulten demoras en las autopistas ya que podría ser de utilidad 
                      un flujo más agil ante urgencias.'),
                    tags$br(), 
             ),#fin col8
    ), # fin conclusiones
    
    tabPanel("Recursos",
             tags$br(),
             column(2),
             column(8,
                    tags$p('Se nos ocurrió analizar este tema ya que es una situación nueva y extraordinaria que afecta al mundo
                    entero y nos pareció interesante poder emplear las herramientas que hemos aprendido durante el curso
                    de "Data Analytics".'),
                    tags$br(),
                    
                    img( src='https://drive.google.com/file/d/1Mdb_Rsx70X7vO7Xxj9z59qYM2yElNI79/preview',
                         width="640",
                         height="480"),
                    
                    tags$p('Hemos realizado primeramente una investigación de los Data Sets disponibles que propone el Gobierno
                    de la Ciudad y en base a nuestro interés sobre el COVID19 aplicamos la metodología "Data thinking" para decidir
                    que potencial teníamos en frente.'),
                    tags$p('Luego lo que hicimos fue dividir el proyecto en tareas hacibles,ordenanando las mismas en
                           un tablero de Trello. Una vez identificadas las tareas, se le asignó un responsable a cada una de ellas.'),
                    
                    
                    
                    img( src='https://drive.google.com/file/d/1Mdb_Rsx70X7vO7Xxj9z59qYM2yElNI79',
                         height="80%", 
                         width="80%",
                         align= "center",
                         HSPACE=3,
                         VSPACE= 3,
                         align= "right"),
                    
                    tags$p('Data set que utilizamos:'),
                    tags$ul(
                      tags$li(a('https://data.buenosaires.gob.ar/dataset/centros-salud-privados/archivo/juqdkmgo-461-resource')),
                      tags$li(a('https://data.buenosaires.gob.ar/dataset/hospitales/archivo/juqdkmgo-1191-resource')),
                      tags$li(a('https://data.buenosaires.gob.ar/dataset/farmacias/archivo/juqdkmgo-1101-resource')),
                      tags$li(a('https://data.buenosaires.gob.ar/dataset/flujo-vehicular-por-radares-ausa/archivo/e8a5b66e-ffcd-47a1-a0af-e1caf0f5c8ab')),
                      tags$li(a('https://data.buenosaires.gob.ar/dataset/flujo-vehicular-por-radares-ausa/archivo/66bbccae-d6e0-43f4-b874-dbdece04dfd1')),
                      tags$li(a('https://data.buenosaires.gob.ar/dataset/subte-viajes-molinetes ')),
                      tags$li(a('https://docs.google.com/spreadsheets/d/16-bnsDdmmgtSxdWbVMboIHo5FRuz76DBxsz_BbsEVWA/edit#gid=1627928258')),
                      tags$li(a('https://data.buenosaires.gob.ar/dataset/cajeros-automaticos')),
                      tags$li(a('https://data.buenosaires.gob.ar/dataset/vacunatorios-adultos-mayores')),
                      tags$li(a('https://data.buenosaires.gob.ar/dataset/estaciones-ferrocarril')),
                      
                      
                    ),#cierre ul
                    
                    
                    tags$p('Las librerías que empleamos son las siquientes:'),
                    tags$ul(
                      
                      tags$li('library(shiny)'),
                      tags$li('library(DT)'),
                      tags$li('library(tidyverse)'),
                      tags$li('library(tidytext)'),
                      tags$li('library(wordcloud2)'),
                      tags$li('library(tidytext)'),
                      tags$li('library(wordcloud2)'),
                      tags$li('library(plotly)'),
                      tags$li('library(ggplot2)'),
                      tags$li('library(leaflet)'),
                      tags$li('library(viridis)'),
                      tags$li('library(googledrive)'),
                      
                      
                    ),#cierre ul
                    tags$br(),
                    tags$br(),
                    
                    
                    
             ),# fin column 8  
             
    ), # fin recursos
    
    
    tabPanel("About us",
             br(),
             column(2),
             column(8, 
                    p('Somos alumnos del curso Data Analytics. Nos dedicamos a distintas profesiones y en
                      conjunto hemos trabajado en el análisis de COVID 19 en CABA conjugando nuestras diferentes
                      miradas referente a la situación que atraviesa nuestro  país.
                      les contamos un poco de nosotros:'),
                    tags$br(),
                    tags$div(tags$p(strong('Marina')),
                             tags$p('Analista de Business Intelligence en empresa de E-commerce.'),
                             tags$p( em('"El mundo de los datos me apasiona y me impacta el poder que tienen en la toma de decisiones,
                                    generación de información y conocimiento. En los últimos años, tuve la oportunidad de afrontar 
                                    distintos desafíos que implicaban trabajar en la  manipulación datos y herramientas de BI, por lo 
                                    cual consideré fundamental complementar mis conocimientos con un lenguaje de programación cómo R y
                                    técnicas de análisis de datos".')),
                             tags$br(),
                             tags$p(strong('Sabrina')),
                             tags$p('Analista de Sistemas en una Telco.'),
                             tags$p( em('"Siempre estuve interesada en los datos y hoy en día se convirtieron en una de las 
                                    herramientas mas poderosa para potenciar y sacar provecho ante cualquier objetivo
                                    que uno se plantee. En este ultimo tiempo surgieron distintos frentes para manejo de 
                                    datos, motivo por el cual tomé la iniciativa de iniciarme en Data analytics".')),
                             tags$br(),
                             tags$p(strong('Bruno')),
                             tags$p('Analista de Negocio en empresa de Software.'),
                             tags$p( em('"Mi interés por La tecnología, los números, la estadística, y la inteligencia en datos fue creciendo
                                    a lo largo de mi vida. Descubrir el potencial de trabajar con todo lo anterior me llevó a introducirme
                                    al universo de los datos y su representación para la toma de decisiones y conciencia."')),
                             
                    ),
                    tags$div(tags$p(strong('Nuestra experiencia en el trabajo de COVID19.')),
                             
                             tags$br(),
                             tags$p('El curso nos brindó herramientas para introducirnos en el mundo del 
                                    "Data Analytics" y "R".'),
                             tags$br(),
                             tags$br()
                             
                             
                             
                             
                    )
                    
                    
                    
                    
             )#cierra column8
             
    )#cierra About us
    
  )# cierra tabsetPanel
  
)# ui

server<- function(input, output){
  
  
  ### RENDER PLOTLY  
  
  # GRAFICO, subte       
  output$graf_subte=renderPlotly({
    
  })# fin render plot  
  
  
  # GRAFICO 2020 DESDE 13/3 AL 27/3  
  output$id_grc_2020=renderPlotly({
    
    p <- ggplot(df_accesos_marzo2020, aes(x = fecha, y = totalDia ,color=autopista_nombre, text = paste("Acceso:",disp_nombre))) + 
      geom_point() +
      scale_color_viridis(discrete = T, option = 'D',direction = 1)+
      facet_wrap(~ autopista_nombre)+
      theme(axis.text.x = element_text(angle = 90))+
      geom_hline(yintercept = 40000, colour="orange")+
      geom_hline(yintercept = 70000, colour="red")
    
    fig <- ggplotly(p)
    fig$x$layout$title <- 'Cantidad de Accesos periodo 13/3 a 27/3 del año 2020'
    fig
    
  })# fin render plot
  
  # GRAFICO 2019 DESDE 13/3 AL 27/3  
  output$id_grc_2019=renderPlotly({
    
    
    
  })# fin render plot
  
  
  #GRAFICO 2020 DESDE 13/3 AL 27/3 para sentido A    
  output$id_grc_A=renderPlotly({
    
    
    
  })# fin render plot
  
  #GRAFICO 2020 DESDE 13/3 AL 27/3 para sentido B        
  output$id_grc_B=renderPlotly({
    
    
    
  })# fin render plot
  
  
  
  
  
  #RENDER LEAFLET  
  
  #mapa de transportes  
  output$mapa_t=renderLeaflet({
    mapa_t
    
  })# fin render plot
  
  
  ##mapa de servicios. 
  output$mapa_s=renderLeaflet({
    mapa_s
    
  })# fin render plot
  
  
  
}# fin server.

shinyApp(ui=ui, server=server)


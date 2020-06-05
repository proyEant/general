source('https://raw.githubusercontent.com/proyEant/general/master/Iniciacion.r',encoding = 'UTF-8')
source('https://raw.githubusercontent.com/proyEant/general/master/Creacion de DF y limpieza.r',encoding = 'UTF-8')
source('https://raw.githubusercontent.com/proyEant/general/master/Mapas.r',encoding = 'UTF-8')
source('https://raw.githubusercontent.com/proyEant/general/master/Graficas.r',encoding = 'UTF-8')


#UI

ui<- fluidPage(
  fluidRow(
    setBackgroundColor(
      color = c("#FCFDC7", "#FBE29D"),
      gradient = "linear",
      direction = "bottom"
    ),
    column(2,
           br(),
           br(),
           img(src='https://upload.wikimedia.org/wikipedia/commons/8/82/SARS-CoV-2_without_background.png',
               height="90%", 
               width="90%", 
               align= "left"),
    ),
    column(8,
           br(),
           br(),
           br(),
           br(),
           br(),
           h1(strong('COVID-19 en CABA'),
              align = 'center')
    ),
    column(2,
           img( src='https://github.com/proyEant/general/raw/master/eant.png',
                height='100%', 
                width='100%', 
                align = 'right'),
           img( src='https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/R_logo.svg/724px-R_logo.svg.png',
                height=70, 
                width=70, 
                align = 'right'),
    ),
    
  ), # Cierre fluid
  br(),
  h2("Qué tenes que saber antes de que se levante la Cuarentena.", align="center",
     hr()),
  
  br(),
  
  tabsetPanel(
    tabPanel("Covid19: Análisis",
             br(),
             fluidRow(
               column(2),
               column(8,
                      h3('¿Cómo afectaría la apertura de la cuarentena en ', strong('CABA'), '?', height="30%", width="30%"),
                      tags$br(),
                      tags$div(
                        tags$p('CABA fue declarada bajo aislamiento social, preventivo y obligatorio a partir del día 19 de
                        marzo de 2020, con el propósito de frenar la pandemia conocida como COVID-19 que afecta al mundo entero.
                        Sólo determinados sectores y profesionales habilitados, tienen permitida la libre circulación dentro de
                        la Ciudad Autónoma.'),
                        tags$p('Si bien se está aperturando la circulación de modo controlado y bajo ciertos criterios por edades, terminación de DNI y 
                        franja horaria, hemos realizado un análisis sobre el impacto al liberar el libre tránsito sobre cada
                        barrio porteño.'),
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
               ), #Cierra 8
               column(2), #Cierra 2
             ), #Cierre Fluid 1
             fluidRow(
               column(2),
               column(10,
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
               ), #Cierra 10
             ), #Cierra fluid 2
    ), #Cierra tabpanel
    
    tabPanel("Análisis según transporte",
             
             navlistPanel(
               'Mapa',
               tabPanel("Circulación por Medio de Transporte", 
                        tags$br(),
                        tags$h1('¿Cuáles son los barrios más afectados y su relación con el transporte?'),
                        tags$br(),
                        tags$p('En el siguiente mapa te mostramos cuáles son los barrios que tienen más casos confirmados de 
                               COVID19.'),
                        tags$p('Ahora, teniendo en cuenta esas cifras y si a la vez añadimos información sobre la cantidad de circulantes en las
                               zonas aledañas de acceso a los barrios porteños, tomando los datos sobre tráfico en autopistas, subtes y trenes
                               podemos ver cuál sería el nivel de circulación que  existiría a la hora de levantar la cuarentena completamente.'),
                        tags$br(), 
                        tags$p(strong('Se observan que las siguientes zonas serían las más expuestas:')),
                        tags$ul(
                          tags$li('Las Zonas cercanas a la línea D de Subtes.'),
                          tags$li('La Zona de Retiro. Primeramente por ser una de las zonas que posee más casos de contagio y por otro lado 
                                  por ser cabecera de varias líneas de trenes y subte C.'),
                          tags$li('Zonas por la que atraviesa las principales autopistas, siendo el micro centro el más expuesto ya que es
                                  el nexo de las mismas.'),
                          tags$li('Palermo también es una posible zona para estar en alerta, ya que posee un alto
                                  grado de casos identificados, cruza la línea de tren Mitre, Subte D y autopista Lugones.'),
                          tags$li('La zona de Constitución si bien no se destaca por los casos localizados, claramente concentra
                                  un alto grado de ingresantes provenientes del sur del conurbano bonaerense. No olvidemos la línea C 
                                  que transporta gente hacia cabeceras relevantes.'),
                          tags$li('La zonas de Flores también concentra muchos casos, lo cual tiene relación directa con la cantidad de pasajeros 
                                  que registra el subte, ubicación donde existe una cabecera de la línea A.'),
                          
                        ),#cierre ul
                        tags$br(),
                        tags$br(),
                        leafletOutput(outputId = 'mapa_t', width = "100%", height = 800),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                        tags$br()
               ),
               tabPanel("Densidad de Población", 
                        tags$br(),
                        tags$h1('¿Cuáles son los barrios con mayor concentración de población?'),
                        tags$br(),
                        tags$p('En el siguiente mapa te mostramos cuáles son los barrios que tienen más habitantes por kilómetro cuadrado.'),
                        tags$br(), 

                        tags$ul(
                          tags$li('Las Zonas cercanas a la línea D de Subtes.'),
                          tags$li('La Zona de Retiro.'),
                          tags$li('Barrio de Flores.'),
                          tags$li('La zonas de Flores concentra muchos habitantes por km2, lo cual tiene correlación directa con la cantidad 
                                  de casos de COVID-19 registrados hasta la fecha.'),
                        ),#cierre ul
                        tags$br(),
                        tags$br(),
                        leafletOutput(outputId = 'mapa_d', width = "100%", height = 800),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                        tags$br()
               ),
               'Gráfico Subte',
               tabPanel("Estaciones y su concentración por horario", 
                        tags$br(),
                        tags$h1('¿Cuáles son los focos de concentración de pasajeros más importantes de la red?'),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                        tags$p('En el gráfico de puntos a continuación se pueden visualizar las estaciones de subte que mayor concurrencia
                              tienen y los horarios en que frecuentan la mayor cantidad de pasajeros.'),
                        tags$br(),
                        tags$p('El horario establecido para el análisis es el comprendido entre las 5hs y las 21hs, considerando el día más
                               concurrido de junio de 2019'),
                        tags$br(), 
                        tags$p('Se utilizaron los datos del último mes de junio que se tienen registros para estimar la cantidad de 
                               pasajeros que podrían circular en caso de abrirse la cuarentena en las próximas semanas.'),
                        tags$br(), 
                        tags$p('Esto nos servirá para identificar qué estaciones deben tener mayor presencia y rigurosidad tanto en el 
                               control de salubridad de los pasajeros como en la cartelería informativa para generar conciencia en los 
                               ciudadanos.'),
                        tags$br(), 
                        tags$p('El tamaño de los puntos representa la cantidad de pasajeros por hora en cada estación:'),
                        
                        plotlyOutput(outputId = 'graf_subte_p', width = '100%',height = 800),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                        tags$br()
               ),
               
               'Gráficos Accesos',
               tabPanel("Comparación de Circulacion",
                        tags$br(),
                        tags$h1('¿Cómo se redujo el volumen de circulación desde la cuarentena?'),
                        tags$br(),
                        tags$br(),
                        tags$p('Realizamos una comparativa según el volumen de circulación proveniente de los diferentes
                          accesos a las autopistas bonaerenses que comunican el conurbano con CABA.
                          Teniendo en cuenta que la cuarentena fué declarada el 19 de Marzo de 2020, tomamos el período
                          del 13 de marzo al 27 de marzo para hacer una observación comparativa del flujo de accesos entre
                          el 2019 y el 2020.'),
                        tags$br(), 
                        tags$p('Se observa cómo se redujo notablemente a partir del día 20 de marzo de 2020 la cantidad de 
                          circulación dentro de la Ciudad Autónoma.
                          Por otro lado, podemos observar comparando con el mismo periodo del 2019, la diferencia en circulantes
                          que hubiera tenido para las mismas fechas de la muestra.'),
                        
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
               
               tabPanel("Circulación semana pre y post cuarentena",
                        tags$br(),
                        tags$h1('¿Qué pasó con el flujo de circulación durante la semana anterior y posterior al confinamiento?'),
                        tags$br(),
                        tags$br(),
                        tags$p('En estos gráficos se observa la variación de actividad tanto en sentido hacia CABA como en sentido hacia
                        provincia de cada acceso a las autopistas.'),
                        tags$br(), 
                        tags$p('En la gráfica sentido hacia CABA, tanto Lugones como Dellepiane son las que mayor caudal de tráfico
                               cuenta por lo que los barrios donde desembocan las mismas son barrios que requerirán particular atención.'),
                        tags$br(),
                        tags$br(),
                        plotlyOutput(outputId = 'id_grc_A'),
                        tags$br(),
                        tags$p('En cambio en el gráfico sentido hacia provincia, Cantilo y Dellepiane son las que mayor caudal de tráfico
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
                     br() 
             ) 
             ),
             
    ),#fin tab panel analisis transporte
    
    
    
    tabPanel("Análisis según Servicios",
             fluidRow(
               column(1),
               column(10,
                      tags$br(),
                      tags$h1('¿Cuáles son los barrios más afectados y su relación con los Servicios?'),
                      tags$br(),
                      tags$p('Así como para transporte, en el siguiente mapa tenemos visibilidad de los barrios con mayor
                               cantidad de contagiados y los puntos de concentración posibles de personas, tal como son los
                               hospitales, clínicas, farmacias, vacunatorios y cajeros automáticos.'),
                      tags$br(),
                      tags$p(strong('Analizando los diferentes servicios se observa lo siguiente:')),
                      tags$br(),
                      tags$li('Las clínicas privadas se concentran justamente en los barrios que tienen entre 50 y 150 casos de contagios 
                        - Recoleta, Balvanera, Almagro, Palermo, Caballito y Belgrano- o próximos a barrios cómo Retiro y Flores con más de 
                        200 casos.'),
                      tags$li('En cambio, los Hospitales se concentran mayormente en zona Sur dónde los casos de contagios no son tan elevados, 
                        menos de 50 casos por barrio. También hay concentración de Hospitales, pero en menor medida, en Recoleta y Caballito que 
                        son barrios con número de casos de contagio intermedio.'),
                      tags$li('Los vacunatorios se encuentran distribuidos uniformente a lo largo de toda la Ciudad, sin embargo se observa 
                        mayor concentración en Palermo y Recoleta -contagios moderados- muy cerca de la alta concentración de Clínicas y 
                        Hospitales en dichos barrios.'),
                      tags$li('En cuanto a Farmacias y Cajeros Automáticos - servicios que aglomeran una gran cantidad de personas- se observa 
                        una alta concentración en zona Norte y Centro de la Ciudad dónde se encuentran los barrios con mayores casos de contagios.'), 
                      tags$br(), 
                      tags$br(), 
                      tags$br(),
                      tags$br(),
                      leafletOutput(outputId = 'mapa_s', width = "100%", height = 800),
                      tags$br(),
                      tags$br(),
                      tags$br(),
                      tags$br(),
                      tags$br(),
                      tags$br(),
                      
                      
               ),#CIERRA 8
             ) #fin fluidRow
    ), # fin tabPanel Analsis servicios
    
    tabPanel("Análisis según Casos",
             fluidRow(
               column(1),
               column(10,
                      tags$br(),
                      tags$h1('¿Qué podemos interpretar de los datos sobre los casos?',align = 'center'),
                      tags$br(),
                      tags$p('La cantidad de casos por si sola no nos dice nada, pero revisando los detalles podemos conocer más acerca
                             de lo que nos pueden contar.'),
                      tags$br(),
                      tags$p(strong('Analizando los diferentes casos por sexo, edad, condición y resultado podemos ver lo siguiente:')),
                      tags$br(),
                      tags$br(),
                      tags$li('La mayor cantidad de casos descartados se da en la población menor a 15 años, y la que se encuentra entre
                              los 25 y los 45 años.'),
                      tags$br(),
                      plotlyOutput(outputId = 'graf_confirm_edad_p', width = "85%", height = 680),
                      tags$br(),
                      tags$br(),
                      tags$li('La proporción global de mortalidad se encuentra en torno al 4,5%, pero si nos acercamos más, vemos que cambia
                              fuertemente a lo largo de las edades'),
                      tags$br(),
                      plotOutput(outputId = 'graf_confirm', width = "85%", height = 680),
                      tags$br(),
                      tags$br(),
                      plotOutput(outputId = 'graf_confirm_fallec', width = "85%", height = 680),
                      tags$br(),
                      tags$br(),
                      tags$br(),
                      
               ),#CIERRA 8
             ) #fin fluidRow
    ), # fin tabPanel Analsis Casos
    
    
    tabPanel("Conclusiones",
             column(2),
             column(8, 
                    tags$br(),
                    tags$h1('Ahora que tenes esta info, ¿qué pensás?'),
                    tags$br(),
                    tags$br(),
                    tags$p(strong('Repasemos cuáles son los barrios que poseen más casos de infectados confirmados hasta el 7 de mayo:')),
                    tags$br(), 
                    tags$ul(
                      tags$li('Retiro: 293 casos'),
                      tags$li('Flores: 238 casos'),
                      tags$li('Palermo: 111 casos '),
                      tags$li('Balvanera: 91 casos'),
                      tags$li('Belgrano: 89 casos'),
                      tags$li('Recoleta: 88 casos '),
                      
                    ),#cierre ul
                    
                    tags$br(),
                    tags$p(strong('Teniendo en cuenta los focos de concentración de personas según lo estudiado, cuando se libere 
                      completamente la cuarentena, los sectores que tendrán mayor circulación de peatones son:')),
                    tags$br(), 
                    tags$ul(
                      tags$li('Micro Centro'),
                      tags$li('Retiro'),
                      tags$li('Constitución'),
                      tags$li('Palermo'),
                      tags$li('Belgrano'),
                      tags$li('Recoleta'),
                      
                    ), #fin ul
                    
                    tags$br(), 
                    h4(tags$p('Considerando la cantidad de casos y la cantidad de las personas en circulación, si no tenemos los 
                    cuidados necesarios, podrían propagarse los contagios rápidamente y perder todo el trabajo
                    logrado en cuestion de días.')),
                    tags$br(),
                    tags$p(strong('Para evitar esto tenemos algunas sugerencias:')),
                    tags$p('Como individuos, tenemos la obligación de seguir cumpliendo con las recomendaciones del uso de tapa bocas,
                      alcohol en gel, guantes descartables, higiene de las manos con agua y jabón, limpiar bien lo que uses o 
                      traigas de la calle según recomendaciones.'),
                    tags$p('Como tarea por parte del estado, deberá incrementar el personal de vigilancia para recordar a los circulantes
                      las medidas de distanciamiento social, el uso obligatorio de tapa boca y alcohol en gel.'),
                    
                    tags$p('Es importante realizar campañas para que las entidades u organizaciones de atención al público promuevan el
                      cumplimiento de las medidas de distanciamiento social y brinden los elementos necesarios para ayudar a las personas
                      con la higiene y con los cuidados correspondientes, facilitando el acceso al alcohol en gel, guantes de latex y
                      en caso de algún inconveniente con el tapa boca poder proporcionar uno de emergencia.'),
                    
                    
                    tags$p('Laboralmente el gobierno podría realizar y promover propuestas de jornadas laborales alternativas como trabajo
                      remoto, jornadas partidas, extención de horarios, transporte para trabajadores, entre otros.'),
                    
                    tags$p('En caso de entidades como bancos, clínicas, hospitales y vacunatorios una posible opción podría ser procurar
                    un manejo de distribución de las personas alternativo. Para poder decidir como canalizar la distribución es importante 
                    conocer cuáles son las zonas con mayor cantidad de casos y transeúntes para derivarlos a las de menor circulación de personas.'),
                    
                    tags$p('Concientizar a los ciudadanos que la circulación sea si únicamente es necesario, y de tener la posibilidad
                      de elegir, elegir zonas que sean aquellas donde menos concentración haya.'),
                    
                    tags$p('El transporte público es uno de los focos de mayor contagio, de acuerdo a lo estudiado observamos la cantidad de personas
                      que se movilizan en las distintas líneas, por lo cual sería conveniente analizar la conveniencia de aumentar la frecuencia en 
                      las líneas de subtes que tienen un flujo importante de gente, hacer controles en entradas a estaciones y vagones, asegurando
                      y promoviendo que se cumpla el uso del tapa boca y distanciamiento social.'),
                    
                    tags$p('Sabemos qué accesos son los de mayor caudal, por lo que se debería reforzar el personal de control, además de agilizar 
                      los controles pertinentes para el ingreso a CABA, para así no resulten demoras en las autopistas ya que podría ser de utilidad 
                      un flujo más agil ante urgencias. Estos controles de ingreso deberían seguir siendo justificados.'),
                    tags$br(), 
             ),#fin col8
    ), # fin conclusiones
    
    tabPanel("Recursos",
             tags$br(),
             fluidRow(
               column(2),
               column(8,
                      tags$p('Se nos ocurrió analizar este tema ya que es una situación nueva y extraordinaria que afecta al mundo
                    entero y nos pareció interesante poder emplear las herramientas que hemos aprendido durante el curso
                    de "Data Analytics".'),
                      tags$br(),
                      
                      tags$p('Hemos realizado primeramente una investigación de los Data Sets disponibles que propone el Gobierno
                    de la Ciudad y en base a nuestro interés sobre el COVID19 aplicamos la metodología "Data thinking" para decidir
                    que potencial teníamos en frente.'),
                      tags$br(),
                      tags$p('Una de las herramientas fue "Mural", para organizar los temas que íbamos a tratar:'),
                      tags$br(),
                      img( src='https://github.com/proyEant/general/raw/master/mapaconceptual.png',
                           height="80%", 
                           width="80%",
                           align= "center",
                           HSPACE=3,
                           VSPACE= 3,
                           align= "right"),
                      tags$br(), 
                      tags$p('Luego lo que hicimos fue dividir el proyecto en tareas hacibles,ordenanando las mismas en
                           un tablero de Trello. Una vez identificadas las tareas, se le asignó un responsable a cada una de ellas:'),
                      tags$br(),
                      img( src='https://github.com/proyEant/general/raw/master/trello.png',
                           height="80%", 
                           width="80%",
                           align= "center",
                           HSPACE=3,
                           VSPACE= 3,
                           align= "right"),
                      tags$br(),
                      tags$br(),
                      tags$p('Data sets que utilizamos:'),
                      tags$ul(
                        tags$li(a(href='https://data.buenosaires.gob.ar/dataset/centros-salud-privados/archivo/juqdkmgo-461-resource', "Centros de Salud Privados")),
                        tags$li(a(href='https://data.buenosaires.gob.ar/dataset/hospitales/archivo/juqdkmgo-1191-resource','Hospitales')),
                        tags$li(a(href='https://data.buenosaires.gob.ar/dataset/farmacias/archivo/juqdkmgo-1101-resource','Farmacias')),
                        tags$li(a(href='https://data.buenosaires.gob.ar/dataset/vacunatorios-adultos-mayores','Vacunatorios')),
                        tags$li(a(href='https://data.buenosaires.gob.ar/dataset/flujo-vehicular-por-radares-ausa/archivo/e8a5b66e-ffcd-47a1-a0af-e1caf0f5c8ab','Flujo vehicular radares 2019')),
                        tags$li(a(href='https://data.buenosaires.gob.ar/dataset/flujo-vehicular-por-radares-ausa/archivo/66bbccae-d6e0-43f4-b874-dbdece04dfd1','Flujo vehicular radares 2020')),
                        tags$li(a(href='https://data.buenosaires.gob.ar/dataset/subte-viajes-molinetes/archivo/26b65146-7f9d-4c9c-a162-87ad44806546','Contabilización de pase por molinetes 2019')),
                        tags$li(a(href='https://data.buenosaires.gob.ar/dataset/subte-viajes-molinetes/archivo/a43d8d7e-0e5e-4706-853b-303f567d82d0','Contabilización de pase por molinetes 2020')),
                        tags$li(a(href='https://data.buenosaires.gob.ar/dataset/cajeros-automaticos','Cajeros automáticos')),
                        tags$li(a(href='https://data.buenosaires.gob.ar/dataset/estaciones-ferrocarril','Estaciones ferrocarril')),
                        tags$li(a(href='https://data.buenosaires.gob.ar/dataset/unidades-febriles-de-urgencia','Unidades Febriles de Urgencia')),
                        tags$li(a(href='http://datos.salud.gob.ar/dataset/covid-19-determinaciones-registradas-en-la-republica-argentina','Casos registrados en triage')),
                        tags$li(a(href='https://www.buenosaires.gob.ar/sites/gcaba/files/bes_197_se_20_vf_0.pdf','Reporte de Vigilancia Sanitaria')),
                        
                        
                      ),#cierre ul
                      
               ),# fin column 8  
             ), #Cierre fluid 1
             fluidRow(
               column(2),
               column(3,
                      tags$p('Las librerías que empleamos son las siquientes:'),
                      tags$ul(
                        
                        tags$li('library(shiny)'),
                        tags$li('library(tidyverse)'),
                        tags$li('library(wordcloud2)'),
                        tags$li('library(plotly)'),
                        tags$li('library(ggplot2)'),
                        tags$li('library(leaflet)'),
                        tags$li('library(leaflet.extras)'),
                        tags$li('library(viridis)'),
                        tags$li('library(sp)'),
                        tags$li('library(htmltools)'),
                        tags$li('library(rio)'),
                        tags$li('library(gdata)'),
                        tags$li('library(magrittr)'),
                        tags$li('library(XML)'),
                        tags$li('library(RCurl)'),
                        tags$li('library(stringi)'),
                        tags$li('library(geo)'),
                        tags$li('library(geojsonio)'),
                        tags$li('library(geoJsonR)'),
                        tags$li('library(sf)'),
                        tags$li('library(readxl)'),
                        tags$li('library(readr)'),
                        tags$li('library(shinyWidgets)'),
                        tags$li('library(colorspace)'),
                        tags$li('library(treemapify)'),
                        tags$br(),
                        tags$br(),
                        tags$br(),
                        
                      ),#cierre ul
               ), #Cierre 3
               column(6,
                      tags$br(),
                      tags$br(),
                      img( src='https://agrippadataconsulting.com/blog/content/images/2019/01/r-packages-hexagons.png',
                           height="80%", 
                           width="80%",
                           align= "center",
                           HSPACE=4,
                           VSPACE= 3,
                      ),
               ) #Cierre 6
             ), #Cierre fluid 2
             
    ), # fin recursos
    
    
    tabPanel("Nosotros",
             br(),
             column(2),
             column(8, 
                    p('Somos alumnos del curso Data Analytics. Nos dedicamos a distintas profesiones y en
                      conjunto hemos trabajado en el análisis de COVID 19 en CABA conjugando nuestras diferentes
                      miradas referente a la situación que atraviesa nuestro  país.'),
                    tags$br(),
                    p('Les contamos un poco de nosotros:'),
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
                             tags$br(),
                             tags$br(),
                    ),
                    tags$div(tags$p(strong('Nuestra experiencia en el trabajo de COVID19.')),
                             tags$br(),
                             tags$p('El curso nos brindó herramientas para introducirnos en el mundo de 
                                    "Data Analytics" y "R". Nos dió la base para pensar: Qué preguntas queremos responder, cómo limpiar y curar 
                                    los datos, Cuáles son los gráficos y mapas más adecuados para este trabajo y Obtener conclusiones.'),     
                             tags$p('Con esa base, hemos además investigado nuevas herramientas y posibilidades que aplicamos al proyecto como 
                                    por ejemplo mapas interactivos, levantar archivos en formato excel, acceso a google drive, googlesheets, etc.'),
                             tags$br(),
                             tags$p('En el transcurso del trabajo se nos presentaron muchas dificultades para modelar, integrar y reproducir 
                                    los distintos datasets con los gráficos y entre las distintas plataformas de repositorios en la nube.'),
                             tags$p('A pesar de lo anterior, logramos avanzar resolviendo todos los imprevistos generando una aplicación de
                                    visualización en Shiny funcional, con la información que teníamos como objetivo representar y en la disposición deseada.'),
                             tags$br(),
                    ),
                    
                    
             )#cierra column8
             
    )#cierra About us
    
  )# cierra tabsetPanel
  
)# ui

server<- function(input, output){
  
  
  ### RENDER PLOTLY Y GGPLOT 
  
  # GRAFICO, subte       
  output$graf_subte_p=renderPlotly({
    
    graf_subte_p
    
  })# fin render plot  
  
  
  # GRAFICO 2020 DESDE 13/3 AL 27/3  
  output$id_grc_2020=renderPlotly({
    
    traf_mar_20_p
    
  })# fin render plot
  
  # GRAFICO 2019 DESDE 13/3 AL 27/3  
  output$id_grc_2019=renderPlotly({
    
    traf_mar_19_p
    
  })# fin render plot
  
  
  #GRAFICO 2020 DESDE 13/3 AL 27/3 para sentido A    
  output$id_grc_A=renderPlotly({
    
    traf_mar20_sentidoA_p
    
  })# fin render plot
  
  #GRAFICO 2020 DESDE 13/3 AL 27/3 para sentido B        
  output$id_grc_B=renderPlotly({
    
    traf_mar20_sentidoB_p
    
  })# fin render plot
  
  #Gráfico de proporciones fallecidos 
  output$graf_confirm_fallec = renderPlot({
    
    graf_confirm_fallec
    
  })# fin render plot
  
  #Gráfico de proporciones confirmados 
  output$graf_confirm = renderPlot({
    
    graf_confirm
    
  })# fin render plot
  
  #Gráfico de confirmados vs descartados por edad 
  output$graf_confirm_edad_p = renderPlotly({
    
    graf_confirm_edad_p
    
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
  
  #mapa de transportes  
  output$mapa_d=renderLeaflet({
    mapa_d
    
  })# fin render plot
  
}# fin server.

shinyApp(ui=ui, server=server)

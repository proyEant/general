####DF Casos CABA y nueva fuente con datos 7 y 28 de Mayo 2020 (principal DF)####

df <-Leer_gDrive("https://drive.google.com/open?id=1i1APIKryoLNlJzdZuLjAacZ1jV4cvh3j",sep=",")

df<- select(df,-c(prov,depto,altas,fuente,fechaact))
df <- df %>% rename(
  'Barrio' = localidad
)
df$Barrio <- df$Barrio %>% toupper()
df$Barrio[df$Barrio=='VILLA PUYERREDON'] <- 'VILLA PUEYRREDON'
df$Barrio[df$Barrio=='VILLA GRAL MITE'] <- 'VILLA GRAL MITRE'

view(df)

dfcabanew <- read.csv('https://docs.google.com/spreadsheets/d/e/2PACX-1vR6ypAY36GnF5KZgwEYPkid2IDoF69eW3aBfmUyTCq_8y-8IfDB5p6ts2DFG-nP7w/pub?output=csv',stringsAsFactors = F,header = T,encoding = 'UTF-8')
#view(dfcabanew)

#Se limpia el df y acomoda para futuro merge
dfcabanew$Barrio <- toupper(dfcabanew$Barrio)
dfcabanew <- dfcabanew %>% filter(!Casos == max(Casos)) %>%
  select(-Comunas)
names(dfcabanew) = c('Barrio','Casos7_5')
dfcabanew$Barrio <- stri_trans_general(dfcabanew$Barrio,"Latin-ASCII")
dfcabanew$Barrio[dfcabanew$Barrio=='NUNEZ'] <- 'NUÑEZ'
dfcabanew$Barrio[dfcabanew$Barrio=='VILLA GENERAL MITRE'] <- 'VILLA GRAL MITRE'
dfcabanew$Barrio[dfcabanew$Barrio=='MONTSERRAT'] <- 'MONSERRAT'
dfcabanew$Barrio[dfcabanew$Barrio=='LA PATERNAL'] <- 'PATERNAL'
dfcabanew$Barrio[dfcabanew$Barrio=='LA BOCA'] <- 'BOCA'

#view(dfcabanew)

dfcabanew285 <- read.csv('https://docs.google.com/spreadsheets/d/e/2PACX-1vT_vYdaJvb361Zm5MQSF2jppA9sgZb-1ClP9i1Fi4RpBWNt2agssN7EtDfQwOcKQw/pub?output=csv',stringsAsFactors = F,header = T,encoding = 'UTF-8')
#view(dfcabanew285)

#Se limpia el df y acomoda para futuro merge
dfcabanew285$Barrio <- toupper(dfcabanew285$Barrio)
dfcabanew285 <- dfcabanew285 %>% filter(!Casos == max(Casos)) %>%
  select(-Comunas)
names(dfcabanew285) = c('Barrio','Casos28_5')
dfcabanew285$Barrio <- stri_trans_general(dfcabanew285$Barrio,"Latin-ASCII")
dfcabanew285$Barrio[dfcabanew285$Barrio=='NUNEZ'] <- 'NUÑEZ'
dfcabanew285$Barrio[dfcabanew285$Barrio=='VILLA GENERAL MITRE'] <- 'VILLA GRAL MITRE'
dfcabanew285$Barrio[dfcabanew285$Barrio=='MONTSERRAT'] <- 'MONSERRAT'
dfcabanew285$Barrio[dfcabanew285$Barrio=='LA PATERNAL'] <- 'PATERNAL'
dfcabanew285$Barrio[dfcabanew285$Barrio=='LA BOCA'] <- 'BOCA'
#view(dfcabanew285)

# Merge Casos nuevos con DF casos anterior

df <- merge(df,dfcabanew)
df <- merge(df,dfcabanew285)
#View(df)
rm(dfcabanew,dfcabanew285)


####DF Fallecidos ####

df_fallecidos <- read.csv('https://docs.google.com/spreadsheets/d/e/2PACX-1vTum1u-ykKxIqkzkG5Hz-rsAiBIYUGFx3qBsRWAiesJo8JjJrUKzv_Kg8z1S07Wdw/pub?output=csv',stringsAsFactors = F,header = T)
df_fallecidos$fecha <- as.Date(df_fallecidos$fecha,'%d/%m/%Y')
df_fallecidos=df_fallecidos %>% 
  filter(provincia=="CABA")


#view(df_fallecidos)



####DF Censo Radial 2010 - Densidad ####

densidad <- st_read("http://cdn.buenosaires.gob.ar/datosabiertos/datasets/informacion-censal-por-radio/CABA_rc.geojson")
densidad$BARRIO <- as.character(densidad$BARRIO)
#densidad$geometry <- NULL
densidad <- densidad %>% select(-c(RADIO_ID,HOGARES_NBI))
densidad <- densidad %>% rename(
  'Barrio' = BARRIO)

#densidad <- densidad %>% group_by(Barrio) %>% 
#  summarise(Poblacion = sum(POBLACION), Area_km2 = sum(AREA_KM2), Viviendas = sum(VIVIENDAS))
densidad$Densidad_pob <- round(densidad$POBLACION/densidad$AREA_KM2)
densidad$Prom_viv <- densidad$POBLACION/densidad$VIVIENDAS
#densidad <- merge(densidad,df)
#densidad <- cbind(densidad[1:7],'casos7_5' = densidad$Casos7_5)
#densidad$Densidad_casos <- round(densidad$casos7_5/densidad$Area_km2) #Tengo demasiados sectores por barrio para considerar los casos
#view(densidad)


####DF Barrios (mapeo geográfico) ####
barrios <- st_read("http://cdn.buenosaires.gob.ar/datosabiertos/datasets/barrios/barrios.geojson")
barrios <- barrios %>% rename(
  'Barrio' = barrio)
barrios$Barrio <- as.character(barrios$Barrio)
barrios$Barrio[barrios$Barrio=='VILLA GRAL. MITRE'] <- 'VILLA GRAL MITRE'

#view(barrios)


# Merge Barrios con casos
df <- merge(barrios,df)
rm(barrios)

#view(df)

#unique(df$Barrio) #48 barrios


####DF Estaciones Subte ####

subte <- st_read('http://cdn.buenosaires.gob.ar/datosabiertos/datasets/subte-estaciones/subte_estaciones.geojson')

subte_xy <- sf::st_coordinates(subte)
subte_xy <- as.data.frame(subte_xy)
subte <- mutate(subte,'lat'=subte_xy$Y,'lng'=subte_xy$X)

rm(subte_xy)
#view(subte)

#### DF Farmacias ####

df_far <-Leer_gDrive("https://drive.google.com/open?id=1mAwOj_HMrz-d37pH4GU-YMPyoPdN2Y8o",sep=",")
df_far <- df_far %>% select(calle_nombre,calle_altura,lat,long,barrio,comuna,codigo_postal_argentino)
df_far$barrio <- toupper(df_far$barrio)
names(df_far) = c('calle','altura','lat','long','Barrio','comuna','CP')
#view(df_far)

#df_far <- read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/farmacias.csv',stringsAsFactors = F, encoding = 'UTF-8')

####DF Vacunatorios ####

df_vacunatorios <-Leer_gDrive("https://drive.google.com/open?id=1wh4swah6h-Y9rik2yJ7g8DcBkEsqU9X1",sep=",")
#df_vacunatorios= read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/vacunatorios-adultos-mayores.csv',encoding = 'UTF-8', stringsAsFactors = F)
#view(df_vacunatorios)


####DF Molinetes y limpieza #MOLINETES Y MOLINETES122019 se deben descargar manualmente del Gdrive. ####

# Enlace de gDrive = "https://drive.google.com/open?id=1fYluNN84P2mFcFGGLY3GI70utm-90Ie7"


subte_feb20 <- read.csv(paste0(getwd(),'/molinetes.csv'),stringsAsFactors = F, encoding = 'UTF-8')
subte_feb20$fecha = as.Date(subte_feb20$fecha,'%Y-%m-%d')
subte_feb20$estacion <- toupper(subte_feb20$estacion)
subte_feb20$desde <- substring(subte_feb20$desde,1,2)
subte_feb20$desde <- as.numeric(subte_feb20$desde)
subte_feb20 <- subte_feb20 %>% filter(fecha > '2020-02-01' & fecha < '2020-02-29')

# Datos para gráfica de pasajeros # Sobre año 2020

subte_gen_feb20 <- subte_feb20
subte_gen_feb20 <- subte_gen_feb20 %>% select(desde,estacion,fecha,linea,total) %>% 
  filter (desde >= 5 & desde <= 21 & total > quantile(total,0.8) # & fecha == '2020-02-11' 
          ) %>% 
  group_by()
names(subte_gen_feb20) = c('desde','ESTACION','fecha','linea','total')

filt_top_15 <- subte_gen_feb20 %>% group_by(ESTACION,desde) %>% 
  summarise('total' = sum(total)) %>% 
  group_by(ESTACION) %>% 
  top_n(1,total) %>% 
  arrange(desc(total)) %>% 
  head(15) %>% 
  select(ESTACION)

subte_gen_feb20 <- subte_gen_feb20 %>% filter(ESTACION %in% filt_top_15$ESTACION & fecha == '2020-02-11') %>% 
  group_by(desde,ESTACION,fecha) %>% 
  summarise('total'=sum(total))
rm(filt_top_15)


#view(subte_gen_feb20)

# Se verifica que el 11 de febrero se da el pico de tránsito. Se considera esa fecha para los picos por estación (2020).
#subte_gen_feb20 %>% group_by(fecha) %>% 
#  summarise('total'=sum(total)) %>% 
#  arrange(desc(total)) 

#view(subte_gen_feb20 %>% filter(ESTACION=='CONSTITUCION'))

#summary(subte_gen_feb20)

# Máximos diarios de tránsito de personas en febrero 2020 (ejecutar luego de datos para gráfica de pasajeros)
subte_feb20 <- subte_feb20 %>% select(desde,estacion,total,fecha) %>%
  group_by(estacion,desde,fecha) %>%
  summarise(total = sum(total)) %>%
  filter(desde >= 5 & desde <= 21)
subte_feb20$dia <- weekdays(subte_feb20$fecha)
subte_feb20$fecha <- NULL
subte_feb20 <- subte_feb20 %>% group_by(estacion,desde,dia) %>% 
  top_n(1,c(total))
subte_feb20 <- subte_feb20 %>% 
  mutate('horario'=
           case_when(desde >= 16 & desde <= 21 ~ 'vespertino',
                     desde >= 05 & desde <= 12 ~ 'matutino',
                     TRUE ~ 'borrar')
         )
subte_feb20$desde <- NULL
subte_feb20<- subte_feb20 %>% group_by(estacion,horario,dia) %>% top_n(1,total) %>% arrange(desc(total))
names(subte_feb20) = c('ESTACION','total','dia','horario')
subte_feb20 <- subte_feb20 %>% filter(!horario == 'borrar') %>% 
  group_by(ESTACION) %>%
  top_n(1,total)

#view(subte_feb20 %>%   arrange(desc(total)))
#view(dfgeneral)

  # Filtrado para que queden 30 estaciones top
filt_top_30 <- subte_feb20 %>% group_by(ESTACION,dia,horario) %>% 
  summarise('total' = sum(total)) %>% 
  group_by(ESTACION) %>% 
  top_n(1,total) %>% 
  arrange(desc(total)) %>% 
  head(30) %>% 
  select(ESTACION)
  # Se filtran las top 30 estaciones para no sobrecargar el mapa
subte_feb20 <- subte_feb20 %>% filter(ESTACION %in% filt_top_30$ESTACION) %>% 
  group_by(ESTACION,dia,horario) %>% 
  summarise('total'=sum(total)) %>% 
  arrange(desc(total))
rm(filt_top_30)

# DF Final para mapa de tránsito

subte_feb20 <- merge(subte,subte_feb20,by='ESTACION')
subte_feb20 <- subte_feb20%>% select(ESTACION,'horario'=horario,LINEA,lat,lng,dia,'total'=total) %>% 
  arrange(desc(total))
#view(subte_feb20)


####DF Molinetes Junio 2019 y limpieza (Para evaluar el impacto de liberación de cuarentena) ####
# Datos para gráfica de pasajeros # Sobre año 2019 [Top estaciones con mayor caudal de pasajeros]

#gDrive <- ("https://drive.google.com/open?id=1j2AqTcKnuHyFXBTlSx9okk9S9vVhSOpK")

subte_gen_jun19 <- read.csv(paste0(getwd(),'/molinetes122019.csv'),stringsAsFactors = F, encoding = 'UTF-8')

subte_gen_jun19$fecha = as.Date(subte_gen_jun19$fecha,'%Y-%m-%d')
subte_gen_jun19$estacion <- toupper(subte_gen_jun19$estacion)
subte_gen_jun19$desde <- substring(subte_gen_jun19$desde,1,2)
subte_gen_jun19$desde <- as.numeric(subte_gen_jun19$desde)
subte_gen_jun19 <- subte_gen_jun19 %>% select(desde,estacion,fecha,linea,total) %>% 
  filter (desde >= 5 & desde <= 21 & total > quantile(total,0.8) & fecha > '2019-06-01' & fecha < '2019-06-30' 
  ) %>% 
  group_by()
names(subte_gen_jun19) = c('desde','ESTACION','fecha','linea','total')

  #Se filtra el top 15 de estaciones
filt_top_15 <- subte_gen_jun19 %>% group_by(ESTACION,desde) %>% 
  summarise('total' = sum(total)) %>% 
  group_by(ESTACION) %>% 
  top_n(1,total) %>% 
  arrange(desc(total)) %>% 
  head(15) %>% 
  select(ESTACION)

subte_gen_jun19 <- subte_gen_jun19 %>% filter(ESTACION %in% filt_top_15$ESTACION & fecha == '2019-06-11') %>% 
  group_by(desde,ESTACION,fecha) %>% 
  summarise('total'=sum(total))
rm(filt_top_15)
#view(subte_gen_jun19 %>% filter(ESTACION=='FEDERICO LACROZE'))
#view(subte_gen_jun19)


####DF Hospitales y clínicas privadas ####

Hospitales0 <- getURL("https://raw.githubusercontent.com/proyEant/general/master/hospitales.csv")
Hospitales <- read.csv(text = Hospitales0,stringsAsFactors = F,encoding = 'UTF-8',header = T)
Hospitales$long <- as.numeric(Hospitales$long)
Hospitales <- Hospitales %>%  drop_na()
# En caso de error en importación, se puede descargar el archivo del repositorio que sigue,y abrirlo.
#Hospitales <-Leer_gDrive("https://drive.google.com/open?id=1x4IXhXYM7XGy2hkBjFjZ2cVa2iTvvvMR",sep=",") #Este no está funcionando porque lo mal-decodifica google spreadsheets primero
#Hospitales <- read.csv('hospitales.csv',encoding = 'UTF-8')
rm(Hospitales0)
Hospitales <- Hospitales %>% select(barrio, lat, long, nombre, comuna, calle_nombre, telefono,calle_altura, tipo_espec) %>% 
  filter(!tipo_espec %in% c('SALUD MENTAL','MED. FISICA/REHABILITACION'))
#view(head(Hospitales))

Privados <-Leer_gDrive("https://drive.google.com/open?id=1OJ9QLniLAG5h1WIntOI5wlBlCrALt3ku",sep=",")
#Privados<- read.csv('centros-de-salud-privados.csv',encoding = 'UTF-8')
Privados <- Privados %>% select(lat,long,nombre,telefonos,barrio)
#view(head(Privados))


####DF Estaciones de Tren####

df_trenes <-Leer_gDrive("https://drive.google.com/open?id=1hLyWAf7wnJ5lCb3X5NdAUmiknU4eS30G",sep=",")
#df_trenes= read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/estaciones-de-ferrocarril.csv',encoding = 'UTF-8', stringsAsFactors = F)

df_trenescaba= df_trenes%>%
  select(long,lat,nombre,linea,ramal,barrio,comuna) %>% 
  filter(comuna %in% c('Comuna 14','Comuna 13','Comuna 12', 'Comuna 11', 'Comuna 10', 'Comuna 9','Comuna 8', 'Comuna 7','Comuna 6', 'Comuna 5','Comuna 4', 'Comuna 3','Comuna 2', 'Comuna 1','Comuna 15'))

#view(df_trenescaba)
rm(df_trenes)

####DF Cajeros Automáticos ####

df_cajeros <-Leer_gDrive("https://drive.google.com/open?id=1FmxmqqSNHmCWG4la8c0SqgMIHKkwGbwM",sep=",")
#df_cajeros= read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/cajeros-automaticos.csv',encoding = 'UTF-8', stringsAsFactors = F)
df_cajeros <- df_cajeros %>% select(banco,red,lat,long,ubicacion,barrio)
df_cajeros <- df_cajeros %>% rename(
  'Barrio' = barrio)

#view(df_cajeros)


####DF Cajeros Unidades Febriles de Urgencia - UFU ####

df_ufu <- read.csv('https://docs.google.com/spreadsheets/d/e/2PACX-1vRvZQS3PllDmhkzsTmEUWrOPesTGjRsAexH4fOVgR-eIJEacOwqd28SWI3sckRmrw4WQ6e6D4QELNSA/pub?output=csv',encoding = 'UTF-8', stringsAsFactors = F)
df_ufu <- df_ufu %>% rename(
  'Barrio' = barrio)
df_ufu$long <- as.numeric(df_ufu$long)
df_ufu$lat <- as.numeric(df_ufu$lat)
#view(df_ufu)


####DF Tráfico Vehicular ####

df_flujoVehic2020 <-Leer_gDrive("https://drive.google.com/open?id=18k_T6sHYIBLwjHq9MCeqPhuNvpXaAy-m",sep=",")
df_flujoVehic2019 <-Leer_gDrive("https://drive.google.com/open?id=1864w0n2-CAGUOLnJExPmYVZPXNY0RGD7",sep=",")


#suma la cantidad por dispo_nombre por dia
df_mapAccesos= df_flujoVehic2020 %>% 
  group_by(fecha, autopista_nombre, disp_nombre, lat, long) %>% 
  summarise(totalDia= sum(cantidad))

#nrow(df_mapAccesos)

#ahora quiero analizar los 40 dias para atras

today= Sys.Date()
df_accesos_40=data.frame()
df_accesos_40 = df_mapAccesos[ (as.Date(today) - as.Date(df_mapAccesos$fecha))<=40,] #solo me quedo con las filas que cumplen la condicion.


#### CODIGO MAPA PROMEDIO ACCESO PARA JUNIO 2019 SENTIDO A Y B######

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



#### CODIGO GRAFICO comparando 2020/2019 DESDE 13/3 AL 27/3 ######

#suma la cantidad por dispo_nombre por dia
##2020

df_mapAccesos2020= df_flujoVehic2020 %>% 
  group_by(fecha, autopista_nombre, disp_nombre, seccion_sentido,lat, long) %>% 
  summarise(totalDia= sum(cantidad))

##lo mismo para 2019

df_mapAccesos2019= df_flujoVehic2019 %>% 
  group_by(fecha, autopista_nombre, disp_nombre, seccion_sentido,lat, long) %>% 
  summarise(totalDia= sum(cantidad))


#TOMO SOLO del 13 al 27 DE MARZO.
df_accesos_marzo2020 <- data.frame()
df_accesos_marzo2020 <- df_mapAccesos2020 %>%
  filter(as.Date(fecha)>='2020-03-13' && as.Date(fecha)<='2020-03-27') #solo me quedo con las filas que cumplen la condicion.

##2019 tomo mismas fechas de marzo que df_accesos_marzo2020

df_accesos_marzo_2019 <- data.frame()
df_accesos_marzo_2019 <- df_mapAccesos2019 %>% 
  filter( as.character((as.Date(fecha) + 366)) %in% c(unique(df_accesos_marzo2020$fecha)))

#TOMO SOLO del 13 al 27 DE MARZO sentidoA.
sentidoA=data.frame()
sentidoA = df_mapAccesos2020 %>%
  filter(as.Date(fecha)>='2020-03-13' && as.Date(fecha)<='2020-03-27', seccion_sentido == 'A') #solo me quedo con las filas que cumplen la condicion.
#view(sentidoA)
#TOMO SOLO del 13 al 27 DE MARZO sentidoB.
sentidoB=data.frame()
sentidoB = df_mapAccesos2020 %>%
  filter(as.Date(fecha)>='2020-03-13' && as.Date(fecha)<='2020-03-27', seccion_sentido == 'B') #solo me quedo con las filas que cumplen la condicion.


#### DF Unidades Febriles ####
u_febriles <- read.csv('ufus.csv',encoding = 'UTF-8',header = T,stringsAsFactors = F)
u_febriles$barrio <- toupper(u_febriles$barrio)
names(u_febriles) = c('lng','lat','nombre','direccion','Barrio','comuna')
view(u_febriles)


#### DF Cantidad Triage #### Para gráfico
cant_triage <- read.csv('BOTI-Cantidad_contactos_hicieron_triage.csv')
cant_triage$fecha <- as.Date(cant_triage$fecha,'%Y-%m-%d')
cant_triage <- cant_triage %>% group_by(fecha) %>% 
  summarise(cantidad = sum(triage_cantidad))
#View(cant_triage)

#### DF Casos actualizados. Datos del GCBA ####

casos <- read.csv('https://raw.githubusercontent.com/SistemasMapache/Covid19arData/master/datosAbiertosOficiales/covid19casos.csv',encoding = 'UTF-8',header = T,stringsAsFactors = F)
casos0 <- casos %>% filter(provincia_residencia=='CABA') %>% 
  select(clasificacion_resumen,sexo,edad,asistencia_respiratoria_mecanica,origen_financiamiento,fallecido)
rm(casos)
#view(casos0)

casos50 <- casos0 %>% filter(clasificacion_resumen == 'Descartado'|clasificacion_resumen == 'Confirmado') %>% 
  group_by(clasificacion_resumen,sexo,edad,fallecido) %>% 
  select(-c(asistencia_respiratoria_mecanica,origen_financiamiento)) %>% 
  count()
#view(casos50)

casos52 <- casos0 %>%
  mutate(edad =case_when(
    edad < 20 ~ 'Menor de 20 años',
    edad >= 20 & edad <35~ 'De 20 a 35 años',
    edad >= 35 & edad <50~ 'De 35 a 50 años',
    edad >= 50 & edad <65~ 'De 50 a 65 años',
    edad >= 65 & edad <75~ 'De 65 a 75 años',
    edad >= 75 & edad <90~ 'De 75 a 90 años',
    edad >= 90 ~ 'Mayor de 90 años',
    TRUE ~ 'NA'
  )
  )
casos52 <- casos52 %>%
  ungroup() %>% 
  mutate(sexo =case_when(
    sexo == 'F' ~ 'Femenino',
    sexo == 'M' ~ 'Masculino',
    sexo == 'NR' ~ 'NR',
    TRUE ~ 'NA'
  )
  )
casos53 <-casos52
casos52 <- casos52 %>% filter(clasificacion_resumen == 'Confirmado' & fallecido=='NO') # Casos 52 trabaja con los confirmados y no fallecidos
casos52 <- casos52 %>% group_by(sexo,edad) %>% 
  summarise(tot = n())
casos52$propglob <-casos52$tot/(sum(casos52$tot)+sum(casos53$tot)) #Proporción de contagiados
casos52 <- casos52 %>% filter(tot > 5)


casos53 <- casos53 %>% filter(clasificacion_resumen == 'Confirmado' & fallecido=='SI') # Casos 52 trabaja con los confirmados y fallecidos
casos53 <- casos53 %>% group_by(sexo,edad) %>% 
  summarise(tot = n())
casos53$propglob <-casos53$tot/(sum(casos52$tot)+sum(casos53$tot))
casos53 <- casos53 %>% filter(tot > 1)


# Full join y dentro de el hacer el %
casos54 <- full_join(casos53,casos52,by = c('sexo','edad'))
#View(casos54)
casos54$prop_fall <- round(casos54$tot.x/(casos54$tot.y+casos54$tot.x),4) 
casos54$label.x <- paste0(casos54$tot.x,' fallecimientos',',\n',casos54$prop_fall*100,'% de los confirmados')
casos54$label.y <- paste0('Total: ',casos54$tot.y,' confirmados',',\n',round(casos54$propglob.y*100,2),'% del total')
casos54 <- casos54 %>% replace(is.na(.), 0)
#view(casos54)

rm(casos0,casos51,casos52,casos53)

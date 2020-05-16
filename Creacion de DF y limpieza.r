#DF Casos CABA y nueva fuente con datos 7 de Mayo 2020 (principal DF)

df <-Leer_gDrive("https://drive.google.com/open?id=1i1APIKryoLNlJzdZuLjAacZ1jV4cvh3j",sep=",")
#df= read.csv('Covid19arData - Prov_CABA.csv',encoding = 'UTF-8')

df<- select(df,-c(prov,depto,altas,fuente,fechaact))
df <- df %>% rename(
  'Barrio' = localidad
)
df$Barrio <- df$Barrio %>% toupper()
df$Barrio[df$Barrio=='VILLA PUYERREDON'] <- 'VILLA PUEYRREDON'
df$Barrio[df$Barrio=='VILLA GRAL MITE'] <- 'VILLA GRAL MITRE'

#view(df)

drive_download("casos_caba_7mayo.xlsx",overwrite = TRUE)
dfcabanew<-read_xlsx('casos_caba_7mayo.xlsx')
#dfcabanew <- read_xlsx('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/casos_caba_7mayo.xlsx')
#view(dfcabanew)

#Se limpia el df y acomoda para futuro merge

dfcabanew$Barrio <- toupper(dfcabanew$Barrio)
names(dfcabanew) = c('Comunas','Barrio','Casos7_5')
dfcabanew <- dfcabanew %>% drop_na() %>% select(-Comunas)

dfcabanew$Barrio <- stri_trans_general(dfcabanew$Barrio,"Latin-ASCII")
dfcabanew$Barrio[dfcabanew$Barrio=='NUNEZ'] <- 'NUÑEZ'
dfcabanew$Barrio[dfcabanew$Barrio=='VILLA GENERAL MITRE'] <- 'VILLA GRAL MITRE'
dfcabanew$Barrio[dfcabanew$Barrio=='MONTSERRAT'] <- 'MONSERRAT'
dfcabanew$Barrio[dfcabanew$Barrio=='LA PATERNAL'] <- 'PATERNAL'
dfcabanew$Barrio[dfcabanew$Barrio=='LA BOCA'] <- 'BOCA'
#view(dfcabanew)

# Merge Casos nuevos con DF casos anterior

df <- merge(df,dfcabanew)
#View(df)
rm(dfcabanew)

#DF Fallecidos

drive_download("Fallecidos.xlsx",overwrite = TRUE)
df_fallecidos<-read_xlsx('Fallecidos.xlsx')

#df_fallecidos <- read_xlsx('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/Fallecidos.xlsx')
df_fallecidos=df_fallecidos %>% 
  filter(provincia=="CABA")

#view(df_fallecidos)


#DF Censo Radial 2010 - Densidad

densidad_casos <- st_read("http://cdn.buenosaires.gob.ar/datosabiertos/datasets/informacion-censal-por-radio/CABA_rc.geojson")
densidad_casos$BARRIO <- as.character(densidad_casos$BARRIO)
densidad_casos$geometry <- NULL
densidad_casos <- densidad_casos %>% select(-c(RADIO_ID,HOGARES_NBI))
densidad_casos <- densidad_casos %>% rename(
  'Barrio' = BARRIO)
densidad_casos <- densidad_casos %>% group_by(Barrio) %>% 
  summarise(Poblacion = sum(POBLACION), Area_km2 = sum(AREA_KM2), Viviendas = sum(VIVIENDAS))
densidad_casos$Densidad_pob <- round(densidad_casos$Poblacion/densidad_casos$Area_km2)
densidad_casos$Prom_viv <- densidad_casos$Poblacion/densidad_casos$Viviendas
densidad_casos <- merge(densidad_casos,df)
densidad_casos <- cbind(densidad_casos[1:7],'casos7_5' = densidad_casos$Casos7_5)
densidad_casos$Densidad_casos <- round(densidad_casos$casos7_5/densidad_casos$Area_km2)
#view(densidad_casos)


#DF Barrios (mapeo geográfico)
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

# DF Fallecidos CABA (Falta)

#df_fallecidos <- read_xlsx('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/Fallecidos.xlsx')


#DF Estaciones Subte

subte <- st_read('http://cdn.buenosaires.gob.ar/datosabiertos/datasets/subte-estaciones/subte_estaciones.geojson')

subte_xy <- sf::st_coordinates(subte)
subte_xy <- as.data.frame(subte_xy)
subte <- mutate(subte,'lat'=subte_xy$Y,'lng'=subte_xy$X)

rm(subte_xy)
#view(subte)

# DF Farmacias

df_far <-Leer_gDrive("https://drive.google.com/open?id=1mAwOj_HMrz-d37pH4GU-YMPyoPdN2Y8o",sep=",")
df_far <- df_far %>% select(calle_nombre,calle_altura,lat,long,barrio,comuna,codigo_postal_argentino)
df_far$barrio <- toupper(df_far$barrio)
names(df_far) = c('calle','altura','lat','long','Barrio','comuna','CP')
#view(df_far)

#df_far <- read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/farmacias.csv',stringsAsFactors = F, encoding = 'UTF-8')

#DF Vacunatorios

df_vacunatorios <-Leer_gDrive("https://drive.google.com/open?id=1wh4swah6h-Y9rik2yJ7g8DcBkEsqU9X1",sep=",")
#df_vacunatorios= read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/vacunatorios-adultos-mayores.csv',encoding = 'UTF-8', stringsAsFactors = F)
#view(df_vacunatorios)


#DF Molinetes y limpieza #MOLINETES Y MOLINETES122019 se deben descargar manualmente el Gdrive.

# Enlace de gDrive = "https://drive.google.com/open?id=1fYluNN84P2mFcFGGLY3GI70utm-90Ie7"
#drive_download("molinetes.csv",overwrite = TRUE)
#subte_feb20<-read.csv('molinetes.csv',stringsAsFactors = F, encoding = 'UTF-8')

subte_feb20 <- read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/general/molinetes.csv',stringsAsFactors = F, encoding = 'UTF-8')
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

subte_gen_feb20 <- subte_gen_feb20 %>% filter(ESTACION %in% filt_top_15$ESTACION) %>% 
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


#DF Molinetes Junio 2019 y limpieza (Para evaluar el impacto de liberación de cuarentena)
# Datos para gráfica de pasajeros # Sobre año 2019 [Top estaciones con mayor caudal de pasajeros]

#subte_gen_jun19 <-Leer_gDrive("https://drive.google.com/open?id=1j2AqTcKnuHyFXBTlSx9okk9S9vVhSOpK",sep=",")
subte_gen_jun19 <- read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/general/molinetes122019.csv',stringsAsFactors = F, encoding = 'UTF-8')

#drive_download("molinetes122019.csv",overwrite = TRUE)
#subte_gen_jun19<-read.csv('molinetes122019.csv',stringsAsFactors = F, encoding = 'UTF-8')

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

subte_gen_jun19 <- subte_gen_jun19 %>% filter(ESTACION %in% filt_top_15$ESTACION) %>% 
  group_by(desde,ESTACION,fecha) %>% 
  summarise('total'=sum(total))
rm(filt_top_15)

#view(subte_gen_jun19)



#DF Hospitales y clínicas privadas

#Hospitales <-Leer_gDrive("https://drive.google.com/open?id=1x4IXhXYM7XGy2hkBjFjZ2cVa2iTvvvMR",sep=",") #Este no está funcionando porque lo mal-decodifica google spreadsheets primero

Hospitales0 <- getURL("https://raw.githubusercontent.com/proyEant/general/master/hospitales.csv")
Hospitales <- read.csv(text = Hospitales0,stringsAsFactors = F,encoding = 'UTF-8')

rm(Hospitales0)

#Hospitales<- read.csv('hospitales.csv',encoding = 'UTF-8')

Hospitales <- Hospitales %>% select(barrio, lat, long, nombre, comuna, calle_nombre, telefono,calle_altura, tipo_espec) %>% 
  filter(!tipo_espec %in% c('SALUD MENTAL','MED. FISICA/REHABILITACION'))
#view(head(Hospitales))
Privados <-Leer_gDrive("https://drive.google.com/open?id=1OJ9QLniLAG5h1WIntOI5wlBlCrALt3ku",sep=",")
#Privados<- read.csv('centros-de-salud-privados.csv',encoding = 'UTF-8')
Privados <- Privados %>% select(lat,long,nombre,telefonos,barrio)
#view(head(Privados))


#DF Estaciones de Tren

df_trenes <-Leer_gDrive("https://drive.google.com/open?id=1hLyWAf7wnJ5lCb3X5NdAUmiknU4eS30G",sep=",")
#df_trenes= read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/estaciones-de-ferrocarril.csv',encoding = 'UTF-8', stringsAsFactors = F)

df_trenescaba= df_trenes%>%
  select(long,lat,nombre,linea,ramal,barrio,comuna) %>% 
  filter(comuna %in% c('Comuna 14','Comuna 13','Comuna 12', 'Comuna 11', 'Comuna 10', 'Comuna 9','Comuna 8', 'Comuna 7','Comuna 6', 'Comuna 5','Comuna 4', 'Comuna 3','Comuna 2', 'Comuna 1','Comuna 15'))

#view(df_trenescaba)
rm(df_trenes)

#DF Cajeros Automáticos

df_cajeros <-Leer_gDrive("https://drive.google.com/open?id=1FmxmqqSNHmCWG4la8c0SqgMIHKkwGbwM",sep=",")
#df_cajeros= read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/cajeros-automaticos.csv',encoding = 'UTF-8', stringsAsFactors = F)
df_cajeros <- df_cajeros %>% select(banco,red,lat,long,ubicacion,barrio)
df_cajeros <- df_cajeros %>% rename(
  'Barrio' = barrio)


#view(df_cajeros)



#DF Tráfico Vehicular

df_flujoVehic2020 <-Leer_gDrive("https://drive.google.com/open?id=18k_T6sHYIBLwjHq9MCeqPhuNvpXaAy-m",sep=",")
df_flujoVehic2019 <-Leer_gDrive("https://drive.google.com/open?id=1864w0n2-CAGUOLnJExPmYVZPXNY0RGD7",sep=",")

#df_flujoVehic2020 = read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/flujo-vehicular-por-radares-2020.csv', header = T, encoding = 'UTF-8', stringsAsFactors = F)
#df_flujoVehic2019 = read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/flujo-vehicular-por-radares-2019.csv', header = T, encoding = 'UTF-8', stringsAsFactors = F)

#suma la cantidad por dispo_nombre por dia
df_mapAccesos= df_flujoVehic2020 %>% 
  group_by(fecha, autopista_nombre, disp_nombre, lat, long) %>% 
  summarise(totalDia= sum(cantidad))

#nrow(df_mapAccesos)

#ahora quiero analizar los 40 dias para atras

today= Sys.Date()
df_accesos_40=data.frame()
df_accesos_40 = df_mapAccesos[ (as.Date(today) - as.Date(df_mapAccesos$fecha))<=40,] #solo me quedo con las filas que cumplen la condicion.


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


# Armado de DF con densidad de casos por barrio

#view(df)
#DF Casos CABA y nueva fuente con datos 7 de Mayo 2020
df= read.csv('Covid19arData - Prov_CABA.csv',encoding = 'UTF-8')
view(df)
dfcabanew <- read_xlsx('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/casos_caba_7mayo.xlsx')
view(dfcabanew)
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

#DF Barrios (mapeo geográfico)
barrios <- st_read("http://cdn.buenosaires.gob.ar/datosabiertos/datasets/barrios/barrios.geojson")
barrios <- barrios %>% rename(
  'Barrio' = barrio)
barrios$Barrio <- as.character(barrios$Barrio)
barrios$Barrio[barrios$Barrio=='VILLA GRAL. MITRE'] <- 'VILLA GRAL MITRE'

view(barrios)

## Merge y Limpieza

# Merge Casos nuevos con DF casos anterior

df <- merge(df,dfcabanew)
View(df)
rm(dfcabanew)

# Merge Barrios con casos
df <- merge(barrios,df)
view(df)

unique(df$Barrio) #48 barrios

# DF Fallecidos CABA (Falta)

#df_fallecidos <- read_xlsx('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/Fallecidos.xlsx')

# DF Farmacias

df_far <- read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/farmacias.csv',stringsAsFactors = F, encoding = 'UTF-8')

df_far <- df_far %>% select(calle_nombre,calle_altura,lat,long,barrio,comuna,codigo_postal_argentino)
df_far$barrio <- toupper(df_far$barrio)
names(df_far) = c('calle','altura','lat','long','Barrio','comuna','CP')
view(df_far)

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
#molinetes <- molinetes %>% filter(fecha > '2020-02-01' & fecha < '2020-02-29' & desde >= 5 & desde <= 21 & total>quantile(molinetes$total,0.95))
molinetes <- molinetes %>% filter(desde >= 5 & desde <= 21 & total>quantile(molinetes$total,0.85))
molinetes$total <- round(molinetes$total/29)

unique(molinetes$estacion) #66
view(molinetes)


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
molinetesmapa <- molinetesmapa %>% filter(!horario == 'borrar')
view(molinetesmapa)



#DF Molinetes 2019 y limpieza (Para evaluar el impacto de liberación de cuarentena)
molinetes2019 <- read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/general/molinetes122019.csv',stringsAsFactors = F, encoding = 'UTF-8')
molinetes2019$fecha = as.Date(molinetes2019$fecha,'%Y-%m-%d')
molinetes2019$estacion <- toupper(molinetes2019$estacion)
molinetes2019$desde <- substring(molinetes2019$desde,1,2)
molinetes2019 <- molinetes2019 %>% select(desde,estacion,fecha,total)
molinetes2019 <- molinetes2019 %>% group_by(estacion,desde,fecha) %>% 
  summarise(total = sum(total))
molinetes2019 <- molinetes2019 %>% filter(fecha > '2019-06-01' & fecha < '2019-06-30' & total>quantile(molinetes2019$total,0.85))
molinetes2019$desde <- as.numeric(molinetes2019$desde)
#molinetes2019feb$desde <- as.numeric(molinetes2019feb$desde)
view(molinetes2019)

#DF Estaciones Subte

subte <- st_read('http://cdn.buenosaires.gob.ar/datosabiertos/datasets/subte-estaciones/subte_estaciones.geojson')
view(subte)

#DF Hospitales y clínicas privadas
Hospitales<- read.csv('hospitales.csv',encoding = 'UTF-8')
Hospitales <- Hospitales %>% select(barrio, lat, long, nombre, comuna, calle_nombre, telefono,calle_altura, tipo_espec) %>% 
  filter(!tipo_espec %in% c('SALUD MENTAL','MED. FISICA/REHABILITACION'))
view(head(Hospitales))
Privados<- read.csv('centros-de-salud-privados.csv',encoding = 'UTF-8')
Privados <- Privados %>% select(lat,long,nombre,telefonos,barrio)
view(head(Privados))


#DF Estaciones de Tren
df_trenes= read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/estaciones-de-ferrocarril.csv',encoding = 'UTF-8', stringsAsFactors = F)

df_trenescaba= df_trenes%>%
  select(long,lat,nombre,linea,ramal,barrio,comuna) %>% 
  filter(comuna %in% c('Comuna 14','Comuna 13','Comuna 12', 'Comuna 11', 'Comuna 10', 'Comuna 9','Comuna 8', 'Comuna 7','Comuna 6', 'Comuna 5','Comuna 4', 'Comuna 3','Comuna 2', 'Comuna 1','Comuna 15'))

view(df_trenescaba)
rm(df_trenes)

#DF Cajeros Automáticos

df_cajeros= read.csv('C:/Users/Bruno/Documents/Bruno/Emprender/Formacion/EANT - Data Analytics/Proyecto Final/Datos/cajeros-automaticos.csv',encoding = 'UTF-8', stringsAsFactors = F)
df_cajeros <- df_cajeros %>% select(banco,red,lat,long,ubicacion,barrio)
df_cajeros <- df_cajeros %>% rename(
  'Barrio' = barrio)

addCircles(lng =  ~ df_cajeros$long,
           lat = ~ df_cajeros$lat,
           color ="purple",
           radius = 35,
           weight = 6)

view(df_cajeros)


# Merge DF con barrios, estaciones de subte y tren, y cantidades en horario matutino y vespertino
# 2020

dfmapa <- molinetes
dfmapa <- dfmapa %>% 
  mutate('horario'=
           case_when(desde >= 16 & desde <= 20 ~ 'vespertino',
                     desde >= 06 & desde <= 10 ~ 'matutino',
                     TRUE ~ 'borrar')
  )
view(dfmapa)
dfmapa <- dfmapa %>% group_by(estacion,horario) %>% 
  select(-desde) %>%
  filter(!horario=='borrar') %>%
  summarise(sum(total))
names(dfmapa) = c('estacion','horario','total')
dfmapa <- dfmapa %>% arrange(desc(total))
names(dfmapa) = c('ESTACION','horario','total')

view(dfmapa)
rm(molinetes)

#DF Tráfico Vehicular

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


#Mezclas de DF

#2019  # Revisar, no quedó agrupado
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

view(molinetesmapa)
view(dfmapa)
view(subte)
dfgeneral <- merge(molinetesmapa,subte,by = 'ESTACION')
dfgeneral <- dfgeneral %>% select(c(-ID,-geometry)) %>% 
  arrange(desc(total))
view(dfgeneral)


#   Limpieza DF y Environment

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
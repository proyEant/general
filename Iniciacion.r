library(ggplot2)
library(readr)
library(tidyverse)
library(readxl)
library(dplyr)
library(geojsonR)
library(sf)
library(leaflet)
library(leaflet.extras)
library(geojsonio)
library(sp)
library(viridis)
library(htmltools)
library(stringi)
library(RCurl)
library(googledrive)
library(plotly)
library(purrr)
library(gsheet)


#Iniciación
rm(list = ls())
getwd()
#GDrive <- 'https://drive.google.com/drive/folders/1iOd0UZsg8tqMql9wgUt9Mnxwg6XBZ1jN?usp=sharing'
TilesBA <- 'https://servicios.usig.buenosaires.gob.ar/mapcache/tms/1.0.0/amba_con_transporte_3857@GoogleMapsCompatible/{z}/{x}/{-y}.png'
dir()

# Función para leer archivos de Google Drive
Leer_gDrive<-function(link_drive,sep=",",dec=".") {
  require(data.table)
  id<-strsplit(link_drive,"id=")[[1]][2]
  return(fread(sprintf("https://docs.google.com/uc?id=%s&export=download", id),
               sep=sep,dec=dec,encoding = 'UTF-8',stringsAsFactors = F,integer64 = "character"))
}

# Puede requerir autenticación
#      googledrive::drive_auth()
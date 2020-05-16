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
library(googlesheets)
library(shiny)


#Iniciación
rm(list = ls())
getwd()
  
  #gDrive
#Google Drive <- 'https://drive.google.com/drive/folders/1iOd0UZsg8tqMql9wgUt9Mnxwg6XBZ1jN?usp=sharing'


# Función para leer archivos de Google Drive
Leer_gDrive<-function(link_drive,sep=",",dec=".") {
  require(data.table)
  id<-strsplit(link_drive,"id=")[[1]][2]
  return(fread(sprintf("https://docs.google.com/uc?id=%s&export=download", id),
               sep=sep,dec=dec,encoding = 'UTF-8',stringsAsFactors = F,integer64 = "character",header = T))
}

# Puede requerir autenticación
#      googledrive::drive_auth()
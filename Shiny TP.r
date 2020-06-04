rm(list=ls())

#Setear WD a utilizar

#setwd()

#Descargar RData al WD que se quiera utilizar

RData <-'https://drive.google.com/file/d/1NOJAox0zQ98TuGfDQ4t5BIbcgUuKFSTN/view?usp=sharing'

#Cargar RData

load(paste0(getwd(),'/TP-EANT-Covid-19.RData'))

#Ejecución Shiny TP

shinyApp(ui=ui, server=server)

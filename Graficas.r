#Concurrencia subte

# Top 15 estaciones más frecuentadas, en scatter para ver concentración por horario (consideran fechas de febrero/20)

graf_subtefeb20 <-
ggplot(data = subte_gen_feb20, aes(x=desde,y=ESTACION,size=total,color=total))+
  geom_jitter()+
  scale_size_continuous(limits=c(50, 11000), breaks=seq(1000, 10000, by=1000))+
  scale_color_continuous(limits=c(50, 11000), breaks=seq(1000, 10000, by=1000))+
  guides(color= guide_legend(), size=guide_legend())+
  scale_x_continuous(breaks = seq(5,21,by = 1))+
  labs(title = 'Focos de concentración en estaciones',
       x = 'Horarios de ingreso al molinete por día',
       y = 'Estaciones'
  )+
  theme_bw()


# Top 15 estaciones más frecuentadas, en scatter para ver concentración por horario (consideran fechas de junio/19)

graf_subte <-
ggplot(data = subte_gen_jun19, aes(x=desde,y=ESTACION,size=total,color=total))+
  geom_jitter()+
  scale_size_continuous(limits=c(100, 16000), breaks=seq(2000, 16000, by=2000))+
  scale_color_continuous(limits=c(100, 16000), breaks=seq(2000, 16000, by=2000))+
  guides(color= guide_legend(), size=guide_legend())+
  scale_x_continuous(breaks = seq(5,21,by = 1))+
  labs(title = 'Focos de concentración en estaciones',
       x = 'Horarios de ingreso al molinete por día',
       y = 'Estaciones'
  )+
  theme_bw()+
  theme(legend.text = element_text( 'es el total'))


# GRÁFICO FALLECIDOS POR GENERO
graf_fallecidos <-
df_fallecidos %>%
  ggplot(aes(x=sexo,fill=sexo))+  
  geom_bar(show.legend = F, color='black')+
  coord_polar()+
  labs(title='Fallecidos por Género')+
  theme(plot.title = element_text(hjust=0.5))



#grafica con puntos INTERACTIVO CON PLOTLY.
#muestra por dia los accesos a una autopista del 13/3 al 27/3. los puntos del mismo color son los diferentes accesos
#podemos observar que hay mas cantidad de autos en Dellepiane

traf_mar_20 <- 
  ggplot(df_accesos_marzo2020, aes(x = fecha, y = totalDia ,color=autopista_nombre, text = paste("Acceso:",disp_nombre))) + 
  geom_point() +
  scale_color_viridis(discrete = T, option = 'D',direction = 1)+
  facet_wrap(~ autopista_nombre)+
  theme(axis.text.x = element_text(angle = 90),
        axis.title.x = element_blank(),
        axis.title.y = element_blank())+
  scale_y_continuous(label = scales::comma)+
  geom_hline(yintercept = 40000, colour="orange")+
  geom_hline(yintercept = 70000, colour="red")+
  labs(color='Autopista:')

traf_mar_20_p <- ggplotly(traf_mar_20)
traf_mar_20_p$x$layout$title <- 'Cantidad de Accesos periodo 13/3 a 27/3 del año 2020'
#traf_mar_20_p


#misma grafica pero para 2019

traf_mar_19 <- 
  ggplot(df_accesos_marzo_2019, aes(x = fecha, y = totalDia,color=autopista_nombre, text = paste("Acceso:",disp_nombre))) + 
  geom_point() +
  scale_color_viridis(discrete = T, option = 'D',direction = 1)+
  facet_wrap(~ autopista_nombre)+
  theme(axis.text.x = element_text(angle = 90),
        axis.title.x = element_blank(),
        axis.title.y = element_blank())+
  scale_y_continuous(label = scales::comma)+
  geom_hline(yintercept = 40000, colour="orange")+
  geom_hline(yintercept = 70000, colour="red")+
  labs(color='Autopista:')

traf_mar_19_p <- ggplotly(traf_mar_19)
traf_mar_19_p$x$layout$title <- 'Cantidad de Accesos periodo 13/3 a 27/3 del año 2019'
#traf_mar_19



##grafico año 2020 del 13 al 27 de marzo Sentido A

traf_mar20_sentidoA <- ggplot(sentidoA, aes(x = fecha, y = totalDia,color=autopista_nombre, text = paste("Acceso:",disp_nombre))) + 
  geom_point() +
  scale_color_viridis(discrete = T, option = 'D',direction = 1)+
  facet_wrap(~ autopista_nombre)+
  theme(axis.text.x = element_text(angle = 90),
        axis.title.x = element_blank(),
        axis.title.y = element_blank())+
  scale_y_continuous(label = scales::comma)+
  geom_hline(yintercept = 40000, colour="orange")+
  geom_hline(yintercept = 70000, colour="red")
traf_mar20_sentidoA_p <- ggplotly(traf_mar20_sentidoA)+
  labs(color='Autopista:')

traf_mar20_sentidoA_p$x$layout$title <- 'Cantidad de Accesos periodo 13/3 a 27/3 del año 2020 sentidoA'
#traf_mar20_sentidoA_p



##grafico año 2020 del 13 al 27 de marzo Sentido B

traf_mar20_sentidoB <- ggplot(sentidoB, aes(x = fecha, y = totalDia,color=autopista_nombre, text = paste("Acceso:",disp_nombre))) + 
  geom_point() +
  scale_color_viridis(discrete = T, option = 'D',direction = 1)+
  facet_wrap(~ autopista_nombre)+
  theme(axis.text.x = element_text(angle = 90),
        axis.title.x = element_blank(),
        axis.title.y = element_blank())+
  scale_y_continuous(label = scales::comma)+
  geom_hline(yintercept = 40000, colour="orange")+
  geom_hline(yintercept = 70000, colour="red")+
  labs(color='Autopista:')

traf_mar20_sentidoB_p <- ggplotly(traf_mar20_sentidoB)
traf_mar20_sentidoB_p$x$layout$title <- 'Cantidad de Accesos periodo 13/3 a 27/3 del año 2020 sentidoB'
#traf_mar20_sentidoB_p




###
#view(df_sentidoB_junio19$promedioMes[1]/1000)
#view(df_sentidoA_junio19$promedioMes/1000)
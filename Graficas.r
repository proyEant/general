#Concurrencia subte

# Top 15 estaciones más frecuentadas, en scatter para ver concentración por horario (consideran fechas de febrero/20)

graf_subtefeb20 <-
ggplot(data = subte_gen_feb20, aes(x=desde,y=ESTACION,size=total,color=total))+
  geom_point()+ # esta variante es más estética me parece
  scale_size_continuous(limits=c(1000, 12000), breaks=seq(1000, 12000, by=1000))+
  scale_color_continuous(limits=c(1000, 12000), breaks=seq(1000, 12000, by=1000))+
  guides(color= guide_legend(), size=guide_legend())+
  scale_x_continuous(breaks = seq(5,21,by = 1))+
  labs(title = 'Focos de concentración en estaciones más frecuentadas',
       x = 'Horarios de ingreso al molinete',
       y = 'Estaciones'
       )+
  theme_bw()

#ggplotly(graf_subtefeb20)

# Top 15 estaciones más frecuentadas, en scatter para ver concentración por horario (consideran fechas de junio/19)

graf_subte_jitter <-
ggplot(data = subte_gen_jun19, aes(x=desde,y=ESTACION,size=total,color=total))+
  geom_jitter()+
  scale_size_continuous(limits=c(100, 16000), breaks=seq(2000, 16000, by=2000))+
  scale_color_continuous(limits=c(100, 16000), breaks=seq(2000, 16000, by=2000))+
  guides(color= guide_legend(), size=guide_legend())+
  scale_x_continuous(breaks = seq(5,21,by = 1))+
  labs(title = 'Focos de concentración en estaciones',
       x = 'Horarios de ingreso al molinete',
       y = 'Estaciones'
       )+
  theme_bw()


# Top 15 estaciones más frecuentadas, en scatter para ver concentración por horario (consideran fechas de junio/19) V2 + estética

graf_subte <-
  ggplot(data = subte_gen_jun19, aes(x=desde,y=ESTACION,size=total,color=total))+
  geom_point()+
  scale_size_continuous(limits=c(1000, 16000), breaks=seq(2000, 16000, by=2000))+
  scale_color_continuous(limits=c(1000, 16000), breaks=seq(2000, 16000, by=2000))+
  guides(color= guide_legend(), size=guide_legend())+
  scale_x_continuous(breaks = seq(5,21,by = 1))+
  labs(title = 'Focos de concentración en estaciones más frecuentadas',
       x = 'Horarios de ingreso al molinete',
       y = 'Estaciones'
  )+
  theme_bw()
graf_subte_p <- ggplotly(graf_subte)

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
  geom_hline(yintercept = 70000, colour="red")+
  labs(color='Autopista:')
traf_mar20_sentidoA_p <- ggplotly(traf_mar20_sentidoA)
  

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


## confirmados y fallecidos
graf_confirm_fallec <-
  ggplot(casos54, aes(area = tot.x, fill = sexo, subgroup=edad,label=label.x)) +
  geom_treemap(aes(alpha=prop_fall))+
  geom_treemap_subgroup_border(colour='white')+
  geom_treemap_text(colour = "Black", place = "topleft", reflow = T)+
  geom_treemap_subgroup_text(place = 'bottom',
                             grow = T,
                             alpha = 0.5,
                             colour = '#FAFAFA',
                             min.size = 0)+
  scale_alpha_continuous(range = c(0.4, 1))+
  labs(fill = 'Sexo',
       area = 'Total',
       alpha = 'Proporción',
       title = 'Cantidades y proporciones entre confirmados y fallecidos')+
  theme_gray()


## confirmados
graf_confirm <-
  ggplot(casos54, aes(area = tot.y, fill = sexo, subgroup=edad,label=label.y)) +
  geom_treemap(aes(alpha=propglob.y))+
  geom_treemap_subgroup_border(colour='white')+
  geom_treemap_subgroup_text(place = 'bottom',
                             grow = T,
                             alpha = 0.5,
                             colour = '#FAFAFA',
                             min.size = 0)+
  geom_treemap_text(colour = "Black", place = "topleft", grow = T, reflow = F)+
  scale_alpha_continuous(range = c(0.4, 1))+
  labs(fill = 'Sexo',
       area = 'Total',
       alpha = 'Proporción',
       title = 'Cantidades y proporciones entre confirmados')+
  theme_gray()


## confirmados y desartados por edad
graf_confirm_edad <-
  ggplot(casos50, aes(x=edad,y=n,color=sexo))+
  geom_point(size = 2)+
  scale_x_continuous(breaks = seq(from=0,to=110,by=5))+
  scale_y_continuous(breaks = seq(from=0,to=max(casos50$n),by=5))+
  theme_bw()+
  theme(axis.text.x = element_text(angle = 90,face = 'bold'),
        axis.text.y = element_text(face = 'bold'),
        axis.title.x = element_text(face = 'bold'),
        axis.title.y = element_text(face = 'bold'))+
  labs(title = element_text('Casos confirmados por edad.'),
       x = 'Edad',
       y = 'Cantidad de casos',
       color = 'Sexo')+
  facet_grid(. ~clasificacion_resumen)

graf_confirm_edad_p <- ggplotly(graf_confirm_edad)

###
#view(df_sentidoB_junio19$promedioMes[1]/1000)
#view(df_sentidoA_junio19$promedioMes/1000)
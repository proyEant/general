#Concurrencia subte

ggplot(data = subte_gen_feb20 , aes(x=desde,y=ESTACION,size=total,color=total))+
  geom_jitter()+
  scale_size_continuous(limits=c(250, 7000), breaks=seq(500, 10000, by=500))+
  scale_color_continuous(limits=c(250, 7000), breaks=seq(500, 10000, by=500))+
  guides(color= guide_legend(), size=guide_legend())+
  scale_x_continuous(breaks = seq(5,21,by = 1))+
  labs(title = 'Focos de concentración en estaciones',
       x = 'Horarios de ingreso al molinete por día',
       y = 'Estaciones'
  )+
  theme_bw()

# Estaciones más frecuentadas, en scatter para ver concentración por horario (consideran fechas de febrero/20)


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
  theme_bw()

# Top 15 estaciones más frecuentadas, en scatter para ver concentración por horario (consideran fechas de abril/19)

ggplot(data = subte_gen_abr19, aes(x=desde,y=ESTACION,size=total,color=total))+
  geom_jitter()+
  scale_size_continuous(limits=c(100, 16000), breaks=seq(2000, 16000, by=2000))+
  scale_color_continuous(limits=c(100, 16000), breaks=seq(2000, 16000, by=2000))+
  guides(color= guide_legend(), size=guide_legend())+
  scale_x_continuous(breaks = seq(5,21,by = 1))+
  labs(title = 'Focos de concentración en estaciones',
       x = 'Horarios de ingreso al molinete por día',
       y = 'Estaciones'
  )+
  theme_bw()


# GRÁFICO FALLECIDOS POR GENERO

df_fallecidos %>%
  ggplot(aes(x=sexo,fill=sexo))+  
  geom_bar(show.legend = F, color='black')+
  coord_polar()+
  labs(title='Fallecidos por Género')+
  theme(plot.title = element_text(hjust=0.5))


###
#view(df_sentidoB_junio19$promedioMes[1]/1000)
#view(df_sentidoA_junio19$promedioMes/1000)
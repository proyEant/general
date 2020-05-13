#Concurrencia subte

ggplot(data = molinetes, aes(x=desde,y=estacion,size=total,color=total))+
  geom_jitter()+
  scale_size_continuous(limits=c(750, 7000), breaks=seq(1000, 10000, by=500))+
  scale_color_continuous(limits=c(750, 7000), breaks=seq(1000, 10000, by=500))+
  guides(color= guide_legend(), size=guide_legend())+
  scale_x_continuous(breaks = seq(5,21,by = 1))+
  labs(title = 'Focos de concentración en estaciones',
       x = 'Horarios de ingreso al molinete por día',
       y = 'Estaciones'
  )+
  theme_bw()

ggplot(data = molinetesmapa, aes(x=desde,y=ESTACION,size=total,color=total))+
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

ggplot(data = molinetes2019, aes(x=desde,y=estacion,size=total/30,color=total/30))+
  geom_jitter()+
  scale_size_continuous(limits=c(50, 700), breaks=seq(50, 600, by=50))+
  scale_color_continuous(limits=c(50, 700), breaks=seq(50, 600, by=50))+
  guides(color= guide_legend(), size=guide_legend())+
  scale_x_continuous(breaks = seq(5,22,by = 1))+
  labs(title = 'Focos de concentración en estaciones',
       x = 'Horarios de ingreso al molinete',
       y = 'Total de personas')

view(df_sentidoB_junio19$promedioMes[1]/1000)
view(df_sentidoA_junio19$promedioMes/1000)
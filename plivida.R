library(raster)
library(sf)

#biomas <- st_read("bioma_250.shp") #shapes do IBGE dão o maior B.O.
#class(biomas)
#summary(biomas)

cer <- st_read("Cerrado_ecor_2017.shp")
summary(cer)

plot(st_geometry(cer))

pl <- read.csv("PLIVIDA_corrected.csv") #lê a planilha de dados
head(pl)
pl <- pl[-c(11, 13),] #remove os dois pontos sem coordenadas
pl

plr <- pl[,c(6,7)] #extrai as coordenadas
x <- plr$Long
y <- plr$Lat
plr <- cbind(x, y)
class(plr) #st_multipoint funciona para matrizes mas n para df

?st_multipoint
plr <- st_multipoint(plr) #create sf from vector

plot(plr, axes= TRUE)
class(plr)

?st_sfc
geom <- st_sfc(plr) #creates sf geometry
class(geom)

?st_sf
plivida <- st_sf(pl[,c(1, 3, 4,5,8,9)], geometry = geom)
print(plivida)

plot(plivida, axes=T) #plota em relação a todas as colunas
plot(st_geometry(plivida), axes=T) #plota só a geometria

par(mar=c(1,1,1,1))
plot(st_geometry(cer))
plot(st_geometry(plivida), col="red", axes=T, pch=16, add=T) #plota só a geometria

#Parte de raster
?list.files
rlist <- list.files(path=getwd(), pattern = ".tif$") #importando nomes todos os rasters da pasta pra um arquivo
rlist
?stack
stk <- stack(rlist) #criar um RasterStack (varios rasters um sobre o outro)

fstk <- freq(stk, progress='text', merge=TRUE) #muito massa! conta a quantidade de pixels por categoria
write.csv(fstk, "plivida_landuse.csv")
pland <- t(fstk)


pl85 <- raster("plivida1985.tif")
plot(pl85)

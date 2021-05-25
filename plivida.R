#testing GIT
library(raster)
library(sf) #loads package ai aiaiai

#biomas <- st_read("bioma_250.shp") #shapes do IBGE dão o maior B.O.
#class(biomas)
#summary(biomas)

cer <- st_read("Cerrado_ecor_2017.shp") #read shape Cerrado ecoregion
plot(st_geometry(cer)) #plot geometry Cerrado ecoregion

pl <- read.csv("PLIVIDA_corrected.csv") #read database
pl
pl <- pl[-c(11, 13),] #remove os dois pontos sem coordenadas
pl

plr <- pl[,c(6,7)] #extrai as coordenadas
x <- plr$Long
y <- plr$Lat
plr <- cbind(x, y)
class(plr) #st_multipoint funciona para matrizes mas n para df

?st_multipoint
plr <- st_multipoint(plr) #create sf from vector

plot(plr, axes= TRUE) #plot point localities
class(plr)

?st_sfc
geom <- st_sfc(plr) #creates sf geometry
class(geom)

?st_sf
plivida <- st_sf(pl[,c(1, 3, 4,5,8,9)], geometry = geom) #creates sf object
print(plivida) #check contents
plot(st_geometry(plivida), axes=T) #plot point localities, with database information

par(mar=c(1,1,1,1))
plot(st_geometry(cer)) #plot background
plot(st_geometry(plivida), col="red", axes=T, pch=16, add=T) #plot point localities

#Parte de raster
?list.files
rlist <- list.files(path=getwd(), pattern = ".tif$") #importando nomes todos os rasters da pasta pra um arquivo
rlist
?stack
stk <- stack(rlist) #criar um RasterStack (varios rasters um sobre o outro)

fstk <- freq(stk, progress='text', merge=TRUE) #muito massa! conta a quantidade de pixels por categoria
write.csv(fstk, "plivida_landuse.csv")
pland <- t(fstk)
pland
class(pland)
pland <- as.data.frame(pland)

colnames(pland) <- pland[1,] #rename with land use ID
pland <- pland[-1,-1] #rename ID zero and first row
pland

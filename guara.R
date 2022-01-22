#Link para a pub original = https://rpubs.com/RonaldoAnticona/821750
library(sf)
library(geobr)
library(rgee)

ee_Initialize()

guara <- st_read("dados/vector/guara_shp.shp") %>% sf_as_ee()


basin_ichu<- st_read("shp/ichu.shp")%>%
    sf_as_ee()

geom_guara <- guara$geometry()

elev <- ee$Image("USGS/SRTMGL1_003")$
    select('elevation')

# Características de la ee$Image
cat("Band names: ", paste(elev$bandNames()$getInfo(), collapse = " "))
cat("type: ", elev$projection()$getInfo()$type)
cat("geotransform: ", paste0(elev$projection()$getInfo()$transform, " "))
cat("SRTM resolution: ", elev$projection()$nominalScale()$getInfo())

Map$centerObject(geom_guara, zoom = 3)
vizPrm<- list( min = 0,
               max = 2400,
               palette =c("006600", "002200", "fff700",
                          "ab7634", "c4d0ff", "ffffff"))
Map$addLayer(elev,visParams =vizPrm)

dem_guara_clip<- elev$clip(guara)

Map$centerObject(geom_ichu, zoom = 10)
Map$addLayer(dem_guara_clip,visParams =vizPrm)

geom_params <- list(
    scale = 30,
    crs = 'EPSG:32723',
    region = geom_guara
)

path <- elev$getDownloadUrl(geom_params)
print(path)


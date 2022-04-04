# Packages
library(sf)
library(reticulate)
library(rgee)
library(tidyverse)
library(RColorBrewer)

# Set up Earth Engine credentials
ee_Initialize(user = 'j.newedi@gmail.com', drive = T)

# Set geometry bounds for raster data
geometry <- ee$Geometry$Rectangle(-110, 35, -105, 40)

# Visualize the boundaries
Map$addLayer(geometry)

# Set start and end dates for data
start_dt <- ee$Date('2020-06-01')
end_dt <- ee$Date('2020-06-30')

# Import Ecoregions feature collection
ecoregions <- ee$FeatureCollection("EPA/Ecoregions/2013/L3")

# Import temperature
temp <- ee$ImageCollection("OREGONSTATE/PRISM/AN81m")$
  # Select 'tmean' (mean temperature) band
  select('tmean')$
  # Filter dates
  filterDate(start_dt, end_dt)$
  # Get mean for each pixel
  reduce(ee$Reducer$mean())

# Import NDVI image collection for May-June 2020
ndvi <- ee$
  ImageCollection('MODIS/006/MOD13A2')$
  filterBounds(geometry)$
  filterDate(start_dt, end_dt)$
  select('NDVI')$reduce(ee$Reducer$mean())

# Define palettes for temperature and NDVI
# Temp
tempViz <- list(
  min = -30,
  max = 40,
  palette = brewer.pal(9, 'YlOrRd')
)
#NDVI
ndviViz <- list(
  min = 1900,
  max = 6000,
  palette = brewer.pal(9, 'BuGn')
)

# View NDVI and temperature
Map$addLayer(temp, tempViz) +
  Map$addLayer(ndvi$clip(geometry), ndviViz)

# Filter ecoregions by geometry
mw_ecoreg <- ecoregions$filterBounds(geometry)

# Convert ee feature collection to sf object
mw_ecoreg_sf <- ee_as_sf(mw_ecoreg)

# Extract NDVI mean for each ecoregion
ndvi_means <- ee_extract(ndvi, mw_ecoreg_sf, fun = ee$Reducer$mean())

# Join ecoregion sf with mean NDVI
ndvi_ecoregions <- mw_ecoreg_sf %>%
  left_join(ndvi_means)

# Plot
ggplot() + geom_sf(data = ndvi_ecoregions, aes(fill = NDVI_mean))

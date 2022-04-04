
library(sf)
library(reticulate)
library(rgee)
library(tidyverse)

# Data
elk_dat <- readRDS('data/elk_dat.rds')

# Set up Earth Engine credentials
ee_Initialize(user = 'j.newedi@gmail.com', drive = TRUE)

# Create bounding box around the elk data
geometry <- st_bbox(elk_dat)

# Convert to EE feature collection
elk_dat_ee <- elk_dat %>%
  mutate(dat_time = as.character(dat_time)) %>%
  sf_as_ee()

# View elk data
Map$addLayer(elk_dat_ee)

# Import NDVI image collection for May-June 2020
ndvi <- ee$
  ImageCollection('MODIS/006/MOD13A2')$
  filterBounds(geometry)$
  filterDate(ee$Date('2016-01-01'), ee$Date('2016-12-31'))$
  select('NDVI')$reduce(ee$Reducer$mean())

# Extract mean NDVI at each location point
ndvi_samples <- ee_extract(ndvi, elk_dat_ee)

# We can even extract NDVI directly from the sf object
ndvi_samples_from_sf <- ee_extract(ndvi, elk_dat)

# View location data
head(ndvi_samples, n = 10)


###################################
# Visualize spatial data #
###################################


rm(list=ls())

library(tidyverse)
library(rnaturalearth)
library(extrafont)
library(sf)
#remotes::install_github('Chrisjb/basemapR')
library(basemapR)
library(raster)
library(patchwork)
library(RColorBrewer)
library(ggtext)
library(rayshader)
# install.packages("mapboxapi")
library(mapboxapi)
# remotes::install_github("anthonynorth/snapbox")
library(snapbox)
# install.packages("devtools")
library(mapdeck)
library(leaflet)
library(tigris)


# apply a public token from https://www.mapbox.com/
my_token <- "pk.eyJ1IjoiZmVuaXg4OTgiLCJhIjoiY2tvbm94ajJnMDNpeDJvdGd2MzcxbWdtMSJ9.ffaY5XRUU31sW11jFlZBsQ" # add the token generated from your Mapbox account to the r enviornment
mb_access_token(my_token, install = TRUE, overwrite=TRUE)

# restart r session
Sys.getenv("pk.eyJ1IjoiZmVuaXg4OTgiLCJhIjoiY2tvbm9vdzUyMDNobjJvcGljYWhlajVnaCJ9.OiFObTd_KsBfZdCNilEIvg")

isochrones_cyc <- mb_isochrone(
  location = c(144.963230,-37.815340),
  profile = "cycling",
  time = c(10, 30, 45))

isochrones_walk <- mb_isochrone(
  location = c(144.963230,-37.815340),
  profile = "walking",
  time = c(10, 30, 45))

isochrones_driving <- mb_isochrone(
  location = c(144.963230,-37.815340),
  profile = "driving",
  time = c(10, 30, 45))


# mapping for cycling to Melbourne CBD
cyc<-mapdeck(style = mapdeck_style("streets"), zoom = 8,
        min_zoom = 4, max_zoom = 10) %>%
  add_polygon(data = isochrones_cyc,
              fill_colour = "time",
              fill_opacity = 0.3,
              legend = TRUE, 
              legend_format = list( fill_colour = as.integer )) 

# plot the map
cyc

#mapping for walking to Melbourne CBD
walking<-mapdeck(style = mapdeck_style("streets"), zoom = 8,
             min_zoom = 4, max_zoom = 10) %>%
  add_polygon(data = isochrones_walk,
              fill_colour = "time",
              fill_opacity = 0.3,
              legend = TRUE, 
              legend_format = list( fill_colour = as.integer )) 

# plot the map
walking

# mapping for  driving to Melbourne CBD
driving<-mapdeck(style = mapdeck_style("streets"), zoom = 8,
                 min_zoom = 4, max_zoom = 10) %>%
  add_polygon(data = isochrones_driving,
              fill_colour = "time",
              fill_opacity = 0.3,
              legend = TRUE, 
              legend_format = list( fill_colour = as.integer )) 


# plot the map
driving

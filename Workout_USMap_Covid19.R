#install.packages(c("sf", "maps", "ggplot2", "ggthemes", "dplyr", "tidyr", "stringr", "tidyverse", "tidyr", "ggmap", "gganimate", "transformr", "viridis", "scales"))

#install.packages("devtools")
#devtools::install_github("UrbanInstitute/urbnmapr")

library(urbnmapr)

library(sf)
library(maps)
library(ggplot2)  
library(ggthemes)
library(dplyr)    
library(tidyr)    
library(stringr)
library(tidyverse)
library(tidyr)
library(ggmap)
library(gganimate)
library(transformr)
library(viridis)
library(scales) 

# Getting the spatial data and US map
states_sf <- get_urbn_map(map = "states", sf = TRUE)
counties_sf <- get_urbn_map(map = "counties", sf = TRUE)

# Load the Covid19 data from JHU
jhu_confirmed_cases_US <- read.csv("time_series_covid19_confirmed_US_revised.csv", colClasses=c(FIPS="character")) 

# Pivoting the data for further analysing
Confirmed_cases_US <- jhu_confirmed_cases_US %>%
  pivot_longer(cols=-c(FIPS, Admin2, Province_State, Country_Region, Lat, Long, Combined_Key),
               names_to="Dates",
               values_to = "Case_Count") %>%
  mutate(Dates=str_replace_all(Dates,"X","")) %>%
  mutate(Dates=str_replace_all(Dates,"\\.","/")) %>%
  mutate(Dates=as.Date(Dates,format="%m/%d/%Y")) %>%
  mutate(FIPS =str_pad(FIPS, 5, pad="0"))


# Figure out the latest confirmed cases on each county of all states from this dataset (as of 13th Feb 2021)
Latest_confirmed_cases_US <- Confirmed_cases_US %>%
  filter(Dates=="2021-02-13")

# Joining the two datasets for Covid19 & US map data
Latest_confirmed_cases_County <- inner_join(counties_sf, Latest_confirmed_cases_US, by=c("county_fips"="FIPS"))

####==== Part 1 - Visualizing the data on the map ====####
#### Separated PNG animation file submitted on Moodle #### 

Latest_confirmed_cases_County %>%
  ggplot() +
  geom_sf(mapping = aes(fill = Case_Count), color = NA) +
  geom_sf(data = states_sf, fill = NA, color = "snow", size = 0.15) +
  scale_fill_viridis(trans = "log",                      
                     direction = -1, 
                     na.value="grey", 
                     breaks=c(0.1,10,100,1000,10000,100000,1000000),
                     labels = comma,
                     max(Latest_confirmed_cases_County$Case_Count),
                     name="Confirmed Cases (number reached)",
                     guide = guide_legend(keyheight=unit(3, units = "mm"),
                                          keywidth=unit(12, units = "mm"),
                                          label.position = "bottom", 
                                          title.position = 'top', 
                                          nrow=1))+
  labs(title="United States, the latest no. of confirmed cases of Covid-19",
       subtitle = "Counted on the total cases per county for all states (Updated as of 13th Feb 2021)",
       caption = "Data source: The Center for Systems Science and Engineering (CSSE) at Johns Hopkins University")+
  theme_economist()+
  theme(legend.position="bottom", panel.border = element_blank())+
  geom_sf_text(data=states_sf, aes(label = state_name), size = 3, fontface="bold",colour = "snow")



####==== Part 2 - Animating the Outbreak of Covid-19 in USA (January 2020 - February 2021) ====######

# Visualising how the outbreak of COvid-19 developed on the first 3 months in USA


Rolling_cases_US <- Confirmed_cases_US %>%
  filter(Dates<="2020-03-30")

Rolling_cases_US<- inner_join(counties_sf, Rolling_cases_US, by=c("county_fips"="FIPS"))


RollGIF <- Rolling_cases_US %>%
  ggplot() +
  geom_sf(mapping = aes(fill = Case_Count), color = NA) +
  geom_sf(data = states_sf, fill = NA, color = "snow", size = 0.15) +
  scale_fill_viridis(trans = "log",                      
                     direction = -1, na.value="gray", 
                     breaks=c(10,100,1000,10000,100000,1000000),
                     labels = comma,
                     max(Rolling_cases_US$Case_Count),
                     name="Confirmed Cases (number reached)",
                     guide = guide_legend( keyheight = unit(3, units = "mm"), 
                                           keywidth=unit(12, units = "mm"), 
                                           label.position = "bottom", 
                                           title.position = 'top', 
                                           nrow=1))+
  labs(title="The lastest number of confirmed cases of Covid 19 in USA",
       subtitle = "The statistics are counted on the numbers of each county of all states (Updated as of 13 Feb 2021)",
       caption = "Data source: The Center for Systems Science and Engineering (CSSE) at Johns Hopkins University")+
  theme_economist()+
  theme(legend.position="bottom", panel.border = element_blank())+
  geom_sf_text(data=states_sf, aes(label = state_name), size = 3, fontface="bold",colour = "snow")


#!!IMPORTANT!!# - It can take 30min to process the below animation!
print(RollGIF + transition_time(Dates) + 
        labs(title='Confirmed COVID-19 Cases: {frame_time}'))


# saves animation
anim_save("Covid19_First3Month_20450540.gif")

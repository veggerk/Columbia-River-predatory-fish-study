# Karl Veggerby
# figure 1 script for columbia river predatory fish study
# spring 2023

# takes about 30 seconds to run entire script


# packages
library(sf)
library(here)
library(tidyverse)
library(ggspatial)
library(png)
library(grid)
library(patchwork)

here::i_am("R/figure 1 code.R")

 
 # get Portland Oregon geodata to add to map
 places <- read_sf(here("data", "figure 1 data", "ne_10m_populated_places", "ne_10m_populated_places.shp"))
 
 portland<-places %>% 
   filter(NAME == "Portland") %>% 
   filter(ADM1NAME == "Oregon")
 
 
 # get country shape file to use as an underlayer to make ocean fill consistent in map
 countries <- read_sf(here("data", "figure 1 data", "ne_10m_admin_0_countries", "ne_10m_admin_0_countries.shp"))
 
 
 # load in fish pics
 walleye <- readPNG("data/figure 1 data/Walleye_Duane_Raver.png", native = TRUE)
 npm <- readPNG("data/figure 1 data/npm_pikeminnow_org.png", native = TRUE)
 
 
 # pull in specific layers for Washington and Oregon. The combination of stream area and 
 # waterbody produce a full, clear map of the columbia river. 
stream_area_or <- sf::read_sf(here("data", "figure 1 data", "stream_area_Oregon_State.gpkg"))
waterbody_or <- sf::read_sf(here("data", "figure 1 data", "waterbody_Oregon_State.gpkg"))
 
stream_area_wa <- sf::read_sf(here("data","figure 1 data","stream_area_Washington_State.gpkg"))
waterbody_wa <- sf::read_sf(here("data", "figure 1 data", "waterbody_Washington_State.gpkg"))
 

# subset out water features we don't want from stream area data
unique(stream_area_wa$fcode_description)


stream_area_wa<-stream_area_wa %>% 
  filter(fcode_description != "Inundation Area: Inundation Control Status = Not Controlled")%>%
  filter(fcode_description != "Inundation Area: Inundation Control Status = Controlled; Stage = Flood Elevation")%>%
  filter(fcode_description != "Inundation Area: Inundation Control Status = Controlled")
  

stream_area_or<-stream_area_or %>% 
  filter(fcode_description != "Inundation Area: Inundation Control Status = Not Controlled")%>%
  filter(fcode_description != "Inundation Area: Inundation Control Status = Controlled; Stage = Flood Elevation")%>%
  filter(fcode_description != "Inundation Area: Inundation Control Status = Controlled")


#make new layer for few misc small features that connect river segments
waterbody_wa1<-waterbody_wa %>% 
  filter(gnis_name == "Swift Number Two Forebay" | 
           gnis_name == "Lake Scanewa"| 
           gnis_name == "Chance Lake"| 
           gnis_name == "Scooteney Reservoir"| 
           gnis_name == "Alder Lake"| 
           gnis_name == "Clear Lake"| 
           gnis_name == "Carty Reservoir")

  
#make new layer for reservoirs that will be colored differently
waterbody_res<-waterbody_wa %>% 
  filter(gnis_name == "Bonneville Reservoir" | 
           gnis_name == "Lake Bonneville" |
           gnis_name == "Lake Celilo"| 
           gnis_name == "Lake Umatilla"| 
           gnis_name == "Lake Wallula"| 
           gnis_name == "Priest Rapids Lake"| 
           gnis_name == "Lake Sacajawea"| 
           gnis_name == "Lake Herbert G West"| 
           gnis_name == "Lake Bennington")


estuary_wa <- waterbody_wa %>% 
  filter(fcode_description == "Estuary")


estuary_or <- waterbody_or %>% 
  filter(fcode_description == "Estuary")


natural_lakes_wa <- waterbody_wa %>%
  filter(gnis_name == "Vancouver Lake" |
          gnis_name == "Spirit Lake" | 
          gnis_name == "Coldwater Lake" |
          gnis_name == "Castle Lake" |
          gnis_name == "Silver Lake"|
           gnis_name == "Saddle Mountain Lake")


natural_lakes_or <- waterbody_or %>% 
  filter(gnis_name == "Sturgeon Lake")


# remove unwanted features
waterbody_wa <- waterbody_wa %>% 
  filter(fcode_description != "Ice Mass")%>%
  filter(fcode_description != "Estuary")%>%
 filter(fcode_description != "Swamp/Marsh: Hydrographic Category = Intermittent")%>%
  filter(fcode_description != "Swamp/Marsh")%>%
 filter(fcode_description != "Reservoir: Reservoir Type = Sewage Treatment Pond")%>%
  filter(fcode_description != "Lake/Pond: Hydrographic Category = Intermittent")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Aquaculture")%>%
 filter(fcode_description != "Swamp/Marsh: Hydrographic Category = Perennial")%>%
  filter(fcode_description != "Lake/Pond")%>%
  filter(fcode_description != "Reservoir; Reservoir Type = Treatment")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Settling Pond")%>%
  filter(fcode_description != "Lake/Pond: Hydrographic Category = Perennial; Stage = Date of Photography")%>%
 filter(fcode_description != "Playa")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Swimming Pool")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Tailings Pond")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Filtration Pond")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Decorative Pool")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Disposal; Construction Material = Earthen")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Tailings Pond; Construction Material = Earthen")%>%
  filter(fcode_description != "Lake/Pond: Hydrographic Category = Perennial; Stage = Normal Pool")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Water Storage; Construction Material = Earthen; Hydrographic Category = Intermittent")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Evaporator")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Disposal")%>%
  filter(fcode_description != "Lake/Pond: Hydrographic Category = Intermittent; Stage = High Water Elevation")%>%
filter(fcode_description != "Reservoir: Reservoir Type = Cooling Pond")%>%
  filter(fcode_description != "Lake/Pond: Hydrographic Category = Intermittent; Stage = Date of Photography")
 
 
waterbody_wa<-waterbody_wa %>% 
  filter(areasqkm >= 3)
  


#make new layer for few misc small features that connect river segments
waterbodyor1<-waterbody_or %>% 
  filter(gnis_name == "Bull Run Reservoir Number One" | 
           gnis_name == "Bull Run Reservoir Number Two"| 
           gnis_name == "McKay Reservoir")


waterbody_or<-waterbody_or %>% 
  filter(fcode_description != "Ice Mass")%>%
  filter(fcode_description != "Estuary")%>%
  filter(fcode_description != "Swamp/Marsh: Hydrographic Category = Intermittent")%>%
  filter(fcode_description != "Swamp/Marsh")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Sewage Treatment Pond")%>%
  filter(fcode_description != "Lake/Pond: Hydrographic Category = Intermittent")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Aquaculture")%>%
  filter(fcode_description != "Swamp/Marsh: Hydrographic Category = Perennial")%>%
  filter(fcode_description != "Lake/Pond")%>%
  filter(fcode_description != "Reservoir; Reservoir Type = Treatment")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Settling Pond")%>%
  filter(fcode_description != "Lake/Pond: Hydrographic Category = Perennial; Stage = Date of Photography")%>%
  filter(fcode_description != "Playa")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Swimming Pool")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Tailings Pond")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Filtration Pond")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Decorative Pool")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Disposal; Construction Material = Earthen")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Tailings Pond; Construction Material = Earthen")%>%
  filter(fcode_description != "Lake/Pond: Hydrographic Category = Perennial; Stage = Normal Pool")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Water Storage; Construction Material = Earthen; Hydrographic Category = Intermittent")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Evaporator")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Disposal")%>%
  filter(fcode_description != "Lake/Pond: Hydrographic Category = Intermittent; Stage = High Water Elevation")%>%
  filter(fcode_description != "Reservoir: Reservoir Type = Cooling Pond")%>%
  filter(fcode_description != "Lake/Pond: Hydrographic Category = Intermittent; Stage = Date of Photography")


waterbody_or<-waterbody_or %>% 
  filter(areasqkm >= 3)


 # make dams spacial object to add to plot
 dam<-c("Bonneville Dam",
        "The Dalles Dam",
        "John Day Dam",
        "McNary Dam",
        "Priest Rapids Dam",
        "Wanapum Dam",
        "Ice Harbor Dam",
        "Lower Monumental Dam",
        "Little Goose Dam")
 
 latitude<-c(45.644357,
             45.613940,
             45.715048
             ,45.935707,
             46.644427,
             46.874594,
             46.249022,
             46.562263,
             46.585538)
 
 longitude<-c(-121.940796,
              -121.134056,
              -120.692405,
              -119.298001,
              -119.910078,
              -119.971039,
              -118.879713,
              -118.537810,
              -118.027335)
 
 

 
 
# make the dams a single dataframe that's in sf format
 # the 4326 crs is the same as the NHD data
 dams<-as.data.frame(cbind(dam,latitude,longitude))
 dams_sf<-st_as_sf(dams, coords = c("longitude", "latitude"), crs=4326)
 
 
 small_dams <- c("Carty Dam",
                 "McKay Dam",
                 "Cold Spring Dam",
                 "Scootteney Dam",
                 "Tieton Dam",
                 "Bull Run Dam 2",
                 "Bull Run Dam 1",
                 "Scoggins Dam",
                 "Merwin Dam",
                 "Yale Dam",
                 "Swift Dam",
                 "Prosser Dam",
                 "Roza Dam",
                 "Burping Lake Dam",
                 "Horn Rapids Dam",
                 "Sunnyside Dam",
                 "Wapato Dam")
 
 
 
 lat2 <- c(45.693975,
           45.605972,
           45.861329,
           46.668938,
           46.657368,
           45.444666,
           45.481739,
           45.472167,
           45.956535,
           45.963871,
           46.062797,
           46.212853,
           46.749009,
           46.873319,
           46.378689,
           46.497723,
           46.524427)
 
 
 long2 <- c(-119.799335,
            -118.797431,
            -119.175172,
            -119.032640,
            -121.128171,
            -122.154792,
            -122.082440,
            -123.198543,
            -122.555983,
            -122.335289,
            -122.200481,
            -119.772962,
            -120.465643,
            -121.299394,
            -119.417188,
            -120.444899,
            -120.475596)
 
 smaller_dams<-as.data.frame(cbind(small_dams,lat2,long2))
 smaller_dams_sf<-st_as_sf(smaller_dams, coords = c("long2", "lat2"), crs=4326)
 
 
 
 # add in annotation for upper John Day Reservoir and dam
 LATITUDE<- c(46.143566, 45.45,46.58,46.65,45.785499)
 LONGITUDE<- c(-119.862121, -121.0,-119.85,-118.55,-121.494954)
 NAME <- c("upper John Day Reservoir","John Day Dam","upper Columbia","Snake River", "lower Columbia")
 
 
 res_lab<-as.data.frame(cbind(NAME,LATITUDE,LONGITUDE))
 res_lab_sf<-st_as_sf(res_lab, coords = c("LONGITUDE", "LATITUDE"), crs=4326)
 
 
# make plot
columbia_river<-ggplot() +
  geom_sf(data = countries, color = "#6baed6", fill = "#f0f0f0") +
  geom_sf(data = estuary_wa, color = "#6baed6", fill = "#6baed6")+
  geom_sf(data = estuary_or, color = "#6baed6", fill = "#6baed6")+
  geom_sf(data = stream_area_wa, color = "#6baed6", fill = "#6baed6")+
  geom_sf(data = stream_area_or, color = "#6baed6", fill = "#6baed6")+
  geom_sf(data = waterbody_or, color = "#41ab5d", fill = "#41ab5d")+
  geom_sf(data = waterbody_wa, color = "#41ab5d", fill = "#41ab5d")+
  geom_sf(data = waterbody_wa1, color = "#41ab5d", fill = "#41ab5d")+
  geom_sf(data = waterbodyor1, color = "#41ab5d", fill = "#41ab5d")+
  geom_sf(data = waterbody_res, color = "#41ab5d", fill = "#41ab5d")+
  geom_sf(data = natural_lakes_or, color = "#6baed6", fill = "#6baed6")+
  geom_sf(data = natural_lakes_wa, color = "#6baed6", fill = "#6baed6")+
  geom_sf(data = dams_sf, color = "#fb6a4a", fill = "#fb6a4a", shape=15) +
  geom_sf(data = smaller_dams_sf, color = "#fb6a4a", fill = "#fb6a4a", shape=15, size=0.5) +
  coord_sf(xlim = c(-124.25,-118.25), ylim =c(45.4,46.75))+
   scale_x_continuous(labels = c("124° W","119° W"),
                    breaks = c(-124,-119),
                    name = "Map of the lower Columbia River with major dams, reservoirs, and tributaries")+
    scale_y_continuous(labels = c("45.5° N","46.5° N"),
                       breaks =c(45.5,46.5),
                       name = "")+
  theme(plot.background = element_rect(fill = "white"),
        panel.background = element_rect(fill="#6baed6", color = "black"),
        panel.border = element_rect(colour = "black", fill=NA, linewidth =1),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())+
  annotation_scale(location="br", 
                   style="bar",height = unit(0.12,"cm"),
                   bar_cols = c("#525252", "white"),
                   line_col = "#525252",
                   text_col = "#525252") +
  annotation_north_arrow(location="br", 
                         which_north="grid",
                         pad_y = unit(1,"cm"),
                         height = unit(0.85, "cm"),
                         width = unit(0.85, "cm"),
                         style = north_arrow_orienteering(fill = c("white", "#525252"),  
                                                          line_col = "#525252",
                                                           text_col = "#525252"))+
   geom_sf_label(data=portland, 
                 aes(x=LATITUDE,y=LONGITUDE, label=NAME),
                 color="black",
                 fill = "#f0f0f0",
                 label.size = 0,
                 size=2.4,
                label.padding = unit(0.05, "lines"))+
  geom_sf_label(data=res_lab_sf, 
                aes(x=LATITUDE,y=LONGITUDE, label=NAME),
                color="black",
                fill = "#f0f0f0",
                label.size = 0,
                size=2.4,
                label.padding = unit(0.05, "lines"))+
  annotate("segment", 
           x = -119.466507, 
           xend = -119.466507, 
           y = 46.108668, 
           yend = 45.935384,
           colour = "#fb6a4a",
           size = 0.5,
         arrow = arrow(length = unit(0.2, "cm")))+
  annotate("segment", 
           x = -120.692405, 
           xend = -120.692405, 
           y = 45.48, 
           yend = 45.67,
           colour = "#fb6a4a",
           size = 0.5,
           arrow = arrow(length = unit(0.2, "cm")))
  

# make custom bbox to show where columbia river map is in relation to north america
columbia_river_bbox <- c(
  xmin=-124.25,
  xmax=-118.25, 
  ymin=45.4, 
  ymax=46.75) %>%
  st_bbox(.,crs=st_crs(4326))%>%
  st_as_sfc()


#plot north america map with study are highlighted
large_map_usa<-ggplot() +
  geom_sf(data = countries, color = "#6baed6", fill = "#f0f0f0") +
  geom_sf(data = columbia_river_bbox, color = "#fb6a4a", fill = "#fb6a4a") +
  coord_sf(xlim = c(-145,-50), ylim =c(20,60))+
  theme(plot.background = element_rect(fill = "transparent", color="transparent"),
        panel.background = element_rect(fill="#6baed6", color = "black"),
        panel.border = element_rect(colour = "black", fill=NA, linewidth=1),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())+
  theme(panel.border = element_rect(colour = "black"))


#combine north america and columbia map into one patchwork object
final_figure_col <- columbia_river + inset_element(large_map_usa, left = -0.2, bottom = 0.6, right = 0.8, top = 1.1)


# combine fish into one patchwork object
fish <- wrap_elements(walleye) + wrap_elements(npm)+
  plot_layout(heights = c(2,1), ncol=2,nrow = 1)+
  plot_layout(tag_level = 'new') +
  plot_annotation(tag_levels = list(c('Walleye','Northern pikeminnow'))) &
  theme(plot.tag.position = c(0.5, -0.05),
        plot.tag = element_text(size = 11))


# combine fish and map into one patchwork object
final_figure <- final_figure_col/(wrap_elements(fish))+ 
  plot_layout(heights = c(2,1), ncol=1,nrow = 2)


#save final figure
ggsave(plot = final_figure, 
       filename = "figs/figure_1.pdf",width = 8,height = 5.5,units = "in")


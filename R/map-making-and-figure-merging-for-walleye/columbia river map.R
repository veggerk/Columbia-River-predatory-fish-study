# using a google maps version
library(png)
library(ggplot2)
library(grid)
library(patchwork)



#read in png of salmon river and format it for ggplot
map <- readPNG("R/map-making-and-figure-merging-for-walleye/lower_col_google_blue.png",native = TRUE)
gmap <- rasterGrob(map, interpolate=TRUE)

  # make graph and add location annotations
 lowcol<-qplot(1:10,1:10,geom="blank")+
    theme_classic()+
    annotation_custom(gmap)+
   theme(plot.margin = unit(c(t=0,r=0,b=-2,l=-2.5), "lines"))+
    annotate("text", x = 2.25, y = 4.12, label = "Portland, OR", color="black", size=4)+
    annotate("point", x = 3.12, y = 4.12,colour = "black",size=2)+
   annotate("point", x = 4.35, y = 4.29,colour = "#cb181d",size=2)+
   annotate("point", x = 5.55, y = 4.18,colour = "#cb181d",size=2)+
   annotate("point", x = 6.29, y = 4.45,colour = "#cb181d",size=2)+
   annotate("point", x = 8.4, y = 4.95,colour = "#cb181d",size=2)+
   annotate("text", x = 8.5, y = 4, label = "upper John Day Reservoir", color="#cb181d", size=5)+
   annotate("segment", x = 8.1, xend = 8.1, y = 4.2,
            yend = 4.85, linewidth = 0.5, color="#cb181d",
            arrow = arrow(length = unit(2, "mm")))+
   annotate("point", x = 7.45, y = 6.63,colour = "#cb181d",size=2)+
   annotate("point", x = 7.37, y = 7.18,colour = "#cb181d",size=2)+
   annotate("point", x = 9.02, y = 5.67,colour = "#cb181d",size=2)+
   annotate("point", x = 9.58, y = 6.43,colour = "#cb181d",size=2)+
   annotate("text", x = 5.35, y = 4.7, 
            label = "Lower Columbia River", 
            color="black",
            size=4)+
   annotate("text", x = 9.6, y = 6.75, 
            label = "Snake River", 
            color="black",
            size=4)+
   annotate("text", x = 6, y = 7.5, 
            label = "Upper Columbia River", 
            color="black",
            size=4)

 
 
ggsave(plot = lowcol,
       filename = "R/map-making-and-figure-merging-for-walleye/map.png")


# I manually remove the excess white area outside of R after saving the map.png


walleye <- readPNG("R/map-making-and-figure-merging-for-walleye/Walleye_Duane_Raver.png", native = TRUE)
npm <- readPNG("R/map-making-and-figure-merging-for-walleye/npm_pikeminnow_org.png", native = TRUE)
map <- readPNG("R/map-making-and-figure-merging-for-walleye/map_white_space_removed.png", native = TRUE)

#combine all 3 pictures into one plot
patch<-wrap_elements(map)/(wrap_elements(walleye)+wrap_elements(npm))+ 
  plot_layout(heights = c(2,1), ncol=1,nrow = 2)

# save the combined file


ggsave(plot = patch, 
       filename = "figs/figure_1.pdf",width = 8,height = 6,units = "in")





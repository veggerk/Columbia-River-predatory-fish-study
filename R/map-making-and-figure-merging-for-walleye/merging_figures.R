library(png)
library(patchwork)
library(ggplot2)

# npm seasons map 
npm_during <- readPNG("R/map-making-and-figure-merging-for-walleye/npm_posterior_density_diet_p_during Salmonid migration.png", native = TRUE)
npm_after <- readPNG("R/map-making-and-figure-merging-for-walleye/npm_posterior_density_diet_p_after Salmonid migration.png", native = TRUE)


npm_season<-wrap_elements(npm_during) / wrap_elements(npm_after)

ggsave(plot = npm_season, 
       filename = "figs/figure_7.pdf",width = 6,height = 7,units = "in")



# walleye seasons map

walleye_before <- readPNG("R/map-making-and-figure-merging-for-walleye/walleye_posterior_density_diet_p_before salmonid migration.png", native = TRUE)
walleye_during <- readPNG("R/map-making-and-figure-merging-for-walleye/walleye_posterior_density_diet_p_during salmonid migration.png", native = TRUE)
walleye_after <- readPNG("R/map-making-and-figure-merging-for-walleye/walleye_posterior_density_diet_p_after salmonid migration.png", native = TRUE)


walleye_season<-wrap_elements(walleye_before) / wrap_elements(walleye_during) / wrap_elements(walleye_after)

ggsave(plot = walleye_season, 
       filename = "figs/figure_4.pdf",width = 6,height = 7,units = "in")

# walleye size plot

walleye_under500 <- readPNG("R/map-making-and-figure-merging-for-walleye/walleye_posterior_density_diet_p_below 500mm.png", native = TRUE)
walleye_over500 <- readPNG("R/map-making-and-figure-merging-for-walleye/walleye_posterior_density_diet_p_above 500mm.png", native = TRUE)


walleye_size<-wrap_elements(walleye_under500) + wrap_elements(walleye_over500) 

ggsave(plot = walleye_size, 
       filename = "figs/figure_3.pdf",width = 7,height = 2,units = "in")


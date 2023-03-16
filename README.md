# walleye-SI-project

This repository is a scientific product and is not official communication of the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All NOAA GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.



This repository has the following structure: 

`\R` folder containing R code

`\R\map-making-and-figure-merging-for-walleye` folder containing R code and files for making figure 1, and merging individual MixSIAR output plots into multiplots for other figures.

`\data\raw data` folder with raw data files

`\data\clean_data` folder with cleaned data files

`\figs` folder with figures
 
`\model output` folder with isospace plots for walleye and northern pikeminnow, and model output and diagnostics for each model. Each model has its own folder within the 'model output' folder.

metadata describing the column names is provided in: `spreadsheet_info.xlsx`

The MixSIAR user manual is: `MixSIAR_user_manual.pdf`



General notes: 

The plots I generated from model results were modified from the standard MisSIAR output, which while nice generally isn't publication ready on it's own. Within the code for the output_JAGS function I modified the ggplot2 code to change how the model generated posterior density plots. This was done in each .rmd file.

MixSIAR can use either averaged prey data, or raw prey data. It makes no difference to the model which you use, as the data is averaged by MixSIAR when it's imported into R anyway. I have both the raw and average prey data in the clean data folder. 

It takes anywhere from a few hours to a few days to run a single model, depending on the model size and the computer you are using. I have included the `.RData` files for each model, this allows you to load the finished model into your R environment without having to wait hours or days to rerun the model.

The `walleye_npm_MixSIAR.Rmd` file contains the mixing models for walleye and northern pikeminnow with no added effects. 

The `walleye_npm_season_effect.Rmd` file contains the mixing models for walleye and northern pikeminnow with season/migration timing effect added. 

The `walleye_npm_size_effect.Rmd` file contains the mixing models for walleye and northern pikeminnow with a continuous size effect added. (note the walleye model failed to converge) 

The `walleye_size_effect_by_group.Rmd` file contains the mixing model for walleye with a fixed size effect added in lieu of a successful continuous size effect. 



# setup ---------------------------------------------------------------
library(tidyverse)
library(agricolae)
library(here)


walleye_prey<-"prey_data_walleye.csv"
npm_prey<-"prey_data_npm.csv"

prey<-"prey_data.csv"
preds<-"predator_data.csv"


## raw file locations
walleye_prey<- here("data/clean_data", walleye_prey)
npm_prey<- here("data/clean_data", npm_prey)
prey<- here("data/clean_data", prey)
preds<- here("data/clean_data", preds)

## pull in files from sub directory
walleye_prey <- read_csv(walleye_prey,
                  na = c("", "NA"))

npm_prey <- read_csv(npm_prey,
                         na = c("", "NA"))

prey <- read_csv(prey,
                         na = c("", "NA"))

preds <- read_csv(preds,
                         na = c("", "NA"))



species_sum<-prey %>%
  group_by(Identifier.2)%>%
  summarize(counts = length(Identifier.2))

colnames(preds)[which(names(preds) == "Identifier 2")] <- "predator"
colnames(prey)[which(names(prey) == "Identifier.2")] <- "Sources"
colnames(npm_prey)[which(names(npm_prey) == "Identifier 2")] <- "Sources"
colnames(walleye_prey)[which(names(walleye_prey) == "Identifier 2")] <- "Sources"



# summary of data collection -----------------------------------------------

counts_prey<-prey%>% count(Sources, sort = TRUE)

counts_pred<-preds%>% count(predator, sort = TRUE)

prey_all<-prey


prey<-prey[!(prey$Sources=="3 Spine Stickleback"|
               prey$Sources=="Catfish"|
             prey$Sources=="Hatchery sockeye"|
  prey$Sources=="Lamprey"|
  prey$Sources=="Perch"|
  prey$Sources=="Sunfish"|
  prey$Sources=="Whitefish"|
  prey$Sources=="Wild coho"|
  prey$Sources=="Wild sockeye"),]



#prey ANOVAS for possible prey species, 
# species deemed to not be prey items excluded

#run ANOVA 


avnitrogen <- aov(formula = d15N ~ Sources,
                  data = prey)
#summarize ANOVA 
summary(avnitrogen)
#run Tukey test 
tukeynitrogen<-HSD.test(y=avnitrogen,trt = "Sources")
tukeynitrogen


#run ANOVA 
avcarbon <- aov(formula = d13C ~ Sources,
                  data = prey)
#summarize ANOVA 
summary(avcarbon)
#run Tukey test 
tukeycarbon<-HSD.test(y=avcarbon,trt = "Sources")
tukeycarbon

# some quick plots to look at the prey groupings, starting with everything, subset down to prey 
# to include in model, to grouped prey categories. crayfish are included for NPM, 
# as they were a common prey item from the prior: Poe et al. 



prey_all<-prey_all[!(prey_all$Sources=="Lamprey"),]


avg_prey_all<-prey_all%>% 
  group_by(Sources)%>%
  summarise(mean(d13C), mean(d15N))

colnames(avg_prey_all)[which(names(avg_prey_all) == "mean(d13C)")] <- "d13C"
colnames(avg_prey_all)[which(names(avg_prey_all) == "mean(d15N)")] <- "d15N"


ggplot(data=avg_prey_all, aes(x=d13C, y=d15N, colour=Sources))+
  geom_point()





avg_prey<-prey%>% 
  group_by(Sources)%>%
  summarise(mean(d13C), mean(d15N))

colnames(avg_prey)[which(names(avg_prey) == "mean(d13C)")] <- "d13C"
colnames(avg_prey)[which(names(avg_prey) == "mean(d15N)")] <- "d15N"


ggplot(data=avg_prey, aes(x=d13C, y=d15N, colour=Sources))+
  geom_point()



grouped_names<-c("American shad",
                 "mixed",
                 "mixed",
                 "yearling",
                 "subyearling",
                 "yearling",
                 "mixed",
                 "mixed",
                 "mixed",
                 "yearling",
                 "subyearling",
                 "yearling")

avg_prey_grouped<-cbind(avg_prey,grouped_names)

ggplot(data=avg_prey_grouped, aes(x=d13C, y=d15N, colour=grouped_names))+
  geom_point()



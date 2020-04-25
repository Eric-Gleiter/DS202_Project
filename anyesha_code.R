# if (!require("tidyverse")) {
#   install.packages("tidyverse")
# }
# if (!require("openintro")) {
#   install.packages("openintro")
# }
# if (!require("lubridate")) {
#   install.packages("lubridate")
# }
# if (!require("maps")) {
#   install.packages("maps")
# }
# if (!require("plotly")) {
#   install.packages("plotly")
# }
# library(plotly)
# library(tidyverse)
# library(openintro) #used to quickly switch state names and abbrevations
# library(maps)
# library(lubridate)
# 
# 
# severityDS <- read.csv("Severity.csv")
# start_timeDS <- read.csv("Start_Time.csv")
# end_timeDS <- read.csv("End_Time.csv")
# latDS <- read.csv("Start_Lat.csv")
# longDS <- read.csv("Start_Lng.csv")
# cityDS <- read.csv("City.csv")
# countyDS <- read.csv("County.csv")
# stateDS <- read.csv("State.csv")
# tempDS <- read.csv("Temperature.csv")
# windDS <- read.csv("Wind_Speed.csv")
# visibiltyDS <- read.csv( "Visibilty.csv")
# startDayDS <- read.csv("Start_Day.csv")
# startYearDS <- read.csv("Start_Year.csv")
# startMonthDS <- read.csv("Start_Month.csv")
# endDayDS <- read.csv("End_Day.csv")
# endYearDS <- read.csv("End_Year.csv")
# endMonthDS <- read.csv("End_Month.csv")
# 
# 
# 
# 
# 
# 
# 
# fullData <- severityDS %>%
#   inner_join(start_timeDS) %>%
#   inner_join(end_timeDS) %>%
#   inner_join(latDS) %>%
#   inner_join(longDS) %>%
#   inner_join(cityDS) %>%
#   inner_join(countyDS) %>%
#   inner_join(stateDS) %>%
#   inner_join(tempDS) %>%
#   inner_join(windDS) %>%
#   inner_join(visibiltyDS) %>%
#   inner_join(startMonthDS) %>%
#   inner_join(startYearDS) %>%
#   inner_join(startDayDS) %>%
#   inner_join(endYearDS) %>%
#   inner_join(endDayDS) %>%
#   inner_join(endMonthDS) %>%
#   select(-X) #deletes a column that is row number


# ##Code 
# fullCounties <- map_data("county")
# 
# 
# fullMapData <- fullData %>% 
#   mutate(region = tolower(abbr2state(State))) %>%
#   mutate(subregion = tolower(County)) %>%
#   select(region, subregion,Severity) %>%
#   group_by(region,subregion) %>%
#   summarise(meanSeverity = mean(Severity)) %>%
#   right_join(fullCounties,by=c("region","subregion"))
# 
# ggplot(fullMapData, aes(x=long,y=lat,fill = meanSeverity))+
#   geom_polygon(aes(group=group)) +
#   labs(x="Longitude",y="Latitude",title = "Severity of Accidents in US by County")
# 

###Safety Score###
speed <- read.csv("Speed.csv")
colnames(speed)[1] <-"State"

drunk <- read.csv("Drinking.csv")


joined=  speed %>% inner_join(drunk)


# fullMapData <- fullData %>% 
#   mutate(region = tolower(abbr2state(State))) %>%
#   select(region ,Severity) %>%
#   group_by(region) %>%
#   summarise(meanSeverity = mean(Severity)) 
# 
statesev=fullMapData[!duplicated(fullMapData$region), ]
colnames(statesev)[1] <-"State"
statesev = subset(statesev, select = -c(order) )


#join joined and statesev
statesev$State=tolower(statesev$State)
joined$State=tolower(joined$State)


fulljoined=  joined %>% inner_join(statesev)
fulljoined = subset(fulljoined, select = -c(2:5) )


addingjoin=fulljoined[c(2,3,5)]

fulljoined=cbind(fulljoined, total = rowSums(addingjoin))

states <- map_data("state")

test <- fulljoined %>% 
  mutate(region = State) %>%
  select(region,total,group) %>%
  group_by(region) %>%
  right_join(states,by=c("region"))


ggplot(test, aes(x=long,y=lat,fill = total))+
  geom_polygon(aes(group=region)) +
  labs(x="Longitude",y="Latitude",title = "Safety Score of States")

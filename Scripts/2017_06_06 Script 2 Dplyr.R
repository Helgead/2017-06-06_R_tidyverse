gapminder
#testing to make sure gapminder is still present in this new script (and it is)

#pipe allows you to string a series of functions together, so output of first function is
#used as input for the second function (pipe symbol is %>% which is shift+cntrl+M)

#repeating an output three times
rep("This is an example", times=3)

#can use a pipe instead, so we piped the message into the repeat function
"This is an example" %>% rep(times=3)

# <- makes a new object, and select from gapminder only the columns year, country and gdpPercap
year_country_gdp <- select(gapminder, year, country, gdpPercap)
#can see another object added to the global environment tab (year_country_gdp)

#run the object to see the output in console, can see only three columns are returned
year_country_gdp

#head takes the header of the columns of the object, so only the top few rows are shown
head(year_country_gdp)

#this is the same, we make a new object (same as above one) but use a pipe on the gapminder
#dataset, so we only need the select function after the pipe
year_country_gdp <- gapminder %>% select(year, country, gdpPercap)

#piped gapminder to filtering for year 2002, then piped that to ggplotting so we can make
#a boxplot of continent and population
gapminder %>% filter(year==2002) %>% 
  ggplot(mapping=aes(x=continent, y=pop))+
  geom_boxplot()

#challenge filter for norway and gdp,lifeexp,year
gdp_lifeexp_year_nor <- gapminder %>% filter(country=="Norway") %>% 
  select(gdpPercap, lifeExp, year)

#run to check
gdp_lifeexp_year_nor

#group by a certain variable in your table (continent in this case)
gapminder %>% group_by(continent)

#we group by continent, but pipe it to a summary where we calculate the mean gdppercap for
#each continent
gapminder %>% group_by(continent) %>% summarize(mean_gdpPercap=mean(gdpPercap))

#series of pipes to plot the mean gdp of each continent from the gapminder dataset
gapminder %>% 
  group_by(continent) %>% 
  summarize(mean_gdp=mean(gdpPercap)) %>% 
  ggplot(mapping=aes(x=continent, y=mean_gdp))+
  geom_point()


#challenge calc average lifeexp per country in asia
#the | symbol means or, so we filter for min or max mean lifeexp (works more like and, not or)
#so we filter for asia, then group by country, summarize the mean life expectancies, 
#then filter again for the country with lowest and highest life expectancy (afghanistan and
#japan)
gapminder %>% filter(continent=="Asia") %>% 
  group_by(country) %>% 
  summarize(mean_lifeexp=mean(lifeExp)) %>% 
  filter(mean_lifeexp==min(mean_lifeexp)|mean_lifeexp==max(mean_lifeexp))
#can also do a plot of the means in order to visually see the country with highest and
#lowest mean life expectancy, here we show all countries, not just the min and max
gapminder %>% filter(continent=="Asia") %>% 
  group_by(country) %>% 
  summarize(mean_lifeexp=mean(lifeExp)) %>% 
  ggplot(mapping=aes(x=country, y=mean_lifeexp))+
  geom_point()+
  coord_flip()
#copied above and used Europe instead for personal interest
gapminder %>% filter(continent=="Europe") %>% 
  group_by(country) %>% 
  summarize(mean_lifeexp=mean(lifeExp)) %>% 
  ggplot(mapping=aes(x=country, y=mean_lifeexp))+
  geom_point()+
  coord_flip()
#same as previous, but now africa
gapminder %>% filter(continent=="Africa") %>% 
  group_by(country) %>% 
  summarize(mean_lifeexp=mean(lifeExp)) %>% 
  ggplot(mapping=aes(x=country, y=mean_lifeexp))+
  geom_point()+
  coord_flip()
#same but americas
gapminder %>% filter(continent=="Americas") %>% 
  group_by(country) %>% 
  summarize(mean_lifeexp=mean(lifeExp)) %>% 
  ggplot(mapping=aes(x=country, y=mean_lifeexp))+
  geom_point()+
  coord_flip()

#use the mutate function to generate another column of information, where we multiply gdp
#per capita by the population and divide by billion (to get in billions)
gapminder %>% 
  mutate(gdp_billion=gdpPercap*pop/10^9) %>% 
  head()

#we mutate in gdp in billions and also group by continent and year, then calculate
#the mean gdp in billions (for each continent each year)
gapminder %>% 
  mutate(gdp_billion=gdpPercap*pop/10^9) %>% 
  group_by(continent,year) %>% 
  summarize(mean_gdp_billion=mean(gdp_billion))

#need to load the maps package before continuing
library(maps)

#we open map data for entire world, then pipe it to show the top of the data
map_data("world") %>% 
  head()

#create a new object to be used for the next step
gapminder_country_summary <- gapminder %>%
  group_by(country) %>% 
  summarize(mean_lifeexp=mean(lifeExp))

#start by renaming the region variable from the data to country instead of region
#we join together data from gapminder (our new object gapminder_country_summary) with 
#the maps longitude and latitude dataset, by country, so that we get a colored map of the mean life expectancy
#where red is high exp, and blue is low
#so the lat and long create borders for each country, then we link our country dataset
#to the countries using coloured fill based on mean life expectancy
map_data("world") %>% 
  rename(country=region) %>% 
  left_join(gapminder_country_summary, by="country") %>% 
  ggplot()+
  geom_polygon(aes(x=long, y=lat, group=group,fill=mean_lifeexp))+
  scale_fill_gradient(low="blue", high="red")+
  coord_equal()
#the US doesnt show up as one dataset uses United States of America while other dataset
#uses USA (or something like this) so that R is unable to link them together as the same 
#country, this happens for multiple countries as some countries are not colored in on the
#map (US, Russia, England etc)

#challenges from earlier can be found at https://github.com/dmi3kno/SWC-tidyverse/blob/master/01-ggplot2.Rmd


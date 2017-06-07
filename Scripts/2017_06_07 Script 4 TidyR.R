#07_06_2017 Day 2
#downloading a file called gapminder_plus for todays work
download.file(url = "https://raw.githubusercontent.com/dmi3kno/SWC-tidyverse/master/data/gapminder_plus.csv", 
              destfile = "Data/gapminder_plus.csv")

#need to load tidyverse package as it automatically turns off after each session
library("tidyverse")

#loading the excel into R
gapminder_plus <- read_csv(file="Data/gapminder_plus.csv")

#quickliy seeing the data in the console, it is the gapminder data that we used yesterday added to
#the infant mortality and fertility data that we joined together yesterday (todays file was done
#by the teachers, so its one file with all the information)
gapminder_plus

#challenge
#can also do >= instead of == for more or equal to
#must use 2e6 in the filter, it did not work with 2^6, whereas it works fine in mutate (??)
#View() allows you to open data as a spreadsheet
#Gather will take each variable into an own row with each of the different values
#Gather, key and value are names for the new columns, c() selects which columns you use (can write 
#all the names of the columns you want, so year, infMort, fert etc) or specify the negative -c() where
#you specify which variables you do not want to alter under the gather
#need to do scales ="free_y" in order to free the y scales so that they can differ between the different
#facets, we also deselct -c() continent, pop and babiesdead to look like the teachers graph
#moved the mapping and aes into the geom_line instead of ggplot, and we facet by variables
#for labels, doing y=NULL will mean there will be no y axis labelling
#theme_ is another function for graphs, how it will look (multiple choices)
#theme() allows you to modify a theme, so legend.position="none" removes the legend from the graph
#(.) is a placeholder for all data above, so either leave ggplot() blank or can put a . in there
#not specifying anything is default data=. (the output of the pipe will be "dropped" at the .)
#geom_text is used to insert text into the graph, and here we need to find the max values per facet
#for the variable measured in the last year (2007)
#so we take the data=. and filter for 2007, then group by variables, then mutate a max value for each
#and filter for max values and add the aesthetic with the label being country and colored as the
#country lines are
gapminder_plus %>% filter(continent=="Africa", year=="2007") %>% 
  mutate(babiesdead=infantMort*pop/10^3)%>% 
  filter(babiesdead>2e6) %>% 
  select(country) %>% left_join(gapminder_plus) %>% 
  mutate(babiesdead=infantMort*pop/10^3, gdpbln=gdpPercap*pop/1e9, popmln=pop/1e6) %>%
  select(-c(continent, pop, babiesdead)) %>% 
  gather(key=variables, value=values, -c(country, year)) %>% 
  ggplot()+
  geom_text(data=. %>% filter(year==2007) %>% group_by(variables) %>% 
              mutate(max_value=max(values)) %>% 
              filter(values==max(values)), aes(x=year, y=values, label=country, color=country))+
  geom_line(mapping=aes(x=year, y=values, color=country))+
  facet_wrap(~variables, scales="free_y")+
  labs(title="Challenge", subtitle="completed", caption="perfect", y=NULL, x="Year")+
  theme_bw()+
  theme(legend.position="none")

#saving the last plot made
ggsave("challenge_facet_plot.png")



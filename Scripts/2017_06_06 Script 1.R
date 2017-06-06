#loading the package tidyverse
library("tidyverse")
#loading the data we downloaded from github (made by course)
#github.com have own profile Helgead, copied from course profile to own by
#forking it, used clone or download to get website to use when creating new project
#that was a version control and using Git
read_csv(file = "Data/gapminder-FiveYearData.csv")
#only write Data as it is a subfolder of this current project, dont need full
#length of pathway (D:// etc)

#create new object "gapminder" that will now run the read_csv script
gapminder <- read_csv(file = "Data/gapminder-FiveYearData.csv")
#now gapminder appears in the top right under environment

#just typing gapminder should now output the same as read_csv
gapminder

#ggplot to plot data, using gapminder as data source, then + to start next
#line where we choose point mapping, and mapping is aesthetic (aes) then we
#identify the x and y variables to be used (gdpPercap and lifeExp as found in
#the table of our data)
#geom stands for geometrical, so a geometrical representation of data
#mapping maps the geometrical properties from the data into the visual representation (the 
#aesthetics or aes)
ggplot(data = gapminder)+
  geom_point(mapping=aes(x=gdpPercap, y=lifeExp))

#change to jitter plot, and add third variable, coloring by continent
ggplot(data = gapminder)+
  geom_jitter(mapping=aes(x=gdpPercap, y=lifeExp, color=continent))

#change back to point plot, and now use log of gdp and add another variable which is
#size so the larger points belong to largest populations
#can have two dimensions, the third isnt allowed, can use color and size instead
ggplot(data = gapminder)+
  geom_point(mapping=aes(x=log(gdpPercap), y=lifeExp, color=continent, size=pop))

#moved additional variables outside of aesthetics but still inside geom_point
#this will apply to all variables, alpha changes transparency, size changes the size and 
#color changes the color of all points
ggplot(data = gapminder)+
  geom_point(mapping=aes(x=log(gdpPercap), y=lifeExp),alpha=0.1, size=2, color="blue")

#line plot, grouped together the point for each country and colored by continent
ggplot(data = gapminder)+
  geom_line(mapping=aes(x=log(gdpPercap), y=lifeExp, group=country, color=continent))

#same as above but changed the x variable to year, so we see life expectancy over time
#with some countries showing a sharp decline (war or natural disaster perhaps)
ggplot(data = gapminder)+
  geom_line(mapping=aes(x=year, y=lifeExp, group=country, color=continent))

#boxplotting continent and life expectation, shows average and outliers
ggplot(data = gapminder)+
  geom_boxplot(mapping=aes(x=continent, y=lifeExp))

#plotting two types of plots of the same data at once, the order in which you place each
#decides which plot is overlayed onto the other (so here jitter lies under boxplot)
ggplot(data = gapminder)+
  geom_jitter(mapping=aes(x=continent, y=lifeExp, color=continent))+
  geom_boxplot(mapping=aes(x=continent, y=lifeExp, color=continent))

#this does exactly the same as the previous one, but now the info is at the top so it is
#used for everything you write below, in this case, the two plots, with empty brackets
#as they will both use the same mapping
#"lift" the common data one layer up so all subsequent layers will use the same info
ggplot(data = gapminder,mapping=aes(x=continent, y=lifeExp, color=continent))+
  geom_jitter()+
  geom_boxplot()
#jitter will move the points randomly each time you run it, it spreads points so they are
#more visible, hence running the two versions above of the same script, the points of the 
#jitter will likely not be the same, but this is normal, as the x and y values shouldnt 
#fluctuate but jitter makes them spread out

#make all points of jitter transparent, but its only specific to the jitter plot
#smooth plot splits for each continent
ggplot(data = gapminder,mapping=aes(x=log(gdpPercap), y=lifeExp, color=continent))+
  geom_jitter(alpha=0.1)+
  geom_smooth(method="lm")

#hide the continent coloring so that it doesnt show up in the smooth plot, need mapping and
#aes in jitter now to get it plotted, now the smooth plot isnt split up by continent coloring
#only one smooth line for all data
ggplot(data = gapminder,mapping=aes(x=log(gdpPercap), y=lifeExp))+
  geom_jitter(mapping=aes(color=continent), alpha=0.1)+
  geom_smooth(method="lm")


#challenge make a boxplot of life exp by year
#may need to use as.factor or as.character to collect year
ggplot(data = gapminder)+
  geom_boxplot(mapping=aes(x=as.factor(year), y=lifeExp))
#challenge make same boxplot but with log of gdpPercap
ggplot(data = gapminder)+
  geom_boxplot(mapping=aes(x=as.factor(year), y=log(gdpPercap)))

#challenge make density2 and see how many point grouping you find (2)
ggplot(data = gapminder)+
  geom_density2d(mapping=aes(x=lifeExp, y=log(gdpPercap)))

#can ask for x log scaling outside of common info
#facet wrap will seperate (split) by continent so you get seperate graphs for each continent
#so continents split into seperate facets, wrap means it wraps them so in this case
#three facets per row
ggplot(data = gapminder,mapping=aes(x=gdpPercap, y=lifeExp))+
  geom_point()+
  geom_smooth()+
  scale_x_log10()+
  facet_wrap(~continent)


#challenge try faceting by year, keeping the linear smoother (linear model "lm") is there
#any change in slope over the years?  also try by continent
ggplot(data = gapminder,mapping=aes(x=gdpPercap, y=lifeExp))+
  geom_point()+
  geom_smooth(method="lm")+
  scale_x_log10()+
  facet_wrap(~year)

ggplot(data = gapminder,mapping=aes(x=gdpPercap, y=lifeExp))+
  geom_point()+
  geom_smooth(method="lm")+
  scale_x_log10()+
  facet_wrap(~continent)

#this will filter the gapminder data to only find data from the year 2007, part of the 
#data will appear below in the console
filter(gapminder, year==2007)

#can wrap it into the ggplot and have the input data filtered so only 2007 is used
ggplot(data=filter(gapminder, year==2007))+
  geom_bar(mapping=aes(x=continent))
#as we didnt define the y variable, R made its own variable which is count, so it is likely
#counting how many countries fall under each continent

#here we spelled it out so we get the same plot R made automatically 
ggplot(data=filter(gapminder, year==2007))+
  geom_bar(mapping=aes(x=continent), stat="count")

#can filter by multiple filters at once, so here 2007 for only Oceania continent
filter(gapminder, year==2007, continent=="Oceania")

#make a barchart of country and population after filtering for 2007 and oceania and 
#using the stat identity, meaning dont do anything with the data, so it is plotted
#as is
ggplot(data=filter(gapminder, year==2007, continent=="Oceania"))+
  geom_bar(mapping=aes(x=country, y=pop), stat="identity")


#try same but filter for Asia instead of Oceania, using col plot which automatically
#sets stat to identity
ggplot(data=filter(gapminder, year==2007, continent=="Asia"))+
  geom_col(mapping=aes(x=country, y=pop))

#above gave very messy representation, can flip coordinates so x and y flips
ggplot(data=filter(gapminder, year==2007, continent=="Asia"))+
  geom_col(mapping=aes(x=country, y=pop))+
  coord_flip()

#changing the labels of the graph (labels where we use labs)
#title for main title, subtitle for subtitle just below title, caption for below the graph
#can rename all variables, so x, y, color, size can all be renamed
ggplot(data = gapminder,mapping=aes(x=gdpPercap, y=lifeExp, color=continent, size=pop/10^6))+
  geom_point()+
  scale_x_log10()+
  facet_wrap(~year)+
  labs(title="Life Expectancy vs GDP per capita over time", subtitle="In the last 50 years, life expectancy has mostly improved globally"
       ,caption="Source:Gapminder foundation, gapminder.com", x="GDP per capita, ($ in thousands)",
       y="Life expectancy in years", color="Continent", size="Population in millions")

#saving the last plot you made, updates if you change the script so it is updated, instead of
#rightclicking or exporting the image purely by itself
ggsave("Life_exp_vs_GDP_plot.png")

#playing around on my own with the gapminder dataset
ggplot(data = filter(gapminder, continent=="Oceania"), mapping=aes(x=gdpPercap, y=lifeExp, color=country))+
  geom_point()+
  scale_x_log10()+
  facet_wrap(~year)
  
 gapminder

 
  
  

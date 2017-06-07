#creating a vector that will have the value of 30, it also appears under the environment as a value
x <- 5*6

#check the value by running x
x

#asking R if x is a vector, in the console it will say TRUE, and asking length of x which gives 1 in the
#console as its 1 value
is.vector(x)
length(x)

#specifying the second position of the x vector (which is at this point empty) using brackets []
x[2] <- 31

#when we now check x, we are returned two values, 30 and 31, so the vector has two values (its updated
#under the environment)
x

#adding value to the fifth position
x[5] <- 42

#running it now will show NA (missing data) between the second value and the fifth, does not add
#0 as this would be values, so NA will be used
x

#checking position 11 will yield NA as well as there is no value here either, and checking position 0
#yields numeric(0) which basically means does not exist, as R starts values at position 1
x[11]
x[0]

#this command will input x values as values from 1 to 4 including the numbers between, it will also
#override the previous values
x <- 1:4

#we create an equation that will take each value of x to the power of 2 and apply these values to y
#as can be seen in the environment
y <- x^2

#a more complicated and heavy method of getting the same result as for y
z <- vector(mode=mode(x), length=length(x))
for(i in seq_along(x)) {
  z[i] <- x[i]^2
}
z

#override so the two vectors are the same size but differnt numbers and try x+y which checks position
#and adds position 1 of x to position 1 of y etc
x <- 1:5
y <- 3:7
x+y

#we remove the fifth value, not the number 5 value, but the value in the fifth postion (7)
z <- y[-5]
#this will yield a warning as one object is shorter than the other, but its becuase its not in multiples
#as R recycles, so if one was 5 long and the other 10, the 5 long one would be recycled
x+z
#as shown below, we make z 10 long and add it to x which is 5, and can see that despite one only being
#5 long it still yields a result due to recycling
z <- 1:10

x+z

#coersion allows you to make vectors containing characters, so here we make a vector containing
#the three characters or strings, adding str in front allows you to count as well as see the
#nature of your info, so chr for the first one, num for the second, and chr again for the third
#even though numbers and characters are mixed together with logical statements, while for the fourth
#it changes the logical output from True to 1 (if you do pi < 3 instead you get 0 instead of false)
#in the fifth we say L to force integers (no decimals) to get int as type
c("Hello", "workshop", "participants!")
str(c("Hello", "workshop", "participants!"))

c(9:11, 200, x)
str(c(9:11, 200, x))

c("number", pi, 2:4, pi > 3)
str(c("number", pi, 2:4, pi > 3))

c(pi, 2:4, pi > 3)
str(c(pi, 2:4, pi > 3))

str(c(2L:4L, pi > 3))

#randomized numbers (10 of them), then we check which(w<o) to find the positions of values that in the
#w vector are less than 0, then with w[which()] is used to show the values of the positions where w was
#less than 0, can also do this with w[w<0]
w <- rnorm(10)
seq_along(w)
w
which(w < 0)
w[which(w<0)]
w[w<0]

#remove two values
w
w[-c(2, 5)]

#for different values instead of vectoring, where values are given the common type, we make lists,
#when we now look at the structure (str) we get a list and the type of value for each as well, for 
#the 2:4 it first lists [1:3] which means the numbers 2 3 4 are in positions 1 2 3 in regards to
#one another (not the rest of the list)
list("something", pi, 2:4, pi>3)
str(list("something", pi, 2:4, pi>3))


list(vegetable="cabbage", number=pi, series=2:4, telling=pi>3)
x <- list(vegetable="cabbage", number=pi, series=2:4, telling=pi>3)
str(x)

#using the $ sign will give a dropdown and you use it to find values for a certain variable
x$vegetable
x[1]
str(x$vegetable)
str(x[1])

x[3]
x[[3]]
str(x[3])
str(x[[3]])

#making lists can be very complicated and can contain lists within lists
x <- list(vegetable=list("cabbage", "carrot", "spinach"), number=list(c(pi, 0, 2.14, NA)), 
          series=list(list(2:4, 3:5)), telling=pi>3)
str(x)
x$vegetable
str(x$vegetable)

#square brackets gives you the info but with the package around, $ gets you just the inside or if you
#do double square brackets, but thats more work than just $

#produce a linear model from gapminder_plus into a list, with lifeExp against gdpPercap
mod <- lm(lifeExp ~gdpPercap, data=gapminder_plus)
mod
str(mod)

mod$df.residual
str(mod$df.residual)

str(mod$qr)
mod$qr$qr[1,1]

#make a list of each continent and average life expectancy, min and max values for life expectancy
gapminder_plus %>% group_by(continent) %>% summarize(mean_le=mean(lifeExp), min_le=min(lifeExp), max_le=max(lifeExp))

#years and life expectancy of all countries coloured by continent
gapminder_plus %>% 
  ggplot()+
  geom_line(mapping=aes(x=year, y=lifeExp, color=continent, group=country))
#facet wrap by continent to make it more clear and add a smooth lm line for the average trend
gapminder_plus %>% 
  ggplot()+
  geom_line(mapping=aes(x=year, y=lifeExp, color=continent, group=country))+
  geom_smooth(mapping=aes(x=year, y=lifeExp), method="lm", color="black")+
  facet_wrap(~continent)

#nest() function compresses the data from continent and country so that it is expressed as lists
by_country <- gapminder_plus %>% group_by(continent, country) %>% 
  nest()
#cant use $ as there is no name for what we are looking for (first of the by_country list)
by_country$data[[1]]


#map(list, function) with map you specify a list and a function, this allows you to apply any function
#of your choice to an entire list (can use apply as well, map will always return a list)
map(1:3, sqrt)

#~specifies where the function starts, and .x where the output will end up
model_by_country <- by_country %>% mutate(model=map(data, ~lm(lifeExp~year, data=.x))) %>% 
  mutate(summr=map(model, broom::glance))

model_by_country

#to specifiy commands from a package (that has the same name as another packages command) you write
#the package name :: command (ex. purrr::map) it also allows you to call commands from packages
#that you have not loaded

model_by_country$summr[[1]]

#adding unnest unwraps the list so contents are shown in the console list
model_by_country <- by_country %>% mutate(model=map(data, ~lm(lifeExp~year, data=.x))) %>% 
  mutate(summr=map(model, broom::glance)) %>% unnest(summr)
model_by_country
#arrange command allows you to arrange the list on a variable (in this case the r.squared or the
#fit of observed to expected)
model_by_country <- by_country %>% mutate(model=map(data, ~lm(lifeExp~year, data=.x))) %>% 
  mutate(summr=map(model, broom::glance)) %>% unnest(summr) %>% 
  arrange(r.squared)
model_by_country

#this following script has unearthed more statistical information and unnested it so it could be 
#used to generate a new graph of variations from the continents' overall life expectancy, so we
#get out a list of the most deviating nations, indicating sharpest drops in life expectancy
#which could be due to war etc, and it is joined into the original data so we can get a graph of 
#the timeline etc relating to the nations we looked at
by_country %>% mutate(model=map(data, ~lm(lifeExp~year, data=.x))) %>% 
  mutate(summr=map(model, broom::glance)) %>% unnest(summr) %>% 
  arrange(r.squared) %>% 
  filter(r.squared<0.3) %>% select(country) %>% left_join(gapminder_plus) %>% 
  ggplot()+
  geom_line(mapping=aes(x=year, y=lifeExp, color=country, group=country))
#this allowed us to go from a graph with huge amounts of data to a much smaller data load so
#that we can more easily analyze data towards something meaningful

gapminder_plus %>% 
  ggplot()+
  geom_line(mapping=aes(x=log(gdpPercap), y=lifeExp, color=continent, group=country))
  

by_country %>% mutate(model=map(data, ~lm(lifeExp~log(gdpPercap), data=.x))) %>% 
  mutate(summr=map(model, broom::glance)) %>% unnest(summr) %>% 
  arrange(r.squared) %>% 
  filter(r.squared<0.1) %>% select(country) %>% left_join(gapminder_plus) %>% 
  ggplot()+
  geom_point(mapping=aes(x=log(gdpPercap), y=lifeExp, color=country))
#arrows under plots allows you to go back and forth between previous plots
  
#how to save data, shows up under files tab, can be sent to others
saveRDS(by_country, "by_country_tibble.rds")
#can then be opened as an object you read in by reading the file
my_new_by_country <- readRDS("by_country_tibble.rds")
my_new_by_country
#can save as a csv file as well, which can be sent and opened in other programs than R
write_csv(gapminder_plus, "gapminder_plus_to_send.csv")

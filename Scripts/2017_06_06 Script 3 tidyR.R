#recieved a code to insert from the course etherpad, simply copy pasted into R and run
#downloads files

download.file(url = "http://docs.google.com/spreadsheet/pub?key=phAwcNAVuyj0TAlJeCEzcGQ&output=xlsx", 
              destfile = "Data/indicator gapminder infant_mortality.xlsx")

download.file(url = "http://docs.google.com/spreadsheet/pub?key=phAwcNAVuyj0NpF2PTov2Cw&output=xlsx", 
              destfile = "Data/indicator undata total_fertility.xlsx")

#did not work, had to go to gapminder.org data section and manually download the two files and save
#them under the Data folder of this project

#need to load the package enabling R to open and read excel documents
library("readxl")

#create two new objects that contain the data of the excel files called raw_fert for the raw fertility
#data, and raw_infantMort for the raw infant mortality data
#need to ensure the path is correct compared to where the excels are saved, and for the fertility
#file the correct sheet must be chosen
raw_fert <- read_excel(path="Data/indicator undata total_fertility.xlsx", sheet="Data")

raw_infantMort <- read_excel(path="Data/indicator gapminder infant_mortality.xlsx")
#we can either specify which sheet to read from, if not specified, it defaults to reading the first
#sheet of the excel file

#check that the data has been properly loaded into R
raw_fert
raw_infantMort

#tidyR is used to tidy up data, as information from excel sheets often are not prepared in a fashion
#that allows us to use it in R straight away
#raw_fert f.ex is in the wide format, so we need to pair each year with each country
#tidyR package has a function to tidy up raw data

#create new tidied object, take raw_fert and rename the Total fertility rate using backticks (shift+\),
#but could also just copy paste from the console output instead
#we then gather using the key we name year, and the value named fert, for all but our country variable
#then mutate year so it is shown as an integer
fert <- raw_fert %>% 
  rename(country=`Total fertility rate`) %>% 
  gather(key=year, value=fert, -country) %>% 
  mutate(year=as.integer(year))

#check that we have succesfully tidied up the raw data in a format R should be able to use, the list 
#should be each country having seperate years with their proper values
fert



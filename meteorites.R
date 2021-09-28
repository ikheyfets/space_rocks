# Importing Data
meteorite.landings = read.csv('meteorite-landings.csv')

# Cleaning data 
library(dplyr, tidyverse)

meteorite.landings <- as_tibble(meteorite.landings)
meteorite.landings <- filter(meteorite.landings, year >= 860 & year <= 2016)
meteorite.landings <- filter(meteorite.landings, reclat != 0 | reclong !=0)
meteorite.landings <- drop_na(meteorite.landings, mass)
meteorite.landings <- filter(meteorite.landings, mass > 0)

# Categorical Variable Analysis
# Variable: Fall
library(UsingR)

table(meteorite.landings$fall)

barplot(table(meteorite.landings$fall),
    ylim = c(0,31000),
    ylab = 'Count',
    xlab = 'Observation Type',
    main = 'Meteorite Observations',
    col = 'cyan'
    )

slice.labels<- c('Observed During Fall - ', 'Found on the Ground - ')
slice.percents <- round(table(meteorite.landings$fall)/sum(table(meteorite.landings$fall))*100)
slice.labels <- paste(slice.labels, slice.percents, '%', sep = '')
pie(table(meteorite.landings$fall),
    labels = slice.labels,
    col = hcl(c(180, 60))
)

# Numerical Variable Analysis
# Variable: Mass
m = meteorite.landings$mass

mean(m)
median(m)
which(table(m) == max(table(m)))
diff(range(m))
min(m)
max(m)
summary(m)
quantile(m, c(0, 0.25, 0.5, 0.75, 1))
IQR(m)

hist(m, 
     breaks = seq(0,60000000,100000),
     main = 'Histogram of Meteorite Mass',
     ylab = 'Count',
     ylim = c(0, 35000),
     xlab = 'Meteorite Mass (g)',
     xlim = c(0, 60000000)
     )

hist(m, 
     breaks = seq(0,60000000,10),
     main = 'Histogram of Meteorite Mass (1st to 3rd Quartiles)',
     ylab = 'Count',
     ylim = c(0, 10000),
     xlab = 'Meteorite Mass (g)',
     xlim = c(6, 200)
)

# Bivariate Data Analysis
# Variables: nametype, fall
x = table(meteorite.landings$fall, meteorite.landings$nametype)
x = as.matrix(x)
row1 = c(0, 1064)
names(row1) = c('Relict', 'Valid')
row2 = c(3, 30844)
x = rbind(Fell = row1, Found = row2)
tmp1 = c('Fell','Found')
tmp2 = c('Relict', 'Valid')
dimnames(x) = list(Observation = tmp1, condition = tmp2)
x
addmargins(x)
mosaicplot(x, color = c('red','cyan'), main = 'NASA Meteorite Landings Dataset')
barplot(x, col = c('red','cyan'), main = 'NASA Meteorite Landings Dataset', legend.text = TRUE)

# Sampling
# Variable: Year
library(sampling)

x = c()
k = 10000
sample.size = 100
for (i in 1:k) {
  x[i] = mean(sample(meteorite.landings$year, sample.size, replace = TRUE))
}
hist(x,
     main = 'Sample size = 100',
     xlab = 'Mean Year',
     col = 'cyan')
abline(v = mean(x), col = "Red")


x = c()
k = 10000
sample.size = 1000
for (i in 1:k) {
  x[i] = mean(sample(meteorite.landings$year, sample.size, replace = TRUE))
}
hist(x,
     main = 'Sample size = 1000',
     xlab = 'Mean Year',
     col = 'cyan')
abline(v = mean(x), col = "Red")

x = c()
k = 10000000
sample.size = 10000
for (i in 1:k) {
  x[i] = mean(sample(meteorite.landings$year, sample.size, replace = TRUE))
}
hist(x,
     main = 'Sample size = 10000',
     xlab = 'Mean Year',
     col = 'cyan')
abline(v = mean(x), col = "Red")

# Sampling Methods
# Simple with replacement 
s <- srswr(100, nrow(meteorite.landings))
rows <- (1:nrow(meteorite.landings))[s != 0]
rows <- rep(rows, s[s != 0])
simple.sample.replacement = meteorite.landings[rows, ]
head(simple.sample.replacement)

# Simple with replacement 
s <- srswor(100, nrow(meteorite.landings))
simple.sample.no.replacement = meteorite.landings[s != 0, ]
head(simple.sample.no.replacement)

#Systematic Sampling
N = nrow(meteorite.landings)
n = 100
k = ceiling(N/n)
r = sample(k, 1)
rows = seq(r, by = k, length = n)
systematic.sample = meteorite.landings[rows, ]
systematic.sample = drop_na(systematic.sample)
head(systematic.sample)

# Additional Features
library(ggplot2, sf)
theme_set(theme_bw())
library("rnaturalearth")
library("rnaturalearthdata")

world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)
ggplot(data = world) + geom_sf() + geom_point(data = meteorite.landings, 
                                              mapping = aes(x = reclong, y = reclat),
                                              colour = 'red') + coord_sf()

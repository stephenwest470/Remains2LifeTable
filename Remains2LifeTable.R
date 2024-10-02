### Readme
# This is a script for converting skeletal remains w/ age estimates into an extrapolated model life table
# The results are used by Pax Sapientica for the Yayoi period agent-based simulation
# It primarily uses two packages: mortAAR and DemoTools
# The current configuration makes life tables for each sex and separates by group (i.e. population)
# It allows for the input of infant & child mortality parameters, which override skeletal data
# Current child mortality settings are based on Volk & Atkinson (2013)

## Pax Sapientica
# https://github.com/AsPJT/PAX_SAPIENTICA

## MortAAR
# https://github.com/ISAAKiel/mortAAR

## DemoTools
# Riffe T, Aburto JM, Alexander M,Fennell S, Kashnitsky I, Pascariu M and Gerland P. (2019)
# DemoTools: An R package of tools for aggregate demographic analysis 
# URL: https://github.com/timriffe/DemoTools/.

## Child mortality rate (CMR) reference
# Volk, A. A., & Atkinson, J. A. (2013).
# Infant and child death in the human environment of evolutionary adaptation. 
# Evolution and Human Behavior, 34(3), 182–192.
# https://doi.org/10.1016/j.evolhumbehav.2012.11.007

### Data
# The current configuration makes life tables from Jomon and Yayoi period skeletal remains
# The data source is Kyushu University's skeletal remains database (http://db.museum.kyushu-u.ac.jp/anthropology/)
# Input data in csv format (input.csv), and adjust the script to suit your needs.
# I recommend changing the name of the output file to represent your CMR assumptions
# e.g. life-table-yayoi-CMR45

## Age category classification
# Below are the assumptions that were made for age categories in the data set
# All data modification was done out of script

# 年齢	年齢1	年齢2	name
# 乳児	0	1	infant
# 幼児	0	5	toddler
# 小児	5	10	child
# 若年	10	20	adolescent
# 成年	20	40	young_adult
# 熟年	40	60	middle_adult
# 老年	60	80	old_adult
# 未成人	5	20	juvenile
# 成人	20	60	adult


## Input Format
# ID,site,group,sex,from,to,from_class,to_class
# * = required

# ID = ID of skeletal remains
# Site = Site where the remains are from
# group = population (culture)*
# sex = m (male), f (female), or x (unknown)*
# from = age estimate lower bound*
# to = age estimate, upper bound*
# from_class = from age class (e.g. at a minimum, an infant)
# to_class = from age class (e.g. at a maximum, a child)


### Load packages
# If you don't have the required packages, you must install them.

library(mortAAR)
library(magrittr)
library(DemoTools)
library(dplyr)
library(DT)
library(tidyverse)
library(writexl)

### mortAAR script
## Read input data
csv <- read.csv("input.csv")

# Jomon
jomon.data.frame <- subset(csv, csv$group == "縄文")

# Yayoi
yayoi.data.frame <- subset(csv, csv$group == "弥生")

## Prepare data
# Jomon
jomon.prep.table <- prep.life.table(
  jomon.data.frame, 
  dec = NA, 
  agebeg = "from",
  ageend = "to", 
  group = "sex", 
  method = "Standard",
  agerange = "included"
)

# Yayoi
yayoi.prep.table <- prep.life.table(
  yayoi.data.frame, 
  dec = NA, 
  agebeg = "from",
  ageend = "to", 
  group = "sex", 
  method = "Standard",
  agerange = "included"
)


## Life Table Creation
# Create life table from prep table
# Jomon
jomon.life.table <- jomon.prep.table %>%
  life.table(agecor=FALSE)

# Yayoi
yayoi.life.table <- yayoi.prep.table %>%
  life.table(agecor=FALSE)

### DemoTools script
# Settings
region <- "w"
axmethod <- "pas"
Age <- c(0,1,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75)

## Replace the child mortality rate of each life table
# Assume an infant morality rate (IMR) of 25% and child mortality rate (CMR) of 45%
CMR <- c(0.28, 0.1, 0.05, 0.025, 0.025)

# Jomon Male
jomon.life.table.qx.m <- subset(jomon.life.table$m$qx/100, !is.na(jomon.life.table$m$qx))
jomon.life.table.qx.m[1:5] <- CMR
jomon.life.table.qx.m.l <- length(jomon.life.table.qx.m)

# Jomon Female
jomon.life.table.qx.f <- subset(jomon.life.table$f$qx/100, !is.na(jomon.life.table$f$qx))
jomon.life.table.qx.f[1:5] <- CMR
jomon.life.table.qx.f.l <- length(jomon.life.table.qx.f)

# Jomon, both sexes
jomon.life.table.qx.b <- subset(jomon.life.table$All$qx/100, !is.na(jomon.life.table$All$qx))
jomon.life.table.qx.b[1:5] <- CMR
jomon.life.table.qx.b.l <- length(jomon.life.table.qx.b)

# Yayoi Male
yayoi.life.table.qx.m <- subset(yayoi.life.table$m$qx/100, !is.na(yayoi.life.table$m$qx))
yayoi.life.table.qx.m[1:5] <- CMR
yayoi.life.table.qx.m.l <- length(yayoi.life.table.qx.m)

# Yayoi Female
yayoi.life.table.qx.f <- subset(yayoi.life.table$f$qx/100, !is.na(yayoi.life.table$f$qx))
yayoi.life.table.qx.f[1:5] <- CMR
yayoi.life.table.qx.f.l <- length(yayoi.life.table.qx.f)

# Yayoi, both sexes
yayoi.life.table.qx.b <- subset(yayoi.life.table$All$qx/100, !is.na(yayoi.life.table$All$qx))
yayoi.life.table.qx.b[1:5] <- CMR
yayoi.life.table.qx.b.l <- length(yayoi.life.table.qx.b)

## Calculate non-abridged life tables
# Jomon Male
jomon.life.table.dt.m <- lt_abridged2single(
  nqx = jomon.life.table.qx.m,
  Age = int2age(c(1, 4, rep(5, jomon.life.table.qx.m.l - 2))),
  radix = 100,
  axmethod = axmethod,
  Sex = "m",
  region = region,
  OAnew = 100)

# Jomon Female
jomon.life.table.dt.f <- lt_abridged2single(
  nqx = jomon.life.table.qx.f,
  Age = int2age(c(1, 4, rep(5, jomon.life.table.qx.f.l - 2))),
  radix = 100,
  axmethod = axmethod,
  Sex = "f",
  region = region,
  OAnew = 100)

# Jomon, both sexes
jomon.life.table.dt.b <- lt_abridged2single(
  nqx = jomon.life.table.qx.b,
  Age = int2age(c(1, 4, rep(5, jomon.life.table.qx.b.l - 2))),
  radix = 100,
  axmethod = axmethod,
  Sex = "b",
  region = region,
  OAnew = 100)

# Yayoi Male
yayoi.life.table.dt.m <- lt_abridged2single(
  nqx = yayoi.life.table.qx.m,
  Age = int2age(c(1, 4, rep(5, yayoi.life.table.qx.m.l - 2))),
  radix = 100,
  axmethod = axmethod,
  Sex = "m",
  region = region,
  OAnew = 100)

# Yayoi Female
yayoi.life.table.dt.f <- lt_abridged2single(
  nqx = yayoi.life.table.qx.f,
  Age = int2age(c(1, 4, rep(5, yayoi.life.table.qx.f.l - 2))),
  radix = 100,
  axmethod = axmethod,
  Sex = "f",
  region = region,
  OAnew = 100)

#Yayoi, both sexes
yayoi.life.table.dt.b <- lt_abridged2single(
  nqx = yayoi.life.table.qx.b,
  Age = int2age(c(1, 4, rep(5, yayoi.life.table.qx.b.l - 2))),
  radix = 100,
  axmethod = axmethod,
  Sex = "b",
  region = region,
  OAnew = 100)

### Recalculate mortAAR tables with new demotools data
## Create data frame with number of deaths and sex per age
# Jomon
jomon.mort.m <- data.frame(age = jomon.life.table.dt.m$Age, dec = round(jomon.life.table.dt.m$ndx * 10, digits = 0))
jomon.mort.m$sex <- "m"
jomon.mort.f <- data.frame(age = jomon.life.table.dt.f$Age, dec = round(jomon.life.table.dt.f$ndx * 10, digits = 0))
jomon.mort.f$sex <- "f"
jomon.mort <- rbind(jomon.mort.m, jomon.mort.f)
jomon.mort <- subset(jomon.mort, dec != 0)
jomon.mort.prep <- prep.life.table(jomon.mort, dec = "dec", agebeg = "age", group = "sex")
jomon.mort.life <- jomon.mort.prep %>%
  life.table(agecor=FALSE)
jomon.mort.indices <- data.frame(lt.indices(jomon.mort.life$All))
jomon.mort.reproduction <- data.frame(lt.reproduction(jomon.mort.life$All))

# Yayoi
yayoi.mort.m <- data.frame(age = yayoi.life.table.dt.m$Age, dec = round(yayoi.life.table.dt.m$ndx * 10, digits = 0))
yayoi.mort.m$sex <- "m"
yayoi.mort.f <- data.frame(age = yayoi.life.table.dt.f$Age, dec = round(yayoi.life.table.dt.f$ndx * 10, digits = 0))
yayoi.mort.f$sex <- "f"
yayoi.mort <- rbind(yayoi.mort.m, yayoi.mort.f)
yayoi.mort <- subset(yayoi.mort, dec != 0)
yayoi.mort.prep <- prep.life.table(yayoi.mort, dec = "dec", agebeg = "age", group = "sex")
yayoi.mort.life <- yayoi.mort.prep %>%
  life.table(agecor=FALSE)
yayoi.mort.indices <- data.frame(lt.indices(yayoi.mort.life$All))
yayoi.mort.reproduction <- data.frame(lt.reproduction(yayoi.mort.life$All))

### Export Data
## Prepare and export data
# Jomon
jomon.xlsx <- as.list.data.frame(list(raw_data = jomon.data.frame,
                    reproduction = jomon.mort.reproduction,
                    indices = jomon.mort.indices,
                    life_table_dt = jomon.life.table.dt.b, 
                    life_table_dt_male = jomon.life.table.dt.m,
                    life_table_dt_female = jomon.life.table.dt.f,
                    life_table_mort = jomon.mort.life$All,
                    life_table_mort_male = jomon.mort.life$m,
                    life_table_mort_female = jomon.mort.life$f
                    ))
write_xlsx(jomon.xlsx,"life-table-jomon.xlsx")

# Yayoi
yayoi.xlsx <- as.list.data.frame(list(raw_data = yayoi.data.frame,
                                      reproduction = yayoi.mort.reproduction,
                                      indices = yayoi.mort.indices,
                                      life_table_dt = yayoi.life.table.dt.b, 
                                      life_table_dt_male = yayoi.life.table.dt.m,
                                      life_table_dt_female = yayoi.life.table.dt.f,
                                      life_table_mort = yayoi.mort.life$All,
                                      life_table_mort_male = yayoi.mort.life$m,
                                      life_table_mort_female = yayoi.mort.life$f
))
write_xlsx(yayoi.xlsx,"life-table-yayoi.xlsx")

# written by Stephen West (2024.10.02)
# https://github.com/stephenwest470
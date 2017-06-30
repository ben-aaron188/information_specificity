#####START
#HOTEL REVIEWS ANALYSIS
#R pipeline

#clear ws
rm(list = ls())

#load deps
require(pROC)
require(stringr)
require(splitstackshape)
require(ez)
require(FactoMineR)
library(stringr)
library(MASS)
setwd('/Users/bennettkleinberg/Documents/Research/analysis/R_script/R tutorials')
source("cohensf.R")
source("dz_within_ci.R")
source("ds_between_ci.R")


#NUMERIC TRANSFORMATION FUNCTION
extract_numerics = function(var_in){
  pattern = '\\d+'
  numeric_transformation = as.numeric(str_extract(pattern = pattern
                                                  , string = as.character(var_in)))
  return(numeric_transformation)
}


#set wd
setwd('/Users/bennettkleinberg/GitHub/information_specificity/processed_data')

files = list.files(pattern = '*.txt')

deceptive_negative = read.table(files[1], header=F)
deceptive_positive = read.table(files[3], header=F)
truthful_negative = read.table(files[2], header=F)
truthful_positive = read.table(files[4], header=F)

#purify data
names(deceptive_negative) = c('filename'
                              , 'veracity'
                              , 'polarity'
                              , 'nwords'
                              , 'total_entity_count'
                              , 'total_entity_count_unqiue'
                              , 'location'
                              , 'person'
                              , 'organization'
                              , 'money'
                              , 'percent'
                              , 'date'
                              , 'time'
                              , 'location_unique'
                              , 'person_unique'
                              , 'organization_unique'
                              , 'money_unique'
                              , 'percent_unique'
                              , 'date_unique'
                              , 'time_unique')

deceptive_negative$filename = gsub(",", "", deceptive_negative$filename)
deceptive_negative$veracity = gsub(",", "", deceptive_negative$veracity)
deceptive_negative$polarity = 'negative'

deceptive_negative[,c(4:20)] = apply(deceptive_negative[,c(4:20)], 2, extract_numerics)

deceptive_negative$filename_norm = str_extract(deceptive_negative$filename, '_(.+)\\d')

##
names(deceptive_positive) = c('filename'
                              , 'veracity'
                              , 'polarity'
                              , 'nwords'
                              , 'total_entity_count'
                              , 'total_entity_count_unqiue'
                              , 'location'
                              , 'person'
                              , 'organization'
                              , 'money'
                              , 'percent'
                              , 'date'
                              , 'time'
                              , 'location_unique'
                              , 'person_unique'
                              , 'organization_unique'
                              , 'money_unique'
                              , 'percent_unique'
                              , 'date_unique'
                              , 'time_unique')

deceptive_positive$filename = gsub(",", "", deceptive_positive$filename)
deceptive_positive$veracity = gsub(",", "", deceptive_positive$veracity)
deceptive_positive$polarity = 'positive'

deceptive_positive[,c(4:20)] = apply(deceptive_positive[,c(4:20)], 2, extract_numerics)

deceptive_positive$filename_norm = str_extract(deceptive_positive$filename, '_(.+)\\d')


##
names(truthful_negative) = c('filename'
                              , 'veracity'
                              , 'polarity'
                              , 'nwords'
                              , 'total_entity_count'
                              , 'total_entity_count_unqiue'
                              , 'location'
                              , 'person'
                              , 'organization'
                              , 'money'
                              , 'percent'
                              , 'date'
                              , 'time'
                              , 'location_unique'
                              , 'person_unique'
                              , 'organization_unique'
                              , 'money_unique'
                              , 'percent_unique'
                              , 'date_unique'
                              , 'time_unique')

truthful_negative$filename = gsub(",", "", truthful_negative$filename)
truthful_negative$veracity = gsub(",", "", truthful_negative$veracity)
truthful_negative$polarity = 'negative'

truthful_negative[,c(4:20)] = apply(truthful_negative[,c(4:20)], 2, extract_numerics)

truthful_negative$filename_norm = str_extract(truthful_negative$filename, '_(.+)\\d')

##
names(truthful_positive) = c('filename'
                              , 'veracity'
                              , 'polarity'
                              , 'nwords'
                              , 'total_entity_count'
                              , 'total_entity_count_unqiue'
                              , 'location'
                              , 'person'
                              , 'organization'
                              , 'money'
                              , 'percent'
                              , 'date'
                              , 'time'
                              , 'location_unique'
                              , 'person_unique'
                              , 'organization_unique'
                              , 'money_unique'
                              , 'percent_unique'
                              , 'date_unique'
                              , 'time_unique')

truthful_positive$filename = gsub(",", "", truthful_positive$filename)
truthful_positive$veracity = gsub(",", "", truthful_positive$veracity)
truthful_positive$polarity = 'positive'

truthful_positive[,c(4:20)] = apply(truthful_positive[,c(4:20)], 2, extract_numerics)

truthful_positive$filename_norm = str_extract(truthful_positive$filename, '_(.+)\\d')

sner = do.call(rbind, list(truthful_negative
                           , truthful_positive
                           , deceptive_negative
                           , deceptive_positive))


data = sner

#descriptives
tapply(data$nwords, list(data$polarity, data$veracity), mean)
tapply(data$nwords, list(data$polarity, data$veracity), sd)

data$ner_unique = apply(data[,c(14:20)], 1, sum)

#ner unique proportion
data$ner_unique_prop = (data$ner_unique/data$nwords)*100
tapply(data$ner_unique_prop, list(data$polarity, data$veracity), mean)
tapply(data$ner_unique_prop, list(data$polarity, data$veracity), sd)

data$id = row.names(data)

require(ez)
aov_ner_unique_prop <- ezANOVA(
  data = data
  , dv = ner_unique_prop
  , wid = id
  , within = NULL
  , within_covariates = NULL
  , between = .(polarity, veracity)
  , between_covariates = NULL
  , observed = NULL
  , diff = NULL
  , reverse_diff = FALSE
  , type = 3
  , white.adjust = FALSE
  , detailed = FALSE
  , return_aov = T
)
aov_ner_unique_prop


data_pos = data[data$polarity == 'positive',]
aov_ner_unique_prop_POS <- ezANOVA(
  data = data_pos
  , dv = ner_unique_prop
  , wid = id
  , within = NULL
  , within_covariates = NULL
  , between = .(veracity)
  , between_covariates = NULL
  , observed = NULL
  , diff = NULL
  , reverse_diff = FALSE
  , type = 3
  , white.adjust = FALSE
  , detailed = FALSE
  , return_aov = T
)
aov_ner_unique_prop_POS


data_neg = data[data$polarity == 'negative',]
aov_ner_unique_prop_NEG <- ezANOVA(
  data = data_neg
  , dv = ner_unique_prop
  , wid = id
  , within = NULL
  , within_covariates = NULL
  , between = .(veracity)
  , between_covariates = NULL
  , observed = NULL
  , diff = NULL
  , reverse_diff = FALSE
  , type = 3
  , white.adjust = FALSE
  , detailed = FALSE
  , return_aov = T
)
aov_ner_unique_prop_NEG


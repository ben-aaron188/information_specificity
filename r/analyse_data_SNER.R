#####START
#HOTEL REVIEWS ANALYSIS
#R pipeline

#clear ws
rm(list = ls())

#load deps
require(stringr)
require(ez)
library(stringr)

#
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
                              , 'veracity_str'
                              , 'polarity_str'
                              , 'sner_nwords'
                              , 'total_entity_count'
                              , 'total_entity_count_unqiue'
                              , 'sner_location'
                              , 'sner_person'
                              , 'sner_organization'
                              , 'sner_money'
                              , 'sner_percent'
                              , 'sner_date'
                              , 'sner_time'
                              , 'sner_location_unique'
                              , 'sner_person_unique'
                              , 'sner_organization_unique'
                              , 'sner_money_unique'
                              , 'sner_percent_unique'
                              , 'sner_date_unique'
                              , 'sner_time_unique')




deceptive_negative$filename = gsub(",", "", deceptive_negative$filename)
deceptive_negative$veracity_str = gsub(",", "", deceptive_negative$veracity)
deceptive_negative$polarity_str = 'negative'

deceptive_negative[,c(4:20)] = apply(deceptive_negative[,c(4:20)], 2, extract_numerics)

deceptive_negative$filename_norm = str_extract(deceptive_negative$filename, '_(.+)\\d')

##
names(deceptive_positive) = c('filename'
                              , 'veracity_str'
                              , 'polarity_str'
                              , 'sner_nwords'
                              , 'total_entity_count'
                              , 'total_entity_count_unqiue'
                              , 'sner_location'
                              , 'sner_person'
                              , 'sner_organization'
                              , 'sner_money'
                              , 'sner_percent'
                              , 'sner_date'
                              , 'sner_time'
                              , 'sner_location_unique'
                              , 'sner_person_unique'
                              , 'sner_organization_unique'
                              , 'sner_money_unique'
                              , 'sner_percent_unique'
                              , 'sner_date_unique'
                              , 'sner_time_unique')

deceptive_positive$filename = gsub(",", "", deceptive_positive$filename)
deceptive_positive$veracity_str = gsub(",", "", deceptive_positive$veracity)
deceptive_positive$polarity_str = 'positive'

deceptive_positive[,c(4:20)] = apply(deceptive_positive[,c(4:20)], 2, extract_numerics)

deceptive_positive$filename_norm = str_extract(deceptive_positive$filename, '_(.+)\\d')


##
names(truthful_negative) = c('filename'
                             , 'veracity_str'
                             , 'polarity_str'
                             , 'sner_nwords'
                             , 'total_entity_count'
                             , 'total_entity_count_unqiue'
                             , 'sner_location'
                             , 'sner_person'
                             , 'sner_organization'
                             , 'sner_money'
                             , 'sner_percent'
                             , 'sner_date'
                             , 'sner_time'
                             , 'sner_location_unique'
                             , 'sner_person_unique'
                             , 'sner_organization_unique'
                             , 'sner_money_unique'
                             , 'sner_percent_unique'
                             , 'sner_date_unique'
                             , 'sner_time_unique')

truthful_negative$filename = gsub(",", "", truthful_negative$filename)
truthful_negative$veracity_str = gsub(",", "", truthful_negative$veracity)
truthful_negative$polarity_str = 'negative'

truthful_negative[,c(4:20)] = apply(truthful_negative[,c(4:20)], 2, extract_numerics)

truthful_negative$filename_norm = str_extract(truthful_negative$filename, '_(.+)\\d')

##
names(truthful_positive) = c('filename'
                             , 'veracity_str'
                             , 'polarity_str'
                             , 'sner_nwords'
                             , 'total_entity_count'
                             , 'total_entity_count_unqiue'
                             , 'sner_location'
                             , 'sner_person'
                             , 'sner_organization'
                             , 'sner_money'
                             , 'sner_percent'
                             , 'sner_date'
                             , 'sner_time'
                             , 'sner_location_unique'
                             , 'sner_person_unique'
                             , 'sner_organization_unique'
                             , 'sner_money_unique'
                             , 'sner_percent_unique'
                             , 'sner_date_unique'
                             , 'sner_time_unique')

truthful_positive$filename = gsub(",", "", truthful_positive$filename)
truthful_positive$veracity_str = gsub(",", "", truthful_positive$veracity)
truthful_positive$polarity_str = 'positive'

truthful_positive[,c(4:20)] = apply(truthful_positive[,c(4:20)], 2, extract_numerics)

truthful_positive$filename_norm = str_extract(truthful_positive$filename, '_(.+)\\d')

sner = do.call(rbind, list(truthful_negative
                           , truthful_positive
                           , deceptive_negative
                           , deceptive_positive))


sner$sner_ner_unique = apply(sner[,c(14:20)], 1, sum)
sner$sner_ner_unique_prop = (sner$sner_ner_unique/sner$sner_nwords)*100
sner$sner_ner_unique_verif_prop = (sner$sner_person_unique + sner$sner_location_unique + sner$sner_organization_unique + sner$sner_date_unique + sner$sner_time_unique + sner$sner_money_unique)/sner$sner_nwords*100

save(sner
     , file = 'SNER.RData')

#merge to full data
setwd('/Users/bennettkleinberg/GitHub/information_specificity/processed_data')

files = list.files()
load(files[1])

data$ner_unique_prop = (data$ner_unique/data$nwords)*100
data$ner_unique_verif_prop = (data$nperson_unique + data$ngpe_unique + data$norg_unique + data$ndate_unique + data$ntime_unique + data$nmoney_unique)/data$nwords*100
spacy_liwc_st = data



load(files[9])

sner = sner

spacy_and_sner = merge(spacy_liwc_st, sner, by=c('filename', 'polarity_str', 'veracity_str'))

save(spacy_and_sner
     , file = 'spacy_liwc_speciteller_sner.RData')


#################################################
load('spacy_liwc_speciteller_sner.RData')

data = spacy_and_sner

#descriptives
tapply(data$nwords, list(data$polarity_str, data$veracity_str), mean)
tapply(data$nwords, list(data$polarity_str, data$veracity_str), sd)

tapply(data$nwords, list(data$polarity_str, data$veracity_str), mean)
tapply(data$nwords, list(data$polarity_str, data$veracity_str), sd)


#descriptives
tapply(data$ner_unique_prop, list(data$polarity_str, data$veracity_str), mean)
tapply(data$ner_unique_prop, list(data$polarity_str, data$veracity_str), sd)

tapply(data$sner_ner_unique_prop, list(data$polarity_str, data$veracity_str), mean)
tapply(data$sner_ner_unique_prop, list(data$polarity_str, data$veracity_str), sd)


tapply(data$ner_unique_verif_prop, list(data$polarity_str, data$veracity_str), mean)
tapply(data$ner_unique_verif_prop, list(data$polarity_str, data$veracity_str), sd)

tapply(data$sner_ner_unique_verif_prop, list(data$polarity_str, data$veracity_str), mean)
tapply(data$sner_ner_unique_verif_prop, list(data$polarity_str, data$veracity_str), sd)


tapply(data$ner_unique, list(data$polarity_str, data$veracity_str), mean)
tapply(data$ner_unique, list(data$polarity_str, data$veracity_str), sd)

tapply(data$sner_ner_unique, list(data$polarity_str, data$veracity_str), mean)
tapply(data$sner_ner_unique, list(data$polarity_str, data$veracity_str), sd)

#comp for gpe + location from spacy
data$ner_location_comp = data$ngpe_unique + data$nloc_unique

#correlations
cor(data$nperson_unique, data$sner_person_unique)

cor(data$ngpe_unique, data$sner_location_unique)
cor(data$ner_location_comp, data$sner_location_unique)

cor(data$ndate_unique, data$sner_date_unique)

cor(data$ntime_unique, data$sner_time_unique)

cor(data$norg_unique, data$sner_organization_unique)

cor(data$nmoney_unique, data$sner_money_unique)

cor(data$npercent_unique, data$sner_percent_unique)

#sums
sum(data$nperson_unique)
sum(data$sner_person_unique)

(sum(data$nperson_unique)/sum(data$sner_person_unique))*100-100


sum(data$ngpe_unique)
sum(data$ner_location_comp)
sum(data$sner_location_unique)

(sum(data$ner_location_comp)/sum(data$sner_location_unique))*100-100


sum(data$norg_unique)
sum(data$sner_organization_unique)

(sum(data$norg_unique)/sum(data$sner_organization_unique))*100-100


sum(data$ndate_unique)
sum(data$sner_date_unique)

(sum(data$ndate_unique)/sum(data$sner_date_unique))*100-100


sum(data$ntime_unique)
sum(data$sner_time_unique)

(sum(data$ntime_unique)/sum(data$sner_time_unique))*100-100


sum(data$nmoney_unique)
sum(data$sner_money_unique)

(sum(data$nmoney_unique)/sum(data$sner_money_unique))*100-100


sum(data$npercent_unique)
sum(data$sner_percent_unique)

(sum(data$npercent_unique)/sum(data$sner_percent_unique))*100-100

#agreement
library(fmsb)
cor(x = data$sner_ner_unique, y = data$ner_unique)


#ner unique prop
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

#ner unique sum
tapply(data$ner_unique, list(data$polarity, data$veracity), mean)
tapply(data$ner_unique, list(data$polarity, data$veracity), sd)

aov_ner_unique <- ezANOVA(
  data = data
  , dv = ner_unique
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
aov_ner_unique


###agreement SNER and Spacy

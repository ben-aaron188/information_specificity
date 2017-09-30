#####START
#HOTEL REVIEWS ANALYSIS
#R pipeline

#clear ws
rm(list = ls())

#load deps
require(stringr)
require(ez)
library(stringr)

load('spacy_liwc_speciteller_sner_07072017.RData')

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
  , dv = sner_ner_unique_prop
  , wid = originalpath.x
  , within = NULL
  , within_covariates = NULL
  , between = .(polarity_str, veracity_str)
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


data_pos = data[data$polarity_str == 'positive',]
aov_ner_unique_prop_POS <- ezANOVA(
  data = data_pos
  , dv = sner_ner_unique_prop
  , wid = originalpath.x
  , within = NULL
  , within_covariates = NULL
  , between = .(veracity_str)
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

data_neg = data[data$polarity_str == 'negative',]
aov_ner_unique_prop_NEG <- ezANOVA(
  data = data_neg
  , dv = sner_ner_unique_prop
  , wid = originalpath.x
  , within = NULL
  , within_covariates = NULL
  , between = .(veracity_str)
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

cohensf(1.01, 1, 798)

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
#ROC
require(pROC)
auc_sner = roc(data$veracity_str ~ data$sner_ner_unique_prop, ci=T)
auc_ner = roc(data$veracity_str ~ data$ner_unique_prop, ci=T)


roc.test(auc_sner, auc_ner, method = 'v')

auc_sner_pos = roc(data$veracity_str[data$polarity_str == 'positive'] ~ data$sner_ner_unique_prop[data$polarity_str == 'positive'], ci=T)
auc_sner_neg = roc(data$veracity_str[data$polarity_str == 'negative'] ~ data$sner_ner_unique_prop[data$polarity_str == 'negative'], ci=T)

#sparsity
names(data)
apply(data[,c(183:189)], 2, function(x){
  prop.table(table(x == 0))
})

#props per category
data[,c(183:189)] = apply(data[,c(183:189)], 2, function(x){
  (x/data$nwords)*100
})

names(data)
data[,c(42:59)] = apply(data[,c(42:59)], 2, function(x){
  (x/data$nwords)*100
})

#overall effect
apply(data[,c(183:189)], 2, function(x){
  aggr_table = round(tapply(x, list(data$polarity_str, data$veracity_str), mean)*100, 2)
  aggr_table_sd = round(tapply(x, list(data$polarity_str, data$veracity_str), sd)*100, 2)
  summ_aov = summary(aov(x ~ data$polarity_str*data$veracity_str))
  F_value = summ_aov[[1]][["F value"]][2]
  effect_size = cohensf(F_value, 1, 1596)
  return(list(aggr_table, aggr_table_sd, summ_aov, effect_size))
})

#pos
data_pos = data[data$polarity_str == 'positive',]
apply(data_pos[,c(183:189)], 2, function(x){
  aggr_table = round(tapply(x, list(data_pos$veracity_str), mean)*100, 2)
  aggr_table_sd = round(tapply(x, list(data_pos$veracity_str), sd)*100, 2)
  summ_aov = summary(aov(x ~ data_pos$veracity_str))
  F_value = summ_aov[[1]][["F value"]][1]
  effect_size = cohensf(F_value, 1, 798)
  return(list(summ_aov, effect_size))
})

#neg
data_neg = data[data$polarity_str == 'negative',]
apply(data_neg[,c(183:189)], 2, function(x){
  aggr_table = round(tapply(x, list(data_neg$veracity_str), mean)*100, 2)
  aggr_table_sd = round(tapply(x, list(data_neg$veracity_str), sd)*100, 2)
  summ_aov = summary(aov(x ~ data_neg$veracity_str))
  F_value = summ_aov[[1]][["F value"]][1]
  effect_size = cohensf(F_value, 1, 798)
  return(list(summ_aov, effect_size))
})

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
library(MASS)
setwd('/Users/bennettkleinberg/Documents/Research/app/wp_onACIT/onacit/R_script/R tutorials')
source("cohensf.R")
source("dz_within_ci.R")
source("ds_between_ci.R")

#set wd
setwd('/Users/bennettkleinberg/GitHub/information_specificity/processed_data')

files = list.files()
load(files[1])

data$filename_norm = str_extract(data$filename, '_(.+)\\d')

#descriptives
tapply(data$nwords, list(data$polarity_str, data$veracity_str), mean)
tapply(data$nwords, list(data$polarity_str, data$veracity_str), sd)


#set variables
data$ner_unique_prop = (data$ner_unique/data$nwords)*100
data$st_spec = round(data$spec_avg*100, 2)
data$liwc_detailedness = data$percept + data$time + data$space
data$ner_unique_verif_prop = (data$nperson_unique + data$nfac_unique + data$ngpe_unique + data$nloc_unique + data$norg_unique + data$nevent_unique + data$ndate_unique + data$ntime_unique + data$nmoney_unique)/data$nwords*100
data$ner_unique_zerocounts_prop = (data$nperson_unique + data$nfac_unique + data$ndate_unique + data$ntime_unique + data$nmoney_unique + data$nordinal_unique + data$ncardinal_unique)/data$nwords*100

#split data per polarity for follow-ups
data_pos = data[data$polarity_str == 'positive',]
data_neg = data[data$polarity_str == 'negative',]

#ner unique proportion
tapply(data$ner_unique_prop, list(data$polarity_str, data$veracity_str), mean)
tapply(data$ner_unique_prop, list(data$polarity_str, data$veracity_str), sd)

which.max(data$ner_unique_prop)

aov_ner_unique_prop <- ezANOVA(
  data = data
  , dv = ner_unique_prop
  , wid = originalpath.x
  #, wid = filename_norm
  #, within = .(polarity_str, veracity_str)
  , within_covariates = NULL
  , between = .(polarity_str, veracity_str)
  #, between = .(veracity_str)
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

cohensf(97.44, 1, 1596)
cohensf(137.95, 1, 1596)
cohensf(4.65, 1, 1596)


aov_ner_unique_prop_POS <- ezANOVA(
  data = data_pos
  , dv = ner_unique_prop
  , wid = originalpath.x
  #, wid = filename_norm
  #, within = .(veracity_str)
  , within_covariates = NULL
  #, between = .(polarity_str, veracity_str)
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
cohensf(73.64, 1, 798)

aov_ner_unique_prop_NEG <- ezANOVA(
  data = data_neg
  , dv = ner_unique_prop
  , wid = originalpath.x
  #, wid = filename_norm
  #, within = .(veracity_str)
  , within_covariates = NULL
  #, between = .(polarity_str, veracity_str)
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
cohensf(63.63, 1, 798)
?ezANOVA
#ner unique sum
tapply(data$ner_unique, list(data$polarity_str, data$veracity_str), mean)
tapply(data$ner_unique, list(data$polarity_str, data$veracity_str), sd)

aov_ner_unique <- ezANOVA(
  data = data
  , dv = ner_unique
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
aov_ner_unique

cohensf(9.65, 1, 1596)
cohensf(121.45, 1, 1596)
cohensf(0.01, 1, 1596)

aov_ner_unique_POS <- ezANOVA(
  data = data_pos
  , dv = ner_unique
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
aov_ner_unique_POS
cohensf(72.88, 1, 798)

aov_ner_unique_NEG <- ezANOVA(
  data = data_neg
  , dv = ner_unique
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
aov_ner_unique_NEG
cohensf(51.77, 1, 798)

#ner proportion
data$ner_prop = (data$ner/data$nwords)*100
tapply(data$ner_prop, list(data$polarity_str, data$veracity_str), mean)
tapply(data$ner_prop, list(data$polarity_str, data$veracity_str), sd)

aov_ner_prop <- ezANOVA(
  data = data
  , dv = ner_prop
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
aov_ner_prop

cohensf(104.90, 1, 1596)
cohensf(118.92, 1, 1596)
cohensf(1.04, 1, 1596)

aov_ner_prop_POS <- ezANOVA(
  data = data_pos
  , dv = ner_prop
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
aov_ner_prop_POS
cohensf(56.99, 1, 798)

aov_ner_prop_NEG <- ezANOVA(
  data = data_neg
  , dv = ner_prop
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
aov_ner_prop_NEG
cohensf(66.92, 1, 798)

#ner
tapply(data$ner, list(data$polarity_str, data$veracity_str), mean)
tapply(data$ner, list(data$polarity_str, data$veracity_str), sd)

aov_ner <- ezANOVA(
  data = data
  , dv = ner
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
aov_ner

cohensf(103.72, 1, 1596)
cohensf(8.48, 1, 1596)
cohensf(0.72, 1, 1596)

cohensf(104.99, 1, 399)

aov_ner_POS <- ezANOVA(
  data = data_pos
  , dv = ner
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
aov_ner_POS
cohensf(53.44, 1, 798)

aov_ner_NEG <- ezANOVA(
  data = data_neg
  , dv = ner
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
aov_ner_NEG
cohensf(51.39, 1, 798)

#speciteller
tapply(data$st_spec, list(data$polarity_str, data$veracity_str), mean)
tapply(data$st_spec, list(data$polarity_str, data$veracity_str), sd)

aov_speciteller <- ezANOVA(
  data = data
  , dv = st_spec
  , wid = originalpath.x
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
aov_speciteller

cohensf(32.44, 1, 1596)
cohensf(1.37, 1, 1596)
cohensf(0.08, 1, 1596)

aov_speciteller_POS <- ezANOVA(
  data = data_pos
  , dv = st_spec
  , wid = originalpath.x
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
aov_speciteller_POS
cohensf(15.72, 1, 798)


aov_speciteller_NEG <- ezANOVA(
  data = data_neg
  , dv = st_spec
  , wid = originalpath.x
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
aov_speciteller_NEG
cohensf(16.99, 1, 798)


#liwc comp
tapply(data$liwc_detailedness, list(data$polarity_str, data$veracity_str), mean)
tapply(data$liwc_detailedness, list(data$polarity_str, data$veracity_str), sd)

aov_liwc_detailedness <- ezANOVA(
  data = data
  , dv = liwc_detailedness
  , wid = originalpath.x
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
aov_liwc_detailedness

cohensf(7.32, 1, 1596)
cohensf(2.36, 1, 1596)
cohensf(5.93, 1, 1596)

aov_liwc_detailedness_POS <- ezANOVA(
  data = data_pos
  , dv = liwc_detailedness
  , wid = originalpath.x
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
aov_liwc_detailedness_POS
cohensf(12.85, 1, 798)
cohensf(12.25, 1, 798)


aov_liwc_detailedness_NEG <- ezANOVA(
  data = data_neg
  , dv = liwc_detailedness
  , wid = originalpath.x
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
aov_liwc_detailedness_NEG
cohensf(0.04, 1, 798)

###AUC
library(pROC)

#ner unique prop
auc_ner_unique_prop_pos = roc(data$veracity_str[data$polarity_str == 'positive'] ~ data$ner_unique_prop[data$polarity_str == 'positive'])
auc_ner_unique_prop_pos
ci(auc_ner_unique_prop_pos)

auc_ner_unique_prop_neg = roc(data$veracity_str[data$polarity_str == 'negative'] ~ data$ner_unique_prop[data$polarity_str == 'negative'])
auc_ner_unique_prop_neg
ci(auc_ner_unique_prop_neg)

auc_ner_unique_prop = roc(data$veracity_str ~ data$ner_unique_prop)
auc_ner_unique_prop
ci(auc_ner_unique_prop)

#ideal
coords(auc_ner_unique_prop, "b",  best.method="youden")

#ner unique
auc_ner_unique_pos = roc(data$veracity_str[data$polarity_str == 'positive'] ~ data$ner_unique[data$polarity_str == 'positive'])
auc_ner_unique_pos
ci(auc_ner_unique_pos)

auc_ner_unique_neg = roc(data$veracity_str[data$polarity_str == 'negative'] ~ data$ner_unique[data$polarity_str == 'negative'])
auc_ner_unique_neg
ci(auc_ner_unique_neg)

auc_ner_unique = roc(data$veracity_str ~ data$ner_unique)
auc_ner_unique
ci(auc_ner_unique)

#ner prop
auc_ner_prop_pos = roc(data$veracity_str[data$polarity_str == 'positive'] ~ data$ner_prop[data$polarity_str == 'positive'])
auc_ner_prop_pos
ci(auc_ner_prop_pos)

auc_ner_prop_neg = roc(data$veracity_str[data$polarity_str == 'negative'] ~ data$ner_prop[data$polarity_str == 'negative'])
auc_ner_prop_neg
ci(auc_ner_prop_neg)

auc_ner_prop = roc(data$veracity_str ~ data$ner_prop)
auc_ner_prop
ci(auc_ner_prop)

#ner
auc_ner_pos = roc(data$veracity_str[data$polarity_str == 'positive'] ~ data$ner[data$polarity_str == 'positive'])
auc_ner_pos
ci(auc_ner_pos)

auc_ner_neg = roc(data$veracity_str[data$polarity_str == 'negative'] ~ data$ner[data$polarity_str == 'negative'])
auc_ner_neg
ci(auc_ner_neg)

auc_ner = roc(data$veracity_str ~ data$ner)
auc_ner
ci(auc_ner)

#speciteller
auc_speciteller_pos = roc(data$veracity_str[data$polarity_str == 'positive'] ~ data$st_spec[data$polarity_str == 'positive'])
auc_speciteller_pos
ci(auc_speciteller_pos)

auc_speciteller_neg = roc(data$veracity_str[data$polarity_str == 'negative'] ~ data$st_spec[data$polarity_str == 'negative'])
auc_speciteller_neg
ci(auc_speciteller_neg)

auc_speciteller = roc(data$veracity_str ~ data$st_spec)
auc_speciteller
ci(auc_speciteller)


#LIWC
auc_liwc_pos = roc(data$veracity_str[data$polarity_str == 'positive'] ~ data$liwc_detailedness[data$polarity_str == 'positive'])
auc_liwc_pos
ci(auc_liwc_pos)

auc_liwc_neg = roc(data$veracity_str[data$polarity_str == 'negative'] ~ data$liwc_detailedness[data$polarity_str == 'negative'])
auc_liwc_neg
ci(auc_liwc_neg)

auc_liwc = roc(data$veracity_str ~ data$liwc_detailedness)
auc_liwc
ci(auc_liwc)

#comparison
roc.test(a, c)

#fine tuning unique NERs
names(data)

#select only verifiable ones
tapply(data$ner_unique_verif_prop, list(data$polarity_str, data$veracity_str), mean)
tapply(data$ner_unique_verif_prop, list(data$polarity_str, data$veracity_str), sd)

aov_ner_unique_verif_prop <- ezANOVA(
  data = data
  , dv = ner_unique_verif_prop
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
aov_ner_unique_verif_prop

cohensf(72.11, 1, 1596)
cohensf(155.11, 1, 1596)
cohensf(13.25, 1, 1596)

aov_ner_unique_verif_prop_POS <- ezANOVA(
  data = data_pos
  , dv = ner_unique_verif_prop
  , wid = originalpath.x
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
aov_ner_unique_verif_prop_POS
cohensf(53.01, 1, 798)


aov_ner_unique_verif_prop_NEG <- ezANOVA(
  data = data_neg
  , dv = ner_unique_verif_prop
  , wid = originalpath.x
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
aov_ner_unique_verif_prop_NEG
cohensf(19.24, 1, 798)

#check on zero counts
apply(data[,c(42:59)], 2, function(x){
  prop.table(table(x == 0))
})
apply(data[,c(42:59)], 2, function(x){
  #mean(x)
  tapply(x, list(data$polarity_str, data$veracity_str), mean)*100
})

tapply(data$ner_unique_zerocounts_prop, list(data$polarity_str, data$veracity_str), mean)
tapply(data$ner_unique_zerocounts_prop, list(data$polarity_str, data$veracity_str), sd)

aov_ner_unique_zerocounts_prop <- ezANOVA(
  data = data
  , dv = ner_unique_zerocounts_prop
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
aov_ner_unique_zerocounts_prop

cohensf(219.44, 1, 1596)
cohensf(9.80, 1, 1596)
cohensf(3.57, 1, 1596)

aov_ner_unique_zerocounts_prop_POS <- ezANOVA(
  data = data_pos
  , dv = ner_unique_zerocounts_prop
  , wid = originalpath.x
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
aov_ner_unique_zerocounts_prop_POS
cohensf(132.05, 1, 798)


aov_ner_unique_zerocounts_prop_NEG <- ezANOVA(
  data = data_neg
  , dv = ner_unique_zerocounts_prop
  , wid = originalpath.x
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
aov_ner_unique_zerocounts_prop_NEG
cohensf(87.41, 1, 798)


which.max(data$ner_unique_prop)
which.max(data$ner_unique_verif_prop)
which.max(data$ner_unique_zerocounts_prop)
max(data$ner_unique_zerocounts_prop)
min(data$ner_unique_zerocounts_prop)
which.min(data$ner_unique_zerocounts_prop)
View(data[data$ner_unique_zerocounts_prop > 5,])
View(data[data$filename == 'd_hyatt_20.txt', ])
#write to csv for ML in python
# write.csv(data
#           , file='inf_spec_ner_liwc_speciteller.csv'
#           , na = 'NA'
#           , row.names = F
#           , col.names = T
# )


###check for NER types individually
data_pos = data[data$polarity_str == 'positive',]
data_neg = data[data$polarity_str == 'negative',]

names(data)

aov_ner_unique_PER_NER_TYPE <- ezANOVA(
  data = data
  , dv = nordinal_unique
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

aov_ner_unique_PER_NER_TYPE_pos <- ezANOVA(
  data = data_pos
  , dv = nordinal_unique
  , wid = originalpath.x
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

aov_ner_unique_PER_NER_TYPE_neg <- ezANOVA(
  data = data_neg
  , dv = nordinal_unique
  , wid = originalpath.x
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

aov_ner_unique_PER_NER_TYPE
cohensf(29.55, 1, 1596)
aov_ner_unique_PER_NER_TYPE_pos
cohensf(21.56, 1, 798)
aov_ner_unique_PER_NER_TYPE_neg
cohensf(11.42, 1, 798)


###refinement
ner_only = data[,c(2,17,42:59)]
ner_only_pos = ner_only[ner_only$polarity_str == 'positive',]
ner_only_pos = ner_only_pos[,-c(1)]
ner_only_neg = ner_only[ner_only$polarity_str == 'negative',]
ner_only_neg = ner_only_neg[,-c(1)]



#per LIWC cue
names(data)

round(tapply(data$WC, list(data$polarity_str, data$veracity_str), mean), 2)
#[,1] --> positive deceptive
#[,2] --> negative deceptive
#[,1] --> positive truthful
#[,1] --> negative truthful

#apply(data[,c(68:161)], 2, function(x){
set.seed(42)
df = data.frame('x1' = rnorm(100),
                'x2' = rnorm(100))

apply(df[,c(1:2)], 2, function(x){
  mymean = mean(x)
  mysd = sd(x)
  return(list(mymean, mysd))
})


#overall (irrespective of polarity)
apply(data[,c(68:70)], 2, function(x){
  aggr_table = round(tapply(x, list(data$polarity_str, data$veracity_str), mean), 2)
  summ_aov = summary(aov(x ~ data$polarity_str*data$veracity_str))
  F_value = summ_aov[[1]][["F value"]][1]
  effect_size = cohensf(F_value, 1, 1596)
  return(list(aggr_table, summ_aov, effect_size))
})


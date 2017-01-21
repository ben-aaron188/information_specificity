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
  #, wid = originalpath.x
  , wid = filename_norm
  , within = .(polarity_str, veracity_str)
  , within_covariates = NULL
  #, between = .(polarity_str, veracity_str)
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
aov_ner_unique

cohensf(9.48, 1, 399)
cohensf(121.90, 1, 399)
cohensf(0.01, 1, 399)

aov_ner_unique_POS <- ezANOVA(
  data = data_pos
  , dv = ner_unique
  #, wid = originalpath.x
  , wid = filename_norm
  , within = .(veracity_str)
  , within_covariates = NULL
  #, between = .(polarity_str, veracity_str)
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
aov_ner_unique_POS
cohensf(74.18, 1, 399)

aov_ner_unique_NEG <- ezANOVA(
  data = data_neg
  , dv = ner_unique
  #, wid = originalpath.x
  , wid = filename_norm
  , within = .(veracity_str)
  , within_covariates = NULL
  #, between = .(polarity_str, veracity_str)
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
aov_ner_unique_NEG
cohensf(50.42, 1, 399)

#ner proportion
data$ner_prop = (data$ner/data$nwords)*100
tapply(data$ner_prop, list(data$polarity_str, data$veracity_str), mean)
tapply(data$ner_prop, list(data$polarity_str, data$veracity_str), sd)

aov_ner_prop <- ezANOVA(
  data = data
  , dv = ner_prop
  #, wid = originalpath.x
  , wid = filename_norm
  , within = .(polarity_str, veracity_str)
  , within_covariates = NULL
  #, between = .(polarity_str, veracity_str)
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
aov_ner_prop

cohensf(123.62, 1, 399)
cohensf(104.28, 1, 399)
cohensf(1.07, 1, 399)

aov_ner_prop_POS <- ezANOVA(
  data = data_pos
  , dv = ner_prop
  #, wid = originalpath.x
  , wid = filename_norm
  , within = .(veracity_str)
  , within_covariates = NULL
  #, between = .(polarity_str, veracity_str)
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
aov_ner_prop_POS
cohensf(58.92, 1, 399)

aov_ner_prop_NEG <- ezANOVA(
  data = data_neg
  , dv = ner_prop
  #, wid = originalpath.x
  , wid = filename_norm
  , within = .(veracity_str)
  , within_covariates = NULL
  #, between = .(polarity_str, veracity_str)
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
aov_ner_prop_NEG
cohensf(66.73, 1, 399)

#ner
tapply(data$ner, list(data$polarity_str, data$veracity_str), mean)
tapply(data$ner, list(data$polarity_str, data$veracity_str), sd)

aov_ner <- ezANOVA(
  data = data
  , dv = ner
  , wid = filename_norm
  , within = .(polarity_str, veracity_str)
  , within_covariates = NULL
  #, between = .(polarity_str, veracity_str)
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
aov_ner

cohensf(104.99, 1, 399)
cohensf(8.34, 1, 399)
cohensf(0.72, 1, 399)

cohensf(104.99, 1, 399)

aov_ner_POS <- ezANOVA(
  data = data_pos
  , dv = ner
  , wid = filename_norm
  , within = .(veracity_str)
  , within_covariates = NULL
  #, between = .(polarity_str, veracity_str)
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
aov_ner_POS
cohensf(55.75, 1, 399)

aov_ner_NEG <- ezANOVA(
  data = data_neg
  , dv = ner
  , wid = filename_norm
  , within = .(veracity_str)
  , within_covariates = NULL
  #, between = .(polarity_str, veracity_str)
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
aov_ner_NEG
cohensf(50.33, 1, 399)

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

#glm
full_model = lm(ner_unique ~ .
                , data = ner_only_pos)
summary(full_model)
library(relaimpo)

#relative importance
calc.relimp(full_model
            , type = c("lmg")
            , rela = TRUE)

step(full_model
     , direction="backward")


full_model = loglm(veracity_int
                   ~ nperson_unique+nfac_unique
                   , data=ner_only_pos)
step(full_model
     , scope= ~. + nperson_unique*ngpe_unique, direction="forward")


#pca
names(data)
#select data
pca_data_ner = data[,c(42:59)]
pca_data_liwc = data[,c(77:161)]

#scale data for analysis
norm_ner = scale(pca_data_ner)
norm_liwc = scale(pca_data_liwc)

#conduct PCA
fit_ner = PCA(norm_ner
              , graph = FALSE
              , scale.unit = T
              , ncp = 5)
summary(fit_ner)

fit_liwc = PCA(norm_liwc
              , graph = FALSE
              , scale.unit = T
              , ncp = 5)
summary(fit_liwc)

#re-calculate component loadings after deciding the number of retained components
PCAloadings1 = matrix(0,ncol(alldata1),3)
PCAloadings1[,1] = fit1$var$coord[,1] / sqrt(fit1$eig[1,1])
PCAloadings1[,2] = fit1$var$coord[,2] / sqrt(fit1$eig[2,1])
PCAloadings1[,3] = fit1$var$coord[,3] / sqrt(fit1$eig[3,1])
PCAloadings1[,4] = fit1$var$coord[,4] / sqrt(fit1$eig[4,1])
PCAloadings1[,5] = fit1$var$coord[,5] / sqrt(fit1$eig[5,1])

#promax rotation
prom1 = promax(PCAloadings1)
rcomp1 = normdatadf1 %*% prom1$loadings
rcomp1 = round(rcomp1, 2)

#correlation structure
new_cor2 = matrix(0, ncol(alldata1), ncol(PCAloadings1))
for(i in 1:ncol(normdatadf1)){
  for(j in 1:ncol(rcomp1)){
    new_cor2[i,j] = cor(normdatadf1[,i], rcomp1[,j], use = "pairwise")
  }
}


#retrieve simple matrix structure
pca_struc = round(new_cor2, 2)
row.names(pca_struc) = colnames(normdatadf1)
mask_mat = abs(pca_struc) >= .3
simp_struc = pca_struc * mask_mat
simp_struc = ifelse(simp_struc == 0, NA, simp_struc)


#labelling of components
row.names(findat@data) = findat@data[,1]
rcomp1 = as.data.frame(rcomp1)
rcomp1$lsoa = row.names(rcomp1)
colnames(rcomp1) = c("pers_dis",
                     "marginalisation",
                     "lsoa")


#ML dim red

#####END
---








































#data$specifics_prop = (data$nspecifics_ne/data$nwords)*100

data$firstperson = (data$i + data$we)/2
data$secondperson = data$you
data$thirdperson = (data$shehe + data$they)/2
data$burgoonzhou = (data$firstperson +  data$secondperson + data$thirdperson + data$nmodifiers + data$percept)/5

##Sign cues form Hauch et al.
#word quantity
tapply(data$nwords, list(data$polarity_num, data$veracity_num), mean)
tapply(data$nwords, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$nwords[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$nwords[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#sentence quantity
tapply(data$nsents, list(data$polarity_num, data$veracity_num), mean)
tapply(data$nsents, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$nsents[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$nsents[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#content-word diversity
tapply(data$content_diversity_score, list(data$polarity_num, data$veracity_num), mean)
tapply(data$content_diversity_score, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$content_diversity_score[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$content_diversity_score[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)


#lexical diversity
tapply(data$lexical_diversity_score, list(data$polarity_num, data$veracity_num), mean)
tapply(data$lexical_diversity_score, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$lexical_diversity_score[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$lexical_diversity_score[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#exlusive words
tapply(data$differ, list(data$polarity_num, data$veracity_num), mean)
tapply(data$differ, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$differ[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$differ[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#tenative words
tapply(data$tentat, list(data$polarity_num, data$veracity_num), mean)
tapply(data$tentat, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$tentat[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$tentat[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#negations
tapply(data$negate, list(data$polarity_num, data$veracity_num), mean)
tapply(data$negate, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$negate[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$negate[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#negative emotions
tapply(data$negemo, list(data$polarity_num, data$veracity_num), mean)
tapply(data$negemo, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$negemo[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$negemo[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#anger
tapply(data$anger, list(data$polarity_num, data$veracity_num), mean)
tapply(data$anger, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$anger[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$anger[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#emotions
tapply(data$affect, list(data$polarity_num, data$veracity_num), mean)
tapply(data$affect, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$affect[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$affect[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#first person
tapply(data$firstperson, list(data$polarity_num, data$veracity_num), mean)
tapply(data$firstperson, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$firstperson[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$firstperson[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#second person
tapply(data$secondperson, list(data$polarity_num, data$veracity_num), mean)
tapply(data$secondperson, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$secondperson[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$secondperson[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#third person
tapply(data$thirdperson, list(data$polarity_num, data$veracity_num), mean)
tapply(data$thirdperson, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$thirdperson[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$thirdperson[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#perceptual
tapply(data$percept, list(data$polarity_num, data$veracity_num), mean)
tapply(data$percept, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$percept[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$percept[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#temporal
tapply(data$time, list(data$polarity_num, data$veracity_num), mean)
tapply(data$time, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$time[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$time[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#specific times
tapply(data$nspecifictime, list(data$polarity_num, data$veracity_num), mean)
tapply(data$nspecifictime, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$nspecifictime[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$nspecifictime[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#spatial
tapply(data$space, list(data$polarity_num, data$veracity_num), mean)
tapply(data$space, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$space[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$space[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#hearing
tapply(data$hear, list(data$polarity_num, data$veracity_num), mean)
tapply(data$hear, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$hear[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$hear[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#quantifier
tapply(data$quant, list(data$polarity_num, data$veracity_num), mean)
tapply(data$quant, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$quant[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$quant[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#motion verbs
tapply(data$motion, list(data$polarity_num, data$veracity_num), mean)
tapply(data$motion, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$motion[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$motion[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#cog proc
tapply(data$cogproc, list(data$polarity_num, data$veracity_num), mean)
tapply(data$cogproc, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$cogproc[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$cogproc[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#insight
tapply(data$insight, list(data$polarity_num, data$veracity_num), mean)
tapply(data$insight, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$insight[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$insight[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#Burgoon/Zhou specificity
tapply(data$burgoonzhou, list(data$polarity_num, data$veracity_num), mean)
tapply(data$burgoonzhou, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$burgoonzhou[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$burgoonzhou[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#speciteller
tapply(data$spec_avg, list(data$polarity_num, data$veracity_num), mean)
tapply(data$spec_avg, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$spec_avg[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$spec_avg[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

#Information specificity
tapply(data$nspecifics_ne, list(data$polarity_num, data$veracity_num), mean)
tapply(data$nspecifics_ne, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$nspecifics_ne[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$nspecifics_ne[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

tapply(data$rel_inf_spec_noun, list(data$polarity_num, data$veracity_num), mean)
tapply(data$rel_inf_spec_noun, list(data$polarity_num, data$veracity_num), sd)

ds_between_ci(data$rel_inf_spec_noun[data$polarity_num == 'positive'], data$veracity_num[data$polarity_num == 'positive'], T)
ds_between_ci(data$rel_inf_spec_noun[data$polarity_num == 'negative'], data$veracity_num[data$polarity_num == 'negative'], T)

###END MAIN

#weighting of cues
data_ = data[,c(1:3, 7:10, 14, 52)]
data_ = cSplit(data_, c('tokens', 'feature1', 'feature2', 'label'), ', ', 'long')

#prep data
data_$tokens = as.character(trimws(data_$tokens))
data_$tokens = tolower(data_$tokens)

data_$feature1 = gsub("\\'|\\]|\\[|\\(|\\)", "", data_$feature1)
data_$feature2 = gsub("\\'|\\]|\\[|\\(|\\)", "", data_$feature2)
data_$label = gsub("\\'|\\]|\\[|\\(|\\)", "", data_$label)

table_a = table(data_$feature1[data_$label == "specifics"], data_$label[data_$label == "specifics"], data_$veracity_num[data_$label == "specifics"], data_$polarity_num[data_$label == "specifics"])
ne_df = data.frame('posdec' = table_a[,,1,2],
                   'postru' = table_a[,,2,2],
                   'negdec' = table_a[,,1,1],
                   'negtru' = table_a[,,2,1])
ne_df$diff_pos = ne_df$postru - ne_df$posdec
ne_df$diff_neg = ne_df$negtru - ne_df$negdec
# ne_stacked = stack(ne_df)
# ne_stacked$keys = row.names(ne_df)
#
# t.test(ne_stacked$val[ne_stacked$ind == 'negdec' | ne_stacked$ind == 'negtru']  ne_stacked$ind[ne_stacked$ind == 'negdec' | ne_stacked$ind == 'negtru'])


#ML
names(data)
data_ml_pos = data[data$polarity_num == 'positive', c(3, 12:45, 58:77, 84, 90)]
data_ml_pos = data[data$polarity_num == 'positive',]
data_ml_neg = data[data$polarity_num == 'negative', c(3, 12:45, 58:77, 84, 90)]
require(caret)
require(e1071)

#pos with all features with d > 0.2
set.seed(444)
in_training = createDataPartition(data_ml_pos$veracity_num, p = .8, list = FALSE)
train_data = data_ml_pos[ in_training,]
test_data  = data_ml_pos[-in_training,]
controls = trainControl(method="repeatedcv",
                        number=20,
                        repeats=10,
                        selectionFunction = "oneSE"
                        #,classProbs = F
                        #,summaryFunction = twoClassSummary
)
# modelx = train(veracity_num ~ .
#                ,data = train_data
#                ,method = "rf"
#                ,trControl = controls
#                ,verbose = FALSE
#                #,metric = 'ROC')
)

model_es = train(veracity_num ~ content_diversity_score + differ + thirdperson + nspecifictime + space + hear + spec_avg + rel_inf_spec_noun,
                 data = train_data
                 ,method = "nnet"
                 ,trControl = controls
                 ,verbose = FALSE
                 #,metric = 'ROC')
)

predictions = predict(model_es, test_data)
caret::confusionMatrix(predictions, test_data$veracity_num,
                       dnn = c("algorithm", "data"),
                       positive = 'truthful')


saveRDS(modelx, file = "modelx_svmradial_roc_ott_pos_29072016.rds")


#neg
set.seed(444)
in_training = createDataPartition(data_ml_neg$veracity_num, p = .75, list = FALSE)
train_data = data_ml_neg[ in_training,]
test_data  = data_ml_neg[-in_training,]
controls = trainControl(method="repeatedcv",
                        number=20,
                        repeats=10,
                        selectionFunction = "oneSE"
                        #,classProbs = TRUE
                        #,summaryFunction = twoClassSummary
)

modelx = train(veracity_num ~ nspecifictime + space + spec_avg + rel_inf_spec_noun,
               data = train_data,
               method = "svmRadialWeights",
               trControl = controls,
               verbose = FALSE
               #,metric = 'ROC'
)

predictions = predict(modelx, test_data)
caret::confusionMatrix(predictions, test_data$veracity_num,
                       dnn = c("algorithm", "data"),
                       positive = 'truthful')


saveRDS(modelx, file = "modelx_svmradial_roc_ott_neg_29072016.rds")


#pos on neg data
ott_pos = readRDS('modelx_svmradial_ott_pos_23072016.rds')
test_data  = data_ml_neg

predictions = predict(ott_pos, test_data)
caret::confusionMatrix(predictions, test_data$veracity_num,
                       dnn = c("algorithm", "data"),
                       positive = 'truthful')


#neg on pos data
ott_neg = readRDS('modelx_svmradial_ott_neg.rds')
test_data  = data_ml_pos

predictions = predict(ott_neg, test_data)
caret::confusionMatrix(predictions, test_data$veracity_num,
                       dnn = c("algorithm", "data"),
                       positive = 'truthful')


##only good ones --> train this model --> use for others
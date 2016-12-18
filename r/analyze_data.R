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
setwd('/Users/bennettkleinberg/Documents/Research/app/wp_onACIT/onacit/R_script/R tutorials')
source("cohensf.R")
source("dz_within_ci.R")
source("ds_between_ci.R")

#set wd
setwd('/Users/bennettkleinberg/GitHub/information_specificity/processed_data')

files = list.files()
load(files[1])

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
#speciteller
data$st_spec = round(data$spec_avg*100, 2)
tapply(data$st_spec, list(data$polarity_str, data$veracity_str), mean)
tapply(data$st_spec, list(data$polarity_str, data$veracity_str), sd)

aov_speciteller <- ezANOVA(
  data = data
  , dv = st_spec
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
aov_speciteller

cohensf(32.44, 1, 1596)

#liwc comp
data$liwc_detailedness = data$percept + data$time + data$space
tapply(data$liwc_detailedness, list(data$polarity_str, data$veracity_str), mean)
tapply(data$liwc_detailedness, list(data$polarity_str, data$veracity_str), sd)

aov_liwc_detailedness <- ezANOVA(
  data = data
  , dv = liwc_detailedness
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
aov_liwc_detailedness

cohensf(7.32, 1, 1596)


###refinement

#glm

#pca


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
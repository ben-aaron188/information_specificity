#MERGE PYTHON NER AND LIWC DATA
#R pipeline

#clear ws
rm(list = ls())

#set wd
setwd('/Users/bennettkleinberg/GitHub/information_specificity')

setwd('./liwc')
files = list.files()
load(files[1])
View(liwc)

setwd('../ner')
files = list.files()
load(files[1])
ner = data
View(data)

setwd('../speciteller')
files = list.files()
load(files[1])
View(data)
speciteller = data
names(speciteller)[7:8] = list('polarity_str', 'veracity_str')

#merge liwc and ner data
liwc$veracity_str = liwc$veracity
liwc$polarity_str = liwc$polarity

data1 = merge(ner, liwc, by=c('filename', 'polarity_str', 'veracity_str'))

data2 = merge(data1, speciteller, by=c('filename', 'polarity_str', 'veracity_str'))
data = data2


save(data, file = 'hotel_reviews_all_18122016.RData')

###END
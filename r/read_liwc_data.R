#LIWC
#clear ws
rm(list = ls())

#load deps
setwd('/Users/bennettkleinberg/Documents/Research/app/wp_onACIT/onacit/R_script/R tutorials')

#set wd
setwd('/Users/bennettkleinberg/GitHub/information_specificity/liwc')

files = list.files()


#load expected and unexpected for LIWC
liwc_neg_dec = read.table(files[1], header=T)
liwc_neg_dec$veracity = 'deceptive'

liwc_neg_tru = read.table(files[2], header=T)
liwc_neg_tru$veracity = 'truthful'

liwc_neg = rbind(liwc_neg_dec, liwc_neg_tru)
liwc_neg$polarity = 'negative'


liwc_pos_dec = read.table(files[3], header=T)
liwc_pos_dec$veracity = 'deceptive'

liwc_pos_tru = read.table(files[4], header=T)
liwc_pos_tru$veracity = 'truthful'

liwc_pos = rbind(liwc_pos_dec, liwc_pos_tru)
liwc_pos$polarity = 'positive'


liwc = rbind(liwc_neg, liwc_pos)
liwc$filename = liwc$Filename


save(liwc, file = 'hotel_reviews_liwc_18122016.RData')

###
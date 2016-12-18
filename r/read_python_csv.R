#R pipeline

#clear ws
rm(list = ls())

#load deps

#set wd
setwd('/Users/bennettkleinberg/GitHub/information_specificity')


#read all from directory
files = list.files(pattern = '*.csv')

#refine F
data_pos = read.csv(files[3], header=F)
data_neg = read.csv(files[2], header=F)

data = rbind(data_neg, data_pos)

names(data) = list('filename',
                  'originalpath',
                  'veracity',
                  'polarity',
                  'tokens',
                  'feature1',
                  'feature2',
                  'label',
                  'feature1_unique',
                  'feature2_unique',
                  'label_unique',
                  'ncues',
                  'ner',
                  'ncues_unique',
                  'ner_unique',
                  'nwords',
                  'nsents',
                  'sent_length',
                  'word_length',
                  'nwords_unique',
                  'nlemmas_unique',
                  'nperson',
                  'nnorp',
                  'nfac',
                  'norg',
                  'ngpe',
                  'nloc',
                  'nproduct',
                  'nevent',
                  'nworkofart',
                  'nlaw',
                  'nlanguage',
                  'ndate',
                  'ntime',
                  'npercent',
                  'nmoney',
                  'nquantity',
                  'nordinal',
                  'ncardinal',
                  'nperson_unique',
                  'nnorp_unique',
                  'nfac_unique',
                  'norg_unique',
                  'ngpe_unique',
                  'nloc_unique',
                  'nproduct_unique',
                  'nevent_unique',
                  'nworkofart_unique',
                  'nlaw_unique',
                  'nlanguage_unique',
                  'ndate_unique',
                  'ntime_unique',
                  'npercent_unique',
                  'nmoney_unique',
                  'nquantity_unique',
                  'nordinal_unique',
                  'ncardinal_unique',
                  'ld',
                  'cwd',
                  'ld_lemma',
                  'cwd_lemma',
                  'sent_attr')


data$polarity_num = as.factor(ifelse(data$polarity == '/Users/bennettkleinberg/Documents/Research/CBDMI_Schiphol/re_analysis/op_spam_v1.4/positive_polarity', 0, 1))

data$veracity_num = as.factor(ifelse(data$veracity == '/Users/bennettkleinberg/Documents/Research/CBDMI_Schiphol/re_analysis/op_spam_v1.4/positive_polarity/deceptive_from_MTurk' | data$veracity == '/Users/bennettkleinberg/Documents/Research/CBDMI_Schiphol/re_analysis/op_spam_v1.4/negative_polarity/deceptive_from_MTurk', 0, 1))

#descriptives
table(data$polarity_num, data$veracity_num)

data$veracity_str = data$veracity_num
data$polarity_str = data$polarity_num

levels(data$veracity_str) = c('deceptive', 'truthful')
levels(data$polarity_str) = c('positive', 'negative')

save(data, file = 'hotel_reviews_18122016.RData')

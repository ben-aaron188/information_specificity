#import dependencies
from __future__ import division
import csv
from utils import *
from token_constructs import *
from cues import *
import os
import os.path
from pathlib import Path
import glob
import time
import spacy

dirname = os.path.dirname

def main_extractor(input, outputname, kind):
    timestr = time.strftime("%d%m%Y")
    if len(input) > 0:
        parsed_input = parse_input(input)
        extraction0 = token_based_extraction(parsed_input, kind)
        output_row = [[filename, originalpath, polarity, veracity, extraction0["tokens"], extraction0["feature1"], extraction0["feature2"], extraction0["label"], extraction0["feature1_unique"], extraction0["feature2_unique"], extraction0["label_unique"],
                       extraction0["ncues"], extraction0["ner"], extraction0["ncues_unique"], extraction0["ner_unique"], extraction0["nwords"], extraction0["nsents"], extraction0["sentence_length"], extraction0["word_length"], extraction0["nwords_unique"], extraction0["nlemmas_unique"], extraction0["nperson"], extraction0["nnorp"], extraction0["nfac"], extraction0["norg"], extraction0["ngpe"], extraction0["nloc"], extraction0["nproduct"], extraction0["nevent"], extraction0["nworkofart"], extraction0["nlaw"], extraction0["nlanguage"], extraction0["ndate"], extraction0["ntime"], extraction0["npercent"], extraction0["nmoney"], extraction0["nquantity"], extraction0["nordinal"], extraction0["ncardinal"], extraction0["nperson_unique"], extraction0["nnorp_unique"], extraction0["nfac_unique"], extraction0["norg_unique"], extraction0["ngpe_unique"], extraction0["nloc_unique"], extraction0["nproduct_unique"], extraction0["nevent_unique"], extraction0["nworkofart_unique"], extraction0["nlaw_unique"], extraction0["nlanguage_unique"], extraction0["ndate_unique"], extraction0["ntime_unique"], extraction0["npercent_unique"], extraction0["nmoney_unique"], extraction0["nquantity_unique"], extraction0["nordinal_unique"], extraction0["ncardinal_unique"], extraction0["lexical_diversity_score"], extraction0["content_diversity_score"], extraction0["lexical_diversity_lem_score"], extraction0["content_diversity_lem_score"], extraction0["sent_attr"]]]
    # else:
    #     output_row = [[filename, originalpath, polarity, veracity, 0, 0,
    #                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]
    with open(str(outputname) + '_' + timestr + ".csv", "a") as csvfilevar:
        writer = csv.writer(csvfilevar, lineterminator='\n')
        writer.writerows(output_row)

hotel_reviews_negative = '-- set directory to negative review files --'
hotel_reviews_positive = '-- set directory to positive review files --'

def analyse_files(filepath, outputappendix, kind):
    # take t1
    t1 = time.time()
    for file in Path(filepath).glob('**/*.txt'):
        global filename
        global originalpath
        global polarity
        global veracity
        filename = os.path.basename(str(file))
        originalpath = str(file)
        polarity = dirname(dirname(str(file)))
        veracity = dirname(dirname(dirname(str(file))))
        file_ = open(str(file)).read()
        main_extractor(input=file_, outputname=outputappendix, kind=kind)
    # take t2
    t2 = time.time()
    # output t2-t1
    elapsed_time = t2 - t1
    print(elapsed_time)

#analyse_files(filepath=basedir, outputappendix='basedir_test', kind='count')
analyse_files(filepath=hotel_reviews_negative, outputappendix='hotel_reviews_negative', kind='count')
analyse_files(filepath=hotel_reviews_positive, outputappendix='hotel_reviews_positive', kind='count')

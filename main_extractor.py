#!/usr/local/bin/python3.5

#import dependencies
from __future__ import division
import csv
from utils import *
from cues import *
from token_constructs import *
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
        output_row = [[filename, originalpath, extraction0["tokens_all"], extraction0["tokens_unique"], extraction0["feature1_all"], extraction0["feature1_unique"], extraction0["label_all"], extraction0["label_unique"], extraction0["ncues_all"], extraction0["ncues_unique"], extraction0["ner_time_all"], extraction0["ner_time_unique"], extraction0["ner_person_all"], extraction0["ner_person_unique"], extraction0["ner_loc_all"], extraction0["ner_loc_unique"], extraction0["ner_date_all"], extraction0["ner_date_unique"], extraction0["ner_gpe_all"], extraction0["ner_gpe_unique"], extraction0["lexical_diversity_score"], extraction0["content_diversity_score"], extraction0["lexical_diversity_lem_score"], extraction0["content_diversity_lem_score"]]]
    else:
        output_row = [[filename, originalpath, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]
    with open(str(outputname) + '_' + kind + '_' + timestr + ".csv", "a") as code:
        writer = csv.writer(code, lineterminator='\n')
        writer.writerows(output_row)


#basedir = '/Users/bennettkleinberg/BitBucket/algo_2/spacy/data_'
exp1_all = '/Users/bennettkleinberg/Documents/Research/app/wp_onACIT/onacit/outputfiles/exp1_proper/full_09082016/q_per_file/all_for_coding/spacy'


def analyse_files(filepath, outputappendix, kind):
    # take t1
    t1 = time.time()
    for file in Path(filepath).glob('**/*.txt'):
        global filename
        global originalpath
        # global polarity
        # global veracity
        filename = os.path.basename(str(file))
        originalpath = str(file)
        # polarity = dirname(dirname(str(file)))
        # veracity = dirname(dirname(dirname(str(file))))
        file_ = open(str(file)).read()
        main_extractor(input=file_, outputname=outputappendix, kind=kind)
    # take t2
    t2 = time.time()
    # output t2-t1
    elapsed_time = t2 - t1
    print(elapsed_time)

analyse_files(filepath=exp1_all, outputappendix='algo2_exp1_allquestions', kind='rate')

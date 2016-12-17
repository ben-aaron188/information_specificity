#!/usr/local/bin/python3.5

#import dependencies
from __future__ import division
from utils import *
from cues import *
import spacy

def unique_words(main_input):
    word_array = []
    for token in main_input:
        if token.pos_ is not 'PUNCT':
            word_array.append(str(token))
    unique_n = len(set(word_array))
    return unique_n

def unique_lemmas(main_input):
    word_array = []
    for token in main_input:
        if token.pos_ is not 'PUNCT':
            word_array.append(str(token.lemma_))
    unique_n = len(set(word_array))
    return unique_n

def lexical_diversity(main_input):
    word_array = []
    for token in main_input:
        if token.pos_ is not 'PUNCT':
            word_array.append(str(token))
    unique_n = len(set(word_array))
    overall_n = len(word_array)
    diversity = unique_n/overall_n
    return diversity

def content_diversity(main_input):
    word_array = []
    for token in main_input:
        if token.pos_ is not 'PUNCT' and token.orth_ not in spacy.en.STOPWORDS:
            word_array.append(str(token))
    unique_n = len(set(word_array))
    overall_n = len(word_array)
    diversity = unique_n/overall_n
    return diversity

def lexical_diversity_lem(main_input):
    word_array = []
    for token in main_input:
        if token.pos_ is not 'PUNCT':
            word_array.append(str(token.lemma_))
    unique_n = len(set(word_array))
    overall_n = len(word_array)
    diversity = unique_n/overall_n
    return diversity

def content_diversity_lem(main_input):
    word_array = []
    for token in main_input:
        if token.pos_ is not 'PUNCT' and token.orth_ not in spacy.en.STOPWORDS:
            word_array.append(str(token.lemma_))
    unique_n = len(set(word_array))
    overall_n = len(word_array)
    diversity = unique_n/overall_n
    return diversity

def word_count(main_input):
    word_array = []
    for token in main_input:
        if token.pos_ is not 'PUNCT':
            word_array.append(str(token))
    return len(word_array)

def count_in_list(input_list, target):
    n = input_list.count(target)
    return n

def laplace_div_optional(numerator, denominator):
    if(denominator > 0):
        div = numerator/denominator
    else:
        div = numerator/(denominator + 1)
    return div

def token_based_extraction(main_input, kind):
    token_list = []
    feature1 = []
    label = []
    token_list_unique = []
    feature1_unique = []
    label_unique = []
    for sentence in main_input.sents:
        parsed_sent = parse_input(str(sentence))
        for entity in parsed_sent.ents:
            if entity.label_ in ner_time:
                token_list.append(str(entity))
                feature1.append(entity.label_)
                label.append('ner_time')
                if str(entity) not in token_list_unique:
                    token_list_unique.append(str(entity))
                    feature1_unique.append(entity.label_)
                    label_unique.append('ner_time')
            if entity.label_ in ner_gpe:
                token_list.append(str(entity))
                feature1.append(entity.label_)
                label.append('ner_gpe')
                if str(entity) not in token_list_unique:
                    token_list_unique.append(str(entity))
                    feature1_unique.append(entity.label_)
                    label_unique.append('ner_gpe')
            if entity.label_ in ner_person:
                token_list.append(str(entity))
                feature1.append(entity.label_)
                label.append('ner_person')
                if str(entity) not in token_list_unique:
                    token_list_unique.append(str(entity))
                    feature1_unique.append(entity.label_)
                    label_unique.append('ner_person')
            if entity.label_ in ner_loc:
                token_list.append(str(entity))
                feature1.append(entity.label_)
                label.append('ner_loc')
                if str(entity) not in token_list_unique:
                    token_list_unique.append(str(entity))
                    feature1_unique.append(entity.label_)
                    label_unique.append('ner_loc')
            if entity.label_ in ner_date:
                token_list.append(str(entity))
                feature1.append(entity.label_)
                label.append('ner_date')
                if str(entity) not in token_list_unique:
                    token_list_unique.append(str(entity))
                    feature1_unique.append(entity.label_)
                    label_unique.append('ner_date')
        sent_nwords = word_count(sentence)
    if kind == 'rate':
        ncues = len(token_list)
        ncues_unique = len(token_list_unique)
        nwords = word_count(main_input)
        nsigns = len(main_input.text)
        nsents = len(list(main_input.sents))
        sentence_length = laplace_div_optional(nwords, nsents)
        word_length = laplace_div_optional(nsigns, nwords)
        nwords_unique = unique_words(main_input)
        nlemmas_unique = unique_lemmas(main_input)
        ner_person_all = laplace_div_optional(count_in_list(label, 'ner_person'), nwords)*100
        ner_loc_all = laplace_div_optional(count_in_list(label, 'ner_loc'), nwords)*100
        ner_date_all = laplace_div_optional(count_in_list(label, 'ner_date'), nwords)*100
        ner_gpe_all = laplace_div_optional(count_in_list(label, 'ner_gpe'), nwords)*100
        ner_time_all = laplace_div_optional(count_in_list(label, 'ner_time'), nwords)*100
        ner_person_unique = laplace_div_optional(count_in_list(label_unique, 'ner_person'), nwords)*100
        ner_loc_unique = laplace_div_optional(count_in_list(label_unique, 'ner_loc'), nwords)*100
        ner_date_unique = laplace_div_optional(count_in_list(label_unique, 'ner_date'), nwords)*100
        ner_gpe_unique = laplace_div_optional(count_in_list(label_unique, 'ner_gpe'), nwords)*100
        ner_time_unique = laplace_div_optional(count_in_list(label_unique, 'ner_time'), nwords)*100
    elif kind == 'count':
        ncues = len(token_list)
        ncues_unique = len(token_list_unique)
        nwords = word_count(main_input)
        nsigns = len(main_input.text)
        nsents = len(list(main_input.sents))
        sentence_length = laplace_div_optional(nwords, nsents)
        word_length = laplace_div_optional(nsigns, nwords)
        nwords_unique = unique_words(main_input)
        nlemmas_unique = unique_lemmas(main_input)
        ner_person_all = count_in_list(label, 'ner_person')
        ner_loc_all = count_in_list(label, 'ner_loc')
        ner_date_all = count_in_list(label, 'ner_date')
        ner_gpe_all = count_in_list(label, 'ner_gpe')
        ner_time_all = count_in_list(label, 'ner_time')
        ner_person_unique = count_in_list(label_unique, 'ner_person')
        ner_loc_unique = count_in_list(label_unique, 'ner_loc')
        ner_date_unique = count_in_list(label_unique, 'ner_date')
        ner_gpe_unique = count_in_list(label_unique, 'ner_gpe')
        ner_time_unique = count_in_list(label_unique, 'ner_time')
    lexical_diversity_score = lexical_diversity(main_input)
    content_diversity_score = content_diversity(main_input)
    lexical_diversity_lem_score = lexical_diversity_lem(main_input)
    content_diversity_lem_score = content_diversity_lem(main_input)
    return{"tokens_all": token_list, "tokens_unique": token_list_unique, "feature1_all": feature1, "feature1_unique": feature1_unique, "label_all": label, "label_unique": label_unique, "ncues_all": ncues, "ncues_unique": ncues_unique, "ner_time_all": ner_time_all, "ner_time_unique": ner_time_unique, "ner_person_all": ner_person_all, "ner_person_unique": ner_person_unique, "ner_loc_all": ner_loc_all, "ner_loc_unique": ner_loc_unique, "ner_date_all": ner_date_all, "ner_date_unique": ner_date_unique, "ner_gpe_all": ner_gpe_all, "ner_gpe_unique": ner_gpe_unique, "lexical_diversity_score": lexical_diversity_score, "content_diversity_score": content_diversity_score, "lexical_diversity_lem_score": lexical_diversity_lem_score, "content_diversity_lem_score": content_diversity_lem_score}

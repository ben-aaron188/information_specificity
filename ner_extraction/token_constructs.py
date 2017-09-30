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
    diversity = unique_n / overall_n
    return diversity


def content_diversity(main_input):
    word_array = []
    for token in main_input:
        if token.pos_ is not 'PUNCT' and parser.vocab[token.orth_].is_stop == 0:
            word_array.append(str(token))
    unique_n = len(set(word_array))
    overall_n = len(word_array)
    diversity = unique_n / overall_n
    return diversity


def lexical_diversity_lem(main_input):
    word_array = []
    for token in main_input:
        if token.pos_ is not 'PUNCT':
            word_array.append(str(token.lemma_))
    unique_n = len(set(word_array))
    overall_n = len(word_array)
    diversity = unique_n / overall_n
    return diversity


def content_diversity_lem(main_input):
    word_array = []
    for token in main_input:
        if token.pos_ is not 'PUNCT' and parser.vocab[token.orth_].is_stop == 0:
            word_array.append(str(token.lemma_))
    unique_n = len(set(word_array))
    overall_n = len(word_array)
    diversity = unique_n / overall_n
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
        div = numerator / denominator
    else:
        div = numerator / (denominator + 1)
    return div


def token_based_extraction(main_input, kind):
    token_list = []
    feature1 = []
    feature2 = []
    label = []
    sent_attr = []
    token_list_unique = []
    feature1_unique = []
    feature2_unique = []
    label_unique = []
    for sentence in main_input.sents:
        sent_token_list = []
        sent_feature1 = []
        sent_feature2 = []
        sent_label = []
        parsed_sent = parse_input(str(sentence))
        for entity in parsed_sent.ents:
            if entity.label_ in specifics:
                token_list.append(str(entity))
                feature1.append(entity.label_)
                feature2.append(entity.label)
                label.append('specifics')
                if str(entity) not in token_list_unique:
                    token_list_unique.append(str(entity))
                    feature1_unique.append(entity.label_)
                    feature2_unique.append(entity.label)
                    label_unique.append('specifics')
                sent_token_list.append(str(entity))
                sent_feature1.append(entity.label_)
                sent_feature2.append(entity.label)
                sent_label.append('specifics')
        sent_ner = count_in_list(sent_label, 'specifics')
        sent_nwords = word_count(sentence)
        sent_attr.append([sent_ner, sent_nwords])
    # count
    if kind == 'rate':
        ncues = len(token_list)
        nwords = word_count(main_input)
        nspecifictime = laplace_div_optional(
            count_in_list(label, 'specifictime'), nwords) * 100
        ner = laplace_div_optional(count_in_list(
            label, 'specifics'), nwords) * 100
        nmodifiers = laplace_div_optional(
            count_in_list(label, 'modifiers'), nwords) * 100
        nsigns = len(main_input.text)
        nsents = len(list(main_input.sents))
        sentence_length = laplace_div_optional(nwords, nsents)
        word_length = laplace_div_optional(nsigns, nwords)
        nwords_unique = unique_words(main_input)
        nlemmas_unique = unique_lemmas(main_input)
        nperson = laplace_div_optional(
            count_in_list(feature1, 'PERSON'), nwords) * 100
        nnorp = laplace_div_optional(
            count_in_list(feature1, 'NORP'), nwords) * 100
        nfac = laplace_div_optional(
            count_in_list(feature1, 'FAC'), nwords) * 100
        norg = laplace_div_optional(
            count_in_list(feature1, 'ORG'), nwords) * 100
        ngpe = laplace_div_optional(
            count_in_list(feature1, 'GPE'), nwords) * 100
        nloc = laplace_div_optional(
            count_in_list(feature1, 'LOC'), nwords) * 100
        nproduct = laplace_div_optional(
            count_in_list(feature1, 'PRODUCT'), nwords) * 100
        nevent = laplace_div_optional(
            count_in_list(feature1, 'EVENT'), nwords) * 100
        nworkofart = laplace_div_optional(
            count_in_list(feature1, 'WORK_OF_ART'), nwords) * 100
        nlaw = laplace_div_optional(
            count_in_list(feature1, 'LAW'), nwords) * 100
        nlanguage = laplace_div_optional(
            count_in_list(feature1, 'LANGUAGE'), nwords) * 100
        ndate = laplace_div_optional(
            count_in_list(feature1, 'DATE'), nwords) * 100
        ntime = laplace_div_optional(
            count_in_list(feature1, 'TIME'), nwords) * 100
        npercent = laplace_div_optional(
            count_in_list(feature1, 'PERCENT'), nwords) * 100
        nmoney = laplace_div_optional(
            count_in_list(feature1, 'MONEY'), nwords) * 100
        nquantity = laplace_div_optional(
            count_in_list(feature1, 'QUANTITY'), nwords) * 100
        nordinal = laplace_div_optional(
            count_in_list(feature1, 'ORDINAL'), nwords) * 100
        ncardinal = laplace_div_optional(
            count_in_list(feature1, 'CARDINAL'), nwords) * 100
    elif kind == 'count':
        ncues = len(token_list)
        ncues_unique = len(token_list_unique)
        nwords = word_count(main_input)
        ner = count_in_list(label, 'specifics')
        ner_unique = count_in_list(label_unique, 'specifics')
        nsigns = len(main_input.text)
        nsents = len(list(main_input.sents))
        sentence_length = laplace_div_optional(nwords, nsents)
        word_length = laplace_div_optional(nsigns, nwords)
        nwords_unique = unique_words(main_input)
        nlemmas_unique = unique_lemmas(main_input)
        # non-unique
        nperson = count_in_list(feature1, 'PERSON')
        nnorp = count_in_list(feature1, 'NORP')
        nfac = count_in_list(feature1, 'FAC')
        norg = count_in_list(feature1, 'ORG')
        ngpe = count_in_list(feature1, 'GPE')
        nloc = count_in_list(feature1, 'LOC')
        nproduct = count_in_list(feature1, 'PRODUCT')
        nevent = count_in_list(feature1, 'EVENT')
        nworkofart = count_in_list(feature1, 'WORK_OF_ART')
        nlaw = count_in_list(feature1, 'LAW')
        nlanguage = count_in_list(feature1, 'LANGUAGE')
        ndate = count_in_list(feature1, 'DATE')
        ntime = count_in_list(feature1, 'TIME')
        npercent = count_in_list(feature1, 'PERCENT')
        nmoney = count_in_list(feature1, 'MONEY')
        nquantity = count_in_list(feature1, 'QUANTITY')
        nordinal = count_in_list(feature1, 'ORDINAL')
        ncardinal = count_in_list(feature1, 'CARDINAL')
        # unique
        nperson_unique = count_in_list(feature1_unique, 'PERSON')
        nnorp_unique = count_in_list(feature1_unique, 'NORP')
        nfac_unique = count_in_list(feature1_unique, 'FAC')
        norg_unique = count_in_list(feature1_unique, 'ORG')
        ngpe_unique = count_in_list(feature1_unique, 'GPE')
        nloc_unique = count_in_list(feature1_unique, 'LOC')
        nproduct_unique = count_in_list(feature1_unique, 'PRODUCT')
        nevent_unique = count_in_list(feature1_unique, 'EVENT')
        nworkofart_unique = count_in_list(feature1_unique, 'WORK_OF_ART')
        nlaw_unique = count_in_list(feature1_unique, 'LAW')
        nlanguage_unique = count_in_list(feature1_unique, 'LANGUAGE')
        ndate_unique = count_in_list(feature1_unique, 'DATE')
        ntime_unique = count_in_list(feature1_unique, 'TIME')
        npercent_unique = count_in_list(feature1_unique, 'PERCENT')
        nmoney_unique = count_in_list(feature1_unique, 'MONEY')
        nquantity_unique = count_in_list(feature1_unique, 'QUANTITY')
        nordinal_unique = count_in_list(feature1_unique, 'ORDINAL')
        ncardinal_unique = count_in_list(feature1_unique, 'CARDINAL')
    lexical_diversity_score = lexical_diversity(main_input)
    content_diversity_score = content_diversity(main_input)
    lexical_diversity_lem_score = lexical_diversity_lem(main_input)
    content_diversity_lem_score = content_diversity_lem(main_input)
    return{"tokens": token_list, "feature1": feature1, "feature2": feature2, "label": label, "feature1_unique": feature1_unique, "feature2_unique": feature2_unique, "label_unique": label_unique,
           "ncues": ncues, "ncues_unique": ncues_unique, "ner": ner, "ner_unique": ner_unique, "nwords": nwords, "nsents": nsents, "sentence_length": sentence_length, "word_length": word_length, "nwords_unique": nwords_unique, "nlemmas_unique": nlemmas_unique, "nperson": nperson, "nnorp": nnorp, "nfac": nfac, "norg": norg, "ngpe": ngpe, "nloc": nloc, "nproduct": nproduct, "nevent": nevent, "nworkofart": nworkofart, "nlaw": nlaw, "nlanguage": nlanguage, "ndate": ndate, "ntime": ntime, "npercent": npercent, "nmoney": nmoney, "nquantity": nquantity, "nordinal": nordinal, "ncardinal": ncardinal, "nperson_unique": nperson_unique, "nnorp_unique": nnorp_unique, "nfac_unique": nfac_unique, "norg_unique": norg_unique, "ngpe_unique": ngpe_unique, "nloc_unique": nloc_unique, "nproduct_unique": nproduct_unique, "nevent_unique": nevent_unique, "nworkofart_unique": nworkofart_unique, "nlaw_unique": nlaw_unique, "nlanguage_unique": nlanguage_unique, "ndate_unique": ndate_unique, "ntime_unique": ntime_unique, "npercent_unique": npercent_unique, "nmoney_unique": nmoney_unique, "nquantity_unique": nquantity_unique, "nordinal_unique": nordinal_unique, "ncardinal_unique": ncardinal_unique, "lexical_diversity_score": lexical_diversity_score, "content_diversity_score": content_diversity_score, "lexical_diversity_lem_score": lexical_diversity_lem_score, "content_diversity_lem_score": content_diversity_lem_score, "sent_attr": sent_attr}

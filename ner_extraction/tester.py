text = "My husband and I stayed at the Hyatt Regency while attending a family wedding in Chicago. From the moment we entered the beautiful lobby we were treated as if we were returning friends. Our rooms were ready upon arrival, and they were just as impressive as when I viewed them online. The location couldn't be more convenient to access all of Chicago's shopping and dining areas. We dined in Seston's Chop House, which I highly recommend. The staff at the hotel are professionals who work to make your stay there a grand experience. The Hyatt Regency Chicago is the only place we will stay when we return to the Windy City!"

parsed_input = parse_input(text)

for sentence in parsed_input.sents:
    parsed_sent = parse_input(str(sentence))
    for entity in parsed_sent.ents:
        print(str(entity), entity.label_, entity.label)

word_array = []

for token in parsed_input:
    # if token.pos_ is not 'PUNCT' and token.orth_ not in spacy.en.STOPWORDS:
    # if token.pos_ is not 'PUNCT' and parser.vocab[token.orth_].is_stop == 0:
    if parser.vocab[token.orth_].is_stop != 0:
        print(token.orth_)
        # word_array.append(str(token.lemma_))

unique_n = len(set(word_array))
overall_n = len(word_array)
diversity = unique_n/overall_n

# for sentence in parsed_input.sents:
#     parsed_sent = parse_input(str(sentence))
#     for entity in parsed_sent.ents:
#         token_list.append(str(entity))
#         feature1.append(entity.label_)
#         label.append('ner_time')
#         if str(entity) not in token_list_unique:
#             token_list_unique.append(str(entity))
#             feature1_unique.append(entity.label_)
#             label_unique.append('ner_time')
#     print(token_list, token_list_unique, len(token_list), len(token_list_unique))

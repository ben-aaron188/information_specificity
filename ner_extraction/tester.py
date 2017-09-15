text = "i am going to visit Ravi, who is a doctor at Delhi Medical center, on the 29th of August. I am planning to stay with him for couple of weeks in his house which is at the diplomatic district.  I will meet Ravi, his family and other friends. We are planning to spend some time visiting historic sites in New Delhi and attending a wedding ceremony for Ravi's sister. First i confirmed the dates with Ravi, about the wedding and how much vacation he had. Secondly, I looked on expedia to find the best routes and price for my trip. Then i booked my flight to New Delhi using my credit card. To find the best price for my trip, there was longer flights with cheaper rates but i do prefer quick air trip.  To meet my old friends and be part of a happy event like a wedding. I also feel i will meet new people and have good relationship with them. The weather of New Delhi is something i am not looking forward. It is going to hot and humid. I do carry a tablet and i have few audio books on it, I am going to play them and wait for my journey to go ahead. Ravi is going to pick me up at the airport. Maybe eat and sleep after a long flight. Also, i am planning to go out and have some Delhi's famous tea. Take a day off, rest for a day. Catch up with all my emails and mail at home, Pay bills which are due, Review photos i took during my trip and get ready to go back to work."

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

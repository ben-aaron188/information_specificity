from nltk.tag import StanfordNERTagger
import glob, os, csv


# Specify your working directory
wd = os.getcwd()


# Get entities of given file
def extract_entities(file, polarity, veracity):

    # Load SNER
    st = StanfordNERTagger(
        wd + "/stanford-ner-2014-06-16/classifiers/english.muc.7class.distsim.crf.ser.gz",
        wd + "/stanford-ner-2014-06-16/stanford-ner.jar"
    )

    extracted = st.tag(file.split())
    cleaned = []

    for elem in extracted:
        # Remove all elements that are useless.
        if elem[1] != "O":
            cleaned.append(elem)

    return cleaned


# Read all statements
def read_statements(polarity, veracity):
    data_path = wd + "/op_spam_v1.4/" + polarity +  "/" + veracity
    files = glob.glob(os.path.join(os.getcwd(), data_path , "*.txt"))
    statements = []
    st_properties = []

    for path in files:
        filename = path.split("/")[-1]

        with open(path) as f_input:

            # Read every statement
            text = f_input.read()
            statements.append([text, len(text.split())])

            # Get recognised entities for each statement
            entities = extract_entities(text, polarity, veracity)

            # Add entities and meta information
            st_properties.append([filename, entities, polarity, veracity, len(text.split())])

    return st_properties


# Count the amount of occurrences for the recognised entity types
def get_occurrences(array):
    occurrences = [["LOCATION",0], ["PERSON",0], ["ORGANIZATION",0], ["MONEY",0], ["PERCENT",0], ["DATE",0], ["TIME",0]]

    for elem in array:
        for occurrence in occurrences:
            if occurrence[0] == elem[1]:
                occurrence[1] += 1

    return occurrences


# Analyse the exteacted entities
def analyze(polarity, veracity):
    data = read_statements(polarity, veracity)
    analyzed = []
    filename = polarity + "_" + veracity + ".txt"

    for statement in data:
        entities = statement[1]

        # Get unique occurrences
        unique_entities = list(set((entities)))

        entitycount = len(entities)
        unique_entitycount = len(unique_entities)

        # Get the occurrences
        occurrences = get_occurrences(entities)
        unique_occurrences = get_occurrences(unique_entities)

        analyzed.append([statement[0], occurrences, unique_occurrences, veracity, polarity, statement[4]])

    # Write the results to a .txt file
    with open(filename, 'w') as f:
        stringtowrite = ""

        for elem in analyzed:

            stringtowrite = stringtowrite + elem[0] + ", " + elem[3] + ", " + elem[4] + ", word_count=" + str(elem[5]) + ", " + "total_entity_count=" + str(entitycount) + ", total_unique_entity_count=" + str(unique_entitycount) + ", "

            for occurrence in elem[1]:
                stringtowrite = stringtowrite + (occurrence[0] + "=" + str(occurrence[1]) + ", ")

            for occurrence in elem[2]:
                stringtowrite = stringtowrite + ("unique_" + occurrence[0] + "=" + str(occurrence[1]) + ", ")

            stringtowrite += "\n"

        f.write(stringtowrite)
        f.close()


# ======================== MAIN ========================
# Run the analysis 4 times -> 4 .txt files should be created
analyze("n", "truthful")
analyze("n", "deceptive")
analyze("p", "truthful")
analyze("p", "deceptive")

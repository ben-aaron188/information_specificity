#import dependencies
import os
from spacy.en import English
parser = English()


# input
subject_deps = ['agent', 'csubj', 'csubjpass', 'expl', 'nsubj', 'nsubjpass']
object_deps = ['attr', 'dobj', 'iobj', 'oprd']


# function for forcing director
def force_directory(path):
    if not os.path.exists(path):
        os.makedirs(path)
    os.chdir(path)


def parse_input(file):
    parsed = parser(file)
    return(parsed)

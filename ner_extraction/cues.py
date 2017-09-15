#import dependencies
from utils import *

# --> tag_ in CAPS, pos_ in CAPS, dep_ in lowercase, NE in CAPS!

#specific times (Warmelink)
specific_times = ['DATE', 'TIME']

specifics = ['PERSON', 'NORP', 'FAC', 'ORG', 'GPE', 'LOC', 'PRODUCT', 'EVENT', 'WORK_OF_ART', 'LAW', 'LANGUAGE', 'DATE', 'TIME', 'PERCENT', 'MONEY', 'QUANTITY', 'ORDINAL', 'CARDINAL']

#modal
modifiers = ['advcl', 'advmod', 'mark', 'neg', 'npadvmod']

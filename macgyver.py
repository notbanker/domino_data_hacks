import html2text
import random


def amazing_feats():
    """ Extract list of amazing feats performed by MacGyver"""
    feats= list()
    with open( 'macgyver.html', "r" ) as f:
        for line in f.readlines():
            if '<li>' in line and not '/wiki/Special' in line:
                try:
                    plain_line = html2text.html2text( line )
                    feats.append(plain_line.replace('*',''))
                except:
                    pass
    return feats

if __name__ == "__main__":
    print random.choice( amazing_feats() )

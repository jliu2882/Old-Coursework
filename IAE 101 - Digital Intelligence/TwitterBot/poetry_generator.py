# IAE 101
# Project 04 - Poetry Generator Recycled
# Jack Liu
# 112655156
# JALLIU
# 11/15/2019
# poetry_generator.py

import nltk
import pronouncing
import random
import re
text = ['austen-emma.txt', 'austen-persuasion.txt', 'austen-sense.txt', 'bible-kjv.txt',
'blake-poems.txt', 'bryant-stories.txt', 'burgess-busterbrown.txt',
'carroll-alice.txt', 'chesterton-ball.txt', 'chesterton-brown.txt',
'chesterton-thursday.txt', 'edgeworth-parents.txt', 'melville-moby_dick.txt',
'milton-paradise.txt', 'shakespeare-caesar.txt', 'shakespeare-hamlet.txt',
'shakespeare-macbeth.txt', 'whitman-leaves.txt']
choice = random.choice(text)
my_corpus = nltk.corpus.gutenberg.words(choice)
bigrams = nltk.bigrams(my_corpus)
cfd = nltk.ConditionalFreqDist(bigrams)
def count_syllables(word):
    phones = pronouncing.phones_for_word(word)
    count_list = [pronouncing.syllable_count(x) for x in phones]
    if len(count_list) > 0:
        result = max(count_list)
    else:
        result = sylco(word)
    return result
def sylco(word) : #https://stackoverflow.com/questions/46759492/syllable-count-in-python
    #Hard coding cases where syllables are different
    #Put in hard work for this but this function covered most of it :D
    if(word == "Mawile" or word == "Steenee" or word == "Eevee" or word == "Nosepass" or word == "Moltres"
       or word == "Meowth" or word == "Loudred" or word == "Pineco" or word == "Starmie" or word == "Type:Null"
       or word == "Floette" or word == "Mudsdale" or word == "Lombre" or word == "Florges" or word == "Buzzwole"
       or word == "Scrafty" or word == "Drowzee" or word == "Uxie" or word == "Spritzee" or word == "Tympole"
       or word == "Glalie" or word == "Gorebyss"):
        return 2
    if(word == "MimeJr." or word == "Deoxys" or word == "Drapion" or word == "Zorua" or word == "Hitmonlee"
       or word == "Xurkitree" or word == "Pikachu" or word == "Sylveon" or word == "Flabebe" or word == "Arceus"
       or word == "Jolteon" or word == "Regice" or word == "Dialga" or word == "Phione" or word == "Politoed"
       or word == "Litleo" or word == "Latias" or word == "Herdier" or word == "Minior" or word == "Xerneas"
       or word == "Pidgeot" or word == "Ribombee" or word == "Cosmoem" or word == "Duosion" or word == "Elgyem"
       or word == "Ferroseed" or word == "Sealeo" or word == "Butterfree" or word == "Espeon" or word == "Kecleon"
       or word == "Finneon" or word == "Karrablast" or word == "Caterpie" or word == "Mareanie" or word == "Dragalge"
       or word == "Registeel" or word == "Yveltal" or word == "Archeops" or word == "Popplio" or word == "Gothitelle"
       or word == "Glaceon" or word == "Keldeo" or word == "Cacnea" or word == "Sableye"  or word == "Kirlia"
       or word == "Lugia" or word == "Tropius" or word == "Mr.Mime" or word == "Kyogre" or word == "Dugtrio"
       or word == "Cottonee" or word == "Luxio" or word == "Quagsire" or word == "Doduo" or word == "Diancie"
       or word == "Umbreon" or word == "Riolu" or word == "Geodude" or word == "Dedenne" or word == "Palkia"
       or word == "Glameow" or word == "Flareon"):
        return 3
    if(word == "NidoranM" or word == "Meloetta" or word == "Mightyena" or word == "Altaria" or word == "Cryogonal"
       or word == "Terrakion" or word == "Roselia" or word == "Mismagius" or word == "Braviary" or word == "Cresselia"
       or word == "Heliolisk" or word == "Virizion" or word == "Porygon-Z" or word == "Zeraora" or word == "Volcanion"
       or word == "Teddiursa" or word == "Ariados" or word == "Leafeon" or word == "Bastiodon" or word == "Cobalion"
       or word == "Igglybuff" or word == "Reuniclus" or word == "Empoleon" or word == "Lumineon" or word == "Lucario"
       or word == "Wigglytuff" or word == "Meganium" or word == "Vaporeon" or word == "Serperior" or word == "Poochyena"
       or word == "Staravia" or word == "Jigglypuff" or word == "Charmeleon" or word == "Decidueye" or word == "Solgaleo"
       or word == "Porygon2" or word == "Rhyperior"):
        return 4
    if(word == "NidoranF" or word == "Electivire" or word == "Helioptile" or word == "Oricorio" or word == "Feraligatr"):
        return 5
    word = word.lower()
    exception_add = ['serious','horatio','proceeded','baffled','crucial','sometimes','fire']
    exception_del = ['fortunately','could','agreeable','rule','unfortunately','something','harvillle','engagement']
    co_one = ['cool','coach','coat','coal','count','coin','coarse','coup','coif','cook','coign','coiffe','coof','court']
    co_two = ['coapt','coed','coinci']
    pre_one = ['preach']
    syls = 0
    disc = 0
    if len(word) <= 3 :
        syls = 1
        return syls
    if word[-2:] == "es" or word[-2:] == "ed" :
        doubleAndtripple_1 = len(re.findall(r'[eaoui][eaoui]',word))
        if doubleAndtripple_1 > 1 or len(re.findall(r'[eaoui][^eaoui]',word)) > 1 :
            if word[-3:] == "ted" or word[-3:] == "tes" or word[-3:] == "ses" or word[-3:] == "ied" or word[-3:] == "ies" :
                pass
            else :
                disc+=1
    le_except = ['whole','mobile','pole','male','female','hale','pale','tale','sale','aisle','whale','while']
    if word[-1:] == "e" :
        if word[-2:] == "le" and word not in le_except :
            pass
        else :
            disc+=1
    doubleAndtripple = len(re.findall(r'[eaoui][eaoui]',word))
    tripple = len(re.findall(r'[eaoui][eaoui][eaoui]',word))
    disc+=doubleAndtripple + tripple
    numVowels = len(re.findall(r'[eaoui]',word))
    if word[:2] == "mc" :
        syls+=1
    if word[-1:] == "y" and word[-2] not in "aeoui" :
        syls +=1
    for i,j in enumerate(word) :
        if j == "y" :
            if (i != 0) and (i != len(word)-1) :
                if word[i-1] not in "aeoui" and word[i+1] not in "aeoui" :
                    syls+=1
    if word[:3] == "tri" and word[3] in "aeoui" :
        syls+=1
    if word[:2] == "bi" and word[2] in "aeoui" :
        syls+=1
    if word[-3:] == "ian" :
        if word[-4:] == "cian" or word[-4:] == "tian" :
            pass
        else :
            syls+=1
    if word[:2] == "co" and word[2] in 'eaoui' :

        if word[:4] in co_two or word[:5] in co_two or word[:6] in co_two :
            syls+=1
        elif word[:4] in co_one or word[:5] in co_one or word[:6] in co_one :
            pass
        else :
            syls+=1
    if word[:3] == "pre" and word[3] in 'eaoui' :
        if word[:6] in pre_one :
            pass
        else :
            syls+=1
    negative = ["doesn't", "isn't", "shouldn't", "couldn't","wouldn't"]
    if word[-3:] == "n't" :
        if word in negative :
            syls+=1
        else :
            pass
    if word in exception_del :
        disc+=1
    if word in exception_add :
        syls+=1
    return numVowels - disc + syls

def random_word_generator(source = None, num = 1):
    result = []
    while source == None or not source[0].isalpha():
        source = random.choice(my_corpus)
    word = source
    result.append(word)
    newword = None
    while len(result) < num:
        if word in cfd:
            init_list = list(cfd[word].keys())
            choice_list = [x for x in init_list if x[0].isalpha()]
            if len(choice_list) > 0:
                newword = random.choice(choice_list)
                result.append(newword)
                word = newword
            else:
                word = None
                newword = None
        else:
            while newword == None or not newword[0].isalpha():
                newword = random.choice(my_corpus)
            result.append(newword)
            word = newword
    return result

def generate_line(length,word):
    i=length-sylco(word)
    line = word
    while(i>0):
        new_word = random.choice(random_word_generator(word,5))
        i=i-sylco(new_word)
        while(i<0):
            i=i+sylco(new_word)
            new_word = random.choice(random_word_generator(word,5))
            i=i-sylco(new_word)
        line= line + " " + new_word #adds spaces between words
        word = new_word
    return line + "\n"

def haiku(word):
    poem = generate_line(5,word) + generate_line(7,word) + generate_line(5,word)
    return poem

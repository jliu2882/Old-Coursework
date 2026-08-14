# IAE 101
# Project 04 - Poetry Generator
# Jack Liu
# 112655156
# JALLIU
# 11/15/2019
# poetry_generator.py

import nltk
import pronouncing
import random
text = ['austen-emma.txt', 'austen-persuasion.txt', 'austen-sense.txt', 'bible-kjv.txt',
'blake-poems.txt', 'bryant-stories.txt', 'burgess-busterbrown.txt',
'carroll-alice.txt', 'chesterton-ball.txt', 'chesterton-brown.txt',
'chesterton-thursday.txt', 'edgeworth-parents.txt', 'melville-moby_dick.txt',
'milton-paradise.txt', 'shakespeare-caesar.txt', 'shakespeare-hamlet.txt',
'shakespeare-macbeth.txt', 'whitman-leaves.txt']
choice = "bible-kjv.txt"
# choice = random.choice(text)
my_corpus = nltk.corpus.gutenberg.words(choice)
bigrams = nltk.bigrams(my_corpus)
cfd = nltk.ConditionalFreqDist(bigrams)

# This function takes two inputs:
# source - a word represented as a string
# num - an integer
# The function will generate num random related words using
# the CFD based on the bigrams in our corpus, starting from
# source. So, the first word will be generated from the CFD
# using source as the key, the second word will be generated
# using the first word as the key, and so on.
# If the CFD list of a word is empty, then a random word is
# chosen from the entire corpus.
# The function returns a num-length list of words.
old = """def random_word_generator(source, num):
    result = []
    word = source.lower()
    for i in range(num):
        stopInt = 5
        if word in cfd and len(list(cfd[word].keys())) > 0 and 5-i <= len(list(cfd[word].keys())):
            newword = random.choice(list(cfd[word].keys()))
            while not newword[0].isalpha():
                newword = random.choice(list(cfd[word].keys()))
                if(stopInt<=0):
                    newword = random.choice(list(cfd[random.choice(my_corpus)].keys()))
                stopInt=stopInt-1
            result.append(newword)
            word = newword
        else:
            newword = random.choice(my_corpus)
            while not newword[0].isalpha():
                newword = random.choice(my_corpus)
                if(stopInt<=0):
                    newword = random.choice(list(cfd[random.choice(my_corpus)].keys()))
                stopInt=stopInt-1
            result.append(newword)
            word = newword
    return result"""
def random_word_generator(source = None, num = 1):
    result = []
    while source == None or not source[0].isalpha():
        source = random.choice(my_corpus)
    word = source
    result.append(word)
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

# This function takes a single input:
# word - a string representing a word
# The function returns the number of syllables in word as an
# integer.
# If the return value is 0, then word is not available in the CMU
# dictionary.
def count_syllables(word):
    phones = pronouncing.phones_for_word(word)
    count_list = [pronouncing.syllable_count(x) for x in phones]
    if len(count_list) > 0:
        result = max(count_list)
    else:
        result = 2**99#This is the simplest way to ensure words not in the dictionary don't appear in syllable-dependant poems, because no one needs that many syllables
                            #NOTE: that is not necessarily true, people may want a crazy long poem, and returning float('inf') syllables will break the code
    return result

# This function takes a single input:
# word - a string representing a word
# The function returns a list of words that rhyme with
# the input word.
def get_rhymes(word):
    result = pronouncing.rhymes(word)
    return result

# This function takes a single input:
# word - a string representing a word
# The function returns a list of strings. Each string in the list
# is a sequence of numbers. Each number corresponds to a syllable
# in the word and describes the stress placed on that syllable
# when the word is pronounced.
# A '1' indicates primary stress on the syllable
# A '2' indicates secondary stress on the syllable
# A '0' indicates the syllable is unstressed.
# Each element of the list indicates a different way to pronounce
# the input word.
def get_stresses(word):
    result = pronouncing.stresses_for_word(word)
    return result

# Use this function to generate each line of your poem.
# This is where you will implement the rules that govern
# the construction of each line.
# For example:
#     -number of words or syllables in line
#     -stress pattern for line (meter)
#     -last word choice constrained by rhyming pattern
# Add any parameters to this function you need to bring in
# information about how a particular line should be constructed.
def generate_line(length = 0, syllable = False,rhyme=""):
    word = random.choice(my_corpus)
    
    while(not word.isalpha()): #ensures first word is a word
        word = random.choice(my_corpus)
    i=length-1
    if(syllable):
        i=length-count_syllables(word)
        while(i<0):
            i=i+count_syllables(word)
            word = random.choice(random_word_generator(word,5))
            i=i-count_syllables(word)
    line = word
    while(i>0):
        #TODO implement rhyme and syllable count; shouldn't be too hard but it will code uglier than it already is
        if(i==1 and len(rhyme)>0):
            line= line + " " + (rhyme if len(get_rhymes(rhyme))==0 else random.choice(get_rhymes(rhyme)))
            break
        new_word = random.choice(random_word_generator(word,5))
        
        if(syllable):
            i=i-count_syllables(new_word)
            while(i<0):
                i=i+count_syllables(new_word)
                new_word = random.choice(random_word_generator(word,5))
                i=i-count_syllables(new_word)
        else:
            i-=1
        line= line + " " + new_word #adds spaces between words
        word = new_word
    return line + "\n"

# Use this function to construct your poem, line by line.
# This is where you will implement the rules that govern
# the structure of your poem.
# For example:
#     -The total number of lines
#     -How the lines relate to each other (rhyming, syllable counts, etc)
def generate_poem(typeOfPoem="none"):
    poem = ""
    typeOfPoem = typeOfPoem.lower()
    if(typeOfPoem == "none"):
        typeOfPoem = random.choice(["haiku","limerick","couplet","rhyme","rhyme2","rhyme3"])
        
    if(typeOfPoem.lower()=="couplet"):
        word = random.choice(my_corpus)
        while((not word.isalpha()) or len(get_rhymes(word))==0):
            word = random.choice(my_corpus)
        poem = "Poem generated: Couplet \nRhyme Scheme: AA \n\n" + generate_line(10,False,word) + generate_line(10,False,word)
        
    if(typeOfPoem.lower()=="rhyme"):
        rhymeA = random.choice(my_corpus)
        while((not rhymeA.isalpha()) or len(get_rhymes(rhymeA))==0):
            rhymeA = random.choice(my_corpus)
        rhymeB = random.choice(my_corpus)
        while(rhymeB in get_rhymes(rhymeA) or (not rhymeB.isalpha()) or len(get_rhymes(rhymeB))==0):
            rhymeB = random.choice(my_corpus)
        poem = "Poem generated: No Style \nRhyme Scheme: AABB \n\n" + generate_line(5,False,rhymeA) + generate_line(5,False,rhymeA) + generate_line(5,False,rhymeB) + generate_line(5,False,rhymeB)

    if(typeOfPoem.lower()=="rhyme2"):
        rhymeA = random.choice(my_corpus)
        while((not rhymeA.isalpha()) or len(get_rhymes(rhymeA))==0):
            rhymeA = random.choice(my_corpus)
        rhymeB = random.choice(my_corpus)
        while(rhymeB in get_rhymes(rhymeA) or (not rhymeB.isalpha()) or len(get_rhymes(rhymeB))==0):
            rhymeB = random.choice(my_corpus)
        poem = "Poem generated: No Style \nRhyme Scheme: ABAB \n\n" + generate_line(5,False,rhymeA) + generate_line(5,False,rhymeB) + generate_line(5,False,rhymeA) + generate_line(5,False,rhymeB)
        
    if(typeOfPoem.lower()=="rhyme3"):
        rhymeA = random.choice(my_corpus)
        while((not rhymeA.isalpha()) or len(get_rhymes(rhymeA))==0):
            rhymeA = random.choice(my_corpus)
        rhymeB = random.choice(my_corpus)
        while(rhymeB in get_rhymes(rhymeA) or (not rhymeB.isalpha()) or len(get_rhymes(rhymeB))==0):
            rhymeB = random.choice(my_corpus)
        poem = "Poem generated: No Style \nRhyme Scheme: ABAB \n\n" + generate_line(5,True,rhymeA) + generate_line(5,True,rhymeA) + generate_line(5,True,rhymeB) + generate_line(5,True,rhymeB)
        
    if(typeOfPoem.lower()=="haiku"):
        poem = "Poem Generated: Haiku \nSyllable Scheme: 5 7 5 \n\n" + generate_line(5,True) + generate_line(7,True) + generate_line(5,True)
        
    if(typeOfPoem.lower()=="limerick"):
        rhymeA = random.choice(my_corpus)
        while((not rhymeA.isalpha()) or len(get_rhymes(rhymeA))==0):
            rhymeA = random.choice(my_corpus)
        rhymeB = random.choice(my_corpus)
        while(rhymeB in get_rhymes(rhymeA) or (not rhymeB.isalpha()) or len(get_rhymes(rhymeB))==0):
            rhymeB = random.choice(my_corpus)
        poem = "Poem Generated: Limerick \nRhyme Scheme: AABBA \n\n" + generate_line(7,False,rhymeA)+generate_line(7,False,rhymeA)+generate_line(5,False,rhymeB)+generate_line(5,False,rhymeB)+generate_line(7,False,rhymeA)
        
    #TODO implement other poems, maybe some that involve the get stress function ie. iambic pentameter
        
    return "Source text : " + str(choice)[:-4] + "\n" + poem

def test():
    keep_going = True
    while keep_going:
        word = input("Please enter a word (Enter '0' to quit): ")
        if word == '0':
            keep_going = False
        elif word == "":
            pass
        else:
            print(cfd[word].keys(), cfd[word].values())
            print()
            print("Random 5 words following", word)
            print(random_word_generator(word, 5))
            print()
            print("Pronunciations of", word)
            print(pronouncing.phones_for_word(word))
            print()
            print("Syllables in", word)
            print(count_syllables(word))
            print()
            print("Rhymes for", word)
            print(get_rhymes(word))
            print()
            print("Stresses for", word)
            print(get_stresses(word))
            print()

if __name__ == "__main__":
    #test()
    my_poem = generate_poem("rhyme3")
    print(my_poem)

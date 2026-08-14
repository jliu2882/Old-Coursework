# Jack Liu
# JALLIU
# 112655156
# Homework 1
import re

# Problem 1 - Nice Strings
def is_nice(s):
    d = dict()
    for char in s:
        if char in d:
            d[char] = d[char] + 1
        else:
            d[char] = 1
    last = d[s[0:1]] if len(s) > 0 else 0 #catch edge case where length is 0
    for k, v in d.items():
        if v != last:
            return "HARD NO"
        last = v
    return "HARD YES"


# Problem 2 - Balanced Brackets
def is_balanced(s):
    l = []
    for char in s:
        if char == ")":
            if l.pop() != "(":
                return False
        elif char == "}":
            if l.pop() != "{":
                return False
        elif char == "]":
            if l.pop() != "[":
                return False
        else: # can add cases for ([{ if we want to include non brackets
            l.append(char)
    return True


# Problem 3 - Functional Programming
def apply_fun(l, fun):
    return [x for x in range(len(l)) if fun(l[x])] #accidentally did without list comprehension at first

def even(x):
    return x % 2 == 0


# Problem 4 - Representing Filesystems
class FS_Item():
    def __init__(self, name):
        self.name = name
   
class Folder(FS_Item):
    def __init__(self, name):
        FS_Item.__init__(self, name)
        self.items = []
    def add_item(self, item): #assumes input is correct, too lazy to enforce it haha
        self.items.append(item)

class File(FS_Item):
    def __init__(self, name, size):
        FS_Item.__init__(self, name)
        self.size = size


def load_fs(ls_output):
    f = open(ls_output, 'r') #reads the file
    topLevel = Folder(".") #creates the toplevel folder; assuming always named . could technically read firstline and parse that
    current = topLevel #current folder to add to will be the toplevel until we reach some line
    for line in f:
        delimited = re.sub(' +', ' ', line).rstrip().split(" ") #removes formatting spaces and splits by white space to get appropiate data
        firstLetter = "" if len(delimited[0])<1 else delimited[0][0] #skips blank lines
        if firstLetter == "-": #we know it must be a file
            size = delimited[4]
            name = delimited[8]
            current.add_item(File(name,size))
        elif firstLetter == "d": #we know it must be a folder
            name = delimited[8]
            current.add_item(Folder(name))
        elif firstLetter == ".": #we know this tells us which folder we are now in
            pathToCurrent = delimited[0][2:-1].split("/") #gets path to current folder, assuming
            current = topLevel                                  #that we start at the topLevel
            if(pathToCurrent[0] == ''):
                continue #do not accept first case, since it is fine
            for i in range(len(pathToCurrent)):#goes through the path to current and tries to find current; which should have been added previously
                for j in current.items: #loops through list of items(super inefficient, and also list comprehension wasn't working as nice as I wanted so)
                    if(j.name == pathToCurrent[i]): #if it matches the first directory,
                        current = j #update current, and moves through the list
    f.close()
    return topLevel #started commenting this because i got lost halfway and had to delete everything !lol

# Problem 5 - Decoding
def decode(ct):
    prev = 17 #allows us to auto-adjust for the first character
    for i in range(len(ct)):
        if ct[i:i+1].isalpha():
            current = alphabet_list.index( chr(ord(ct[i:i+1])).lower() ) - prev # some cool modulo property or smth;
            value = 65 if ct[i:i+1].isupper() else 97 #choose the proper unicode set; upper/lower
            while current<value:
                current=current+26
            ct = ct[0:i]+chr(current)+ct[i+1:]
            prev = current
    return ct
    
alphabet_list = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
def code(ct): #started with this to reverse engineer decode and would feel bad deleting it so here ya go i guess
    prev = 17 # used to add 17 to first char
    current = 0
    for i in range(len(ct)):
        if ct[i:i+1].isalpha():
            current = ord(ct[i:i+1])
            ct = ct[0:i]+alphabet_list[int((current+prev)%26)]+ct[i+1:] if ct[i:i+1].islower() else ct[0:i]+alphabet_list[int((current+prev)%26)].upper()+ct[i+1:] 
            prev = current
    return ct


# Testing functions // Debug Zone
if __name__ == "__main__":
    isNiceTest = 'abcdefghhgfedcba'
    isBalancedTest = '{{[[(())]]}}'
    applyFunTest = [2,3,4,5,6,8]
    loadFSFile = "lsoutput.txt"
    decodeTest = """"M qcura wthl rrscmc q yyew qsxgthhh drkjh F vtoyat bw qgvlhqnr pmdjrb, rhz ymxd B fhqxftpt R qcura poqsiw xmx scmzvhdt uvut df vdsjhwfuhlcds hvtzmdbp godulyt dn smx scmnbzx cefjbifnji.Gh mtp qrud vmbi lvlh 35000 khuxv sr vs smhbs jmxd, vqnm lxnfi knt rsiv fsxgthlhf, thz usrbnnyv, M rdn's pjnw, i xfnyqb ktcth 35000 khuxv sf dmvpyi, wihluxp, fboko, tmxkc, ezc bsymw qcnrysct.Jy e txqdwqbiw oefifhf eyovbhd, S kie e fjhulvyb vrufrxh." --Wmxgthebt"""
    
    print(is_nice(isNiceTest))
    print(is_balanced(isBalancedTest))
    print(apply_fun(applyFunTest, even))
#    print(load_fs(loadFSFile))#removed lsoutputs from folder
    print(decode(decodeTest))

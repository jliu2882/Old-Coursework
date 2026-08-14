# Jack Liu
# JALLIU
# 112655156
# Homework 1
import re

# Problem 1 - highlight
def highlight(pattern, string):
    pat = re.compile(pattern) #Compiles the pattern
    match = pat.search(string) #Apply the pattern to the string
    if match is None: #Catches case where there is no match
        return None
    return string.replace(match[0],"<"+match[0]+">",1) #Replace the first instance of the first match with a version with angle brackets

# Problem 2 - highlight_all
def highlight_all(pattern, string):
    pat = re.compile(pattern) #Compiles the pattern
    if pat.search(string) is None: #Catches case where there is no match
        return None
    matches = pat.finditer(string) #Find all matches in the string with their indices
    newStr = "" #Build a new string, since we can't reverse iterators :(
    last = 0 #Keep track of the last part of the string we appended
    for match in matches:
        newStr=newStr+string[last:match.span()[0]]+"<"+string[match.span()[0]:match.span()[1]]+">" #Add the match with angle brackets
        last = match.span()[1] #Update last
    newStr = newStr + string[last:] #Add rest of string after the last match 
    return newStr #return re.sub("("+pattern+")","<\\1>",string) nvm groups make this not work :(

# Problem 3 - ruin_a_webpage
def ruin_a_webpage(filename):
    if re.search(".*\.(html|htm)$",filename) is None: #Catches the case where the file does not have a .html or .htm extensions
        return None
    try: #Catches the case where the file does not exist
        with open(filename,mode='r') as inFile: #Opens the filename in read mode
            with open("ruined.html", mode='w') as outFile: #Creates the file to write to called ruined.html
                text = inFile.read() #Reads the file in one string
                pTag = re.search("([\w\W]*)<p>([\w\W]*?)</p>",text) #Searches for the first case of <p>text</p>; not that text must not contain any <p> </p>
                while pTag is not None: #As long as there exists a case of that
                    text = text.replace(pTag.group(0),pTag.group(1)+pTag.group(2)+"<br><br>") #Replace it using groups
                    pTag = re.search("([\w\W]*)<p>([\w\W]*?)</p>",text) #Finds the next case
                #Note: we can extend this to p tags with id, css, spaces, etc... with a \s*(spaces) and .*=.*(general tag properties) before and after; bft we shouldn't
                spanTag = re.search("([\w\W]*)<span>([\w\W]*?)</span>",text) #Same thing, but uses span tag instead of p
                while spanTag is not None: #Comment here, but it's the same as the one above
                    text = text.replace(spanTag.group(0),spanTag.group(1)+spanTag.group(2)) #Replace it etc. etc..
                    spanTag = re.search("([\w\W]*)<span>([\w\W]*?)</span>",text) #same thing
                outFile.write(text) #Writes the text to the output file
    except FileNotFoundError:
       return 'File does not exist' #File does not exist so end program
    return True #File exists, and operator was successful

# Problem 4 - decompose_path
def decompose_path(path):
    if(len(path)==0): #Makes sure the empty string returns an empty list not a list with the empty string
        return []
    l = [x[0:-1] for x in re.findall(".*?:",path)] #Adds all but the last directory using regex rather than str.replace()
    l.append(re.sub(".*:(.*)","\\1",path)) #Abuses the greedy algorithm to reach the last directory, and use grouping to substitute path with that directory
    #l.append(path.split(":")[-1]) Added the last directory with regex to be safe, but this is more readable :)
    return l

# Problem 5 - link_mapper
def link_mapper(filename):
    if re.search(".*\.(html|htm)$",filename) is None: #Catches the case where the file does not have a .html or .htm extensions
        return None
    try: #Catches the case where the file does not exist
        l = [] #List will not necessarily be in order of first to last tag
        d = {filename:l}
        with open(filename,mode='r') as inFile: #opens the file
            text = inFile.read() #Reads the file in one string
            anchorTags = re.search('[\w\W]*(<a href="(.*)">([\w\W]*?)</a>)',text) #Find the first pair of anchor tags without any anchor tags inside it
            while anchorTags is not None: #As long as we have some hyperlink, we should append it to the list
                l.append((anchorTags.group(2),anchorTags.group(3))) #Adds the tuple for the anchor tag in the list; link doesn't necessarily need to be "http, etc,etc."
                text = text.replace(anchorTags.group(1),"",1) #Update text so it doesnt contain the first pair of anchor
                anchorTags = re.search('[\w\W]*(<a href="(.*)">([\w\W]*?)</a>)',text) #Find the next pair; can include cases with space but we were told to assume the links are the same as the example
    except FileNotFoundError:
       return 'File does not exist' #File does not exist so end program
    return d

# Problem 6 - grammarly
def grammarly(text):
    #1. "i" instead of "I"
    text = re.sub(r"\bi\b",r"I",text) #Replaces any i that are not part of a word with I
    #4. Repeated word; This is first since changes in the text can change what is repeating or not
    repeat = re.search(r"(\b\w+\b)\s+\1",text) #Finds occurences of repeated words; We use .+ vs \w+ in cases of I'm I'm
    while repeat is not None: #As long as we can find something of that sort, we will fix it
        text = re.sub(r"(\b\w+\b)\s+\1",r"\1",text) #Fixes it with a single copy
        repeat = re.search(r"(\b\w+\b)\s+\1",text) #Searches for more repeated words
    #2. Uncapitalized beginning of a sentence; Considers start of newline/opening parenthesis as start of a sentence
    pattern = re.search(r"(.*[\n.?!(][\W]*?)\b([a-z])",text) #Finds occurrences of a sentence end/parenthesis opening/newlines and uncapitalized letters
    while pattern is not None: #As long as that pattern exists, we will try to remove it
        text = pattern.group(1) + pattern.group(2).upper() + text[pattern.span()[1]:] #We remove it by using groups to capitalize the lowercase letter
        pattern = re.search(r"(.*[\n.?!(][\W]*?)\b([a-z])",text) #Finds any new occurence of the pattern
    pattern = re.search(r"^([\W]*?)\b([a-z])",text) #Finds the first letter given that it's lowercase
    if pattern is not None: #As long as it exists
        text = pattern.group(1) + pattern.group(2).upper() + text[pattern.span()[1]:] #Capitalize the first letter in the sentence
    #3. Using "a" when you should use "an"
    vowels = re.search(r"\sa\s([aeiouAEIOU])",text) #Finds occurences of 'a [vowel]'
    while vowels is not None: #As long as we can find something of that sort, we will fix it
        text = re.sub(r"\sa\s([aeiouAEIOU])",r" an \1",text) #Fixes it with 'an [vowel]'; we aren't here to fix 'an [consanant]'
        vowels = re.search(r"\sa\s([aeiouAEIOU])",text) #Searches for more incorrect versions
    #5. Missing Oxford Comma; Applies over newlines
    comma = re.search(r"(.*,\s*\w*[^,.!?]+)((\s+and\s+)|(\s+or\s+))",text) #Searches for cases where we have one comma and the keywords "and" or "or" without a comma
    while comma is not None: #If such a case does exist, we should handle it
        text = re.sub(r"(.*,\s*\w*[^,.!?]+)((\s+and\s+)|(\s+or\s+))",r"\1,\2",text) #Replaces this with the Oxford comma
        comma = re.search(r"(.*,\s*\w*[^,.!?]+)((\s+and\s+)|(\s+or\s+))",text) #Finds the next such case
    #6. Unclosed parentheses; didn't use regex for this, but it wasn't specified to use regex for all of them, and I tried to use regex as much as possible
    matchIndex = [] #Keeps an index of indexes where we have matching parenthesis; could do this recursively with regex, but removing parenthesis will change indexes
    parenthesis = [] #Keeps a list of open parenthesis
    for i in range(len(text)): #Loop through the characters
        if text[i] == '(': #Case of open parenthesis
            parenthesis.append(i) #Add it to our list
        if text[i] == ')': #Case of close parenthesis
            if len(parenthesis) > 0: #If we have any open parenthesis
                matchIndex.append(parenthesis.pop()) #remove it and add it to our matching parenthesis index
                matchIndex.append(i) #Also add our current index
    matchIndex.sort() #Sort the list so can we can iterate through our text backwards
    for i in reversed(range(len(text))): #Iterate through the text backwards
        if text[i] == '(' or text[i] == ')': #If the character is a parenthesis, we should check if it's matched
            if len(matchIndex)>0 and i == matchIndex[len(matchIndex) - 1]: #If it is a match (assuming there is a match to check), we should not remove it
                matchIndex.pop() #We should pop it from the list, so we don't check it again
            else: #If it isn't a match, we should remove it
                text = text[0:i]+text[i+1:] #Remove the current character
    return text

# Testing functions // Debug Zone
if __name__ == "__main__":
    pattern = r'o\w+'
    string = r"I'm Commander Shepard and this is my favorite store on the Citadel."
    filename = r"text.html"
    path = "/usr/openwin/bin:/usr/ucb:/usr/bin:/bin:/etc:/usr/local/bin:/usr/local/lib:/usr/shareware/bin:/usr/shareware/lib:."
    filename2 = r"text2.html"
    wrong = ")a favorite companion and friend of mine is is Garrus, Wrex or Tali. 'that's what i I i think as as well or not?' (what a a a a a pretty (unlikely))) coincidence.(\"i agree\"(i'm i'm a a a a a agreeable person, oh hi). a a a a great day to be sure. There's nice weather, good food and whatnot.("

    print(highlight(pattern,string))
    print(highlight_all(pattern,string))
    print(ruin_a_webpage(filename))
    print(decompose_path(path))
    print(link_mapper(filename2))
    print(grammarly(wrong))

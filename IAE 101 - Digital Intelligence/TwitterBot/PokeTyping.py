# PokeTyping.py
# IAE 101, Fall 2019
# Project 02 - Building a Twitterbot
# Name: Jack Liu      
# netid: jalliu      
# Student ID: 112655156

types = ["normal","fire","water","electric","grass","ice","fighting","poison","ground","flying","psychic","bug","rock","ghost","dragon","dark","steel","fairy"]

normalArr = [1,1,1,1,1,1,2,1,1,1,1,1,1,0,1,1,1,1]
fireArr = [1,0.5,2,1,0.5,0.5,1,1,2,1,1,0.5,2,1,1,1,0.5,0.5]
waterArr = [1,0.5,0.5,2,2,0.5,1,1,1,1,1,1,1,1,1,1,0.5,1]
electricArr = [1,1,1,0.5,1,1,1,1,2,0.5,1,1,1,1,1,1,0.5,1]
grassArr = [1,2,0.5,0.5,0.5,2,1,2,0.5,2,1,2,1,1,1,1,1,1]
iceArr = [1,2,1,1,1,0.5,2,1,1,1,1,1,2,1,1,1,2,1]
fightingArr = [1,1,1,1,1,1,1,1,1,2,2,0.5,0.5,1,1,0.5,1,2]
poisonArr = [1,1,1,1,0.5,1,0.5,0.5,2,1,2,0.5,1,1,1,1,1,0.5]
groundArr = [1,1,2,0,2,2,1,0.5,1,1,1,1,0.5,1,1,1,1,1]
flyingArr = [1,1,1,2,0.5,2,0.5,1,0,1,1,0.5,2,1,1,1,1,1]
psychicArr = [1,1,1,1,1,1,0.5,1,1,1,0.5,2,1,2,1,2,1,1]
bugArr = [1,2,1,1,0.5,1,0.5,1,0.5,2,1,1,2,1,1,1,1,1]    
rockArr = [0.5,0.5,2,1,2,1,2,0.5,2,0.5,1,1,1,1,1,1,2,1]
ghostArr = [0,1,1,1,1,1,0,0.5,1,1,1,0.5,1,2,1,2,1,1]
dragonArr = [1,0.5,0.5,0.5,0.5,2,1,1,1,1,1,1,1,1,2,1,1,2]
darkArr = [1,1,1,1,1,1,2,1,1,1,0,2,1,0.5,1,0.5,1,2]
steelArr = [0.5,2,1,1,0.5,0.5,2,0,2,0.5,0.5,0.5,0.5,1,0.5,1,0.5,0.5]

fairyArr = [1,1,1,1,1,1,0.5,2,1,1,1,0.5,1,1,0,0.5,2,1]
typeAdv = [normalArr,fireArr,waterArr,electricArr,grassArr,iceArr,fightingArr,poisonArr,groundArr,flyingArr,psychicArr,bugArr,rockArr,ghostArr,dragonArr,darkArr,steelArr,fairyArr]

def stringify(arrList):
    if(len(arrList)==0):
        return ""
    if(len(arrList)==1):
        return arrList[0].capitalize() + " type"
    if(len(arrList)==2):
        return arrList[0].capitalize() + " and " + arrList[1].capitalize() + " types"
    string = ""
    for i in range(len(arrList)-1):
        string+=arrList[i].capitalize()+", "
        
    return string + "and " + arrList[len(arrList)-1].capitalize() + " types"

def getTypeTable(typeArr):
    if(len(typeArr)==1):
        return typeAdv[types.index(typeArr[0].lower())]
    firstType = typeAdv[types.index(typeArr[0].lower())]
    secondType = typeAdv[types.index(typeArr[1].lower())]
    both = []
    for i in range(len(firstType)):
        both.append(firstType[i]*secondType[i])
    return both

def getAdvantages(typeArr):
    adv = []
    for i in range(len(getTypeTable(typeArr))):
        if(getTypeTable(typeArr)[i]>1):
            adv.append(types[i])
    return stringify(adv)
def getSupAdvantages(typeArr):
    adv = []
    for i in range(len(getTypeTable(typeArr))):
        if(getTypeTable(typeArr)[i]==4):
            adv.append(types[i])
    return stringify(adv)
    
def getDisadvantages(typeArr):
    disad = []
    for i in range(len(getTypeTable(typeArr))):
        if(getTypeTable(typeArr)[i]<1):
            disad.append(types[i])
    return stringify(disad)
        
def getSupDisadvantages(typeArr):
    disad = []
    for i in range(len(getTypeTable(typeArr))):
        if(getTypeTable(typeArr)[i]==0.25):
            disad.append(types[i])
    return stringify(disad)
    
def getImmunities(typeArr):
    immune = []
    for i in range(len(getTypeTable(typeArr))):
        if(getTypeTable(typeArr)[i]==0):
            immune.append(types[i])
    return stringify(immune)
    

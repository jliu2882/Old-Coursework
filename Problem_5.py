#def smallestMultiple(n):
#    i=0
#    while True:
#        listA=getDivList(i,n)
#        if len(listA)==n:
#            break
#        i=i+1
#    return i
#def getDivList(m,n):
#    div = [x for x in range(1,n) if m % x == 0]
#    return div
#    
#print(smallestMultiple(20))

#A little disappointed in myself but this takes less time(?)
#Both take a while but this works for sure
a = 1
while True:
    if a%20==0 and a&19==0 and a%18==0 and a%17==0 and a%16==0 and a%15==0 and a%14==0 and a%13==0 and a%12==0 and a%11==0:
        break
    a=a+1
print(a)

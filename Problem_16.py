def addDigits(n):
    sum = 0
    for i in range(0,len(str(n))):
        sum += int(str(n)[i])
    return sum

print(addDigits(2**1000))

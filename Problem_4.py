def palindrome(n):
    n = str(n)
    if n[:int(len(n)/2)]==(n[::-1])[:int(len(n)/2)]:
        return True
    return False

largest = 0
for i in range(1000,1,-1):
    for j in range(1000,1,-1):
        if palindrome(i*j):
            if(i*j>largest):
                largest = i*j
            break
print(largest)

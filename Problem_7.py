def isPrime(n):
    factor = 2
    while factor ** 2 <= n :
        if(n%factor==0):
            return False
        factor=factor+1
    return True
primeCount = 0
num = 1
cur_prime = 0
while primeCount <=10000:
    num+=1
    if(isPrime(num)):
        primeCount+=1
print(num)

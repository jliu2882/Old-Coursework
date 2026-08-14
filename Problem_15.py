import math

def nCk(n,k):
    #takes in two variables n and k, which is the size of the lattice path
    #outputs the possible combinations through the lattice given that you can not move backwards
    return (math.factorial(n+k)/((math.factorial(k)*math.factorial(n))))
print(nCk(20,20))

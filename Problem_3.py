def factors(n):
    largest = None
    factor = 2 
    while factor ** 2 <= n:
        while n % factor == 0:
            largest = factor
            n /= factor
        factor += 1
    if (n > 1): 
        return n 
    return largest

print(factors(600851475143))

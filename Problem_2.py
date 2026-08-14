def fibonacci(n):
    if n<=0:
        print("Failed")
    if n==1:
        return 1
    if n==2:
        return 1
    return fibonacci(n-2) + fibonacci(n-1)

a = 1
sum = 0
while fibonacci(a)<=4000000:
    if(fibonacci(a)%2==0):
        print(fibonacci(a))
        sum= sum+fibonacci(a)
    a=a+1
print(sum)

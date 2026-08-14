ones = ["","one","two","three","four","five","six","seven","eight","nine"]
tens = ["","ten","twenty","thirty","forty","fifty","sixty","seventy","eighty","ninety"]

#
# This started out clean, I promise
#
def specialCase(n):
    #does not work for numbers greater than 1000 or less than 1
    start = n
    if n == 1000:
        return 11
    n = n % 100
    result = 0
    if n == 11 or n == 12:
        result +=  6
    if n == 13 or n == 14 or n==18 or n == 19:
        result +=  8
    if n==15 or n == 16:
        result +=  7
    if n == 17:
        result +=  9
    if(result>0):
        result += len(ones[int(start/100)])
        if(len(ones[int(start/100)])>0):
            result += 10
    return result

    print(n)
letters = 0
for i in range(1,1001):
    str = ""
    if(specialCase(i)>0):
        letters +=specialCase(i)
    else:
        if(int(i/100)>0):
            if(i%100!=0):
                str+=ones[int(i/100)] + "hundredand"
            else:
                str+=ones[int(i/100)] + "hundred"
        i-=int(i/100)*100
        str+=tens[int(i/10)]
        i-=int(i/10)*10
        str+=ones[int(i)]
        letters2+=len(str)
print(letters2)

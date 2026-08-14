def translate(equation):
    equation = equation.lower().replace(" ","").replace("^","**").replace("pithon","easter_egg()").replace("πthon","easter_egg()").replace("pi","pi()").replace("π","pi()").replace("cls","cls()").replace("clear","cls()").replace("help","help()")
    if '(' in equation:
        parenList = [i for i, n in enumerate(equation) if n == '(']
        parenCloseList = [i for i, n in enumerate(equation) if n == ')']
        for i in range(0, len(parenList)-len(parenCloseList)):
            equation+=")"
        index = 1 if equation.index('(') == 0 else 0
        while index < len(parenList):
            parenList = [i for i, n in enumerate(equation) if n == '(']
            if equation[parenList[index]-1:parenList[index]].isdigit() or equation[parenList[index]-1:parenList[index]] == ')':
                equation = equation[0:parenList[index]] + "*" + equation[parenList[index]:len(equation)*2]
            index+=1
    if 'e' in equation:
        if equation == 'e':
            return str(e())
        eList = [i for i, n in enumerate(equation) if n == 'e']
        index = len(eList) -1
        while index >= 0:
            eVar = str(e())
            eList = [i for i, n in enumerate(equation) if n == 'e']
            if equation[eList[index]+1:eList[index]+3] == '**':
                equation = equation[0:eList[index]] + eVar + equation[eList[index]+1:len(equation)*2]
            index-=1
    if '!' in equation:
        factList = [i for i, n in enumerate(equation) if n == '!']
        index = 0
        while index < len(factList):
            factList = [i for i, n in enumerate(equation) if n == '!']
            index2 = 0
            for i in range(factList[index],1,-1):
                if not equation[i-1:i].isdigit() and not equation[i-1:i] == 'x':
                    index2 = i
                    break
            equation = equation[0:index2] + "factorial(" + equation[index2:factList[index]] + ")" + equation[factList[index]+1:len(equation)*2]
            index+=1
    return equation

def riemann_sum(equation, a, b, delta_x):
    sum = 0
    scale = 1
    while delta_x < 1:
        delta_x *= 10
        scale *= 10
    for i in range(int(a*scale),int(b*scale),int(delta_x)):
        sum+=(eval(translate(equation.replace("x","("+str(i/scale)+")")))*delta_x/scale)
    return sum

def integrate(equation,a,b):
    return riemann_sum(equation,a,b,0.00001)

def revolve(equation,a,b):
    return pi()*integrate("("+equation+")**2",a,b)

def average_value(equation,a,b):
    return integrate(equation,a,b)/(b-a)

def e(x=None):
    if x == None:
        x = 1
    e=0
    for i in range(1000):
        e+=x**i/factorial(i)
    return e

def factorial(n):
    if not int(n) == n:
        return "Factorial for decimals are disabled! Sorry for the inconvenience"
    if n == 0:
        return 1
    for i in range(1,n):
        n*=i
    return n

def cos(x):
    cosine=0
    for i in range(50):
        cosine+=(-1)**i*(x**(2*i))/factorial(2*i)
    return cosine

def sin(x):
    sine=0
    for i in range(50):
        sine+=(-1)**i*(x**(2*i+1))/factorial(2*i+1)
    return sine

def tan(x):
    return sin(x)/cos(x)

def ln(x):
    n=10000.0
    return n*((x**(1/n))-1)

def log(x,base=10):
    result=ln(x)/ln(base)
    return result

def euler_method(equation, start, stop, step):
    y = eval(translate(equation.replace("x","(" + str(start) + ")")))
    while start < stop:
        y+=(derivative(equation,start)*step)
        start+=step
    return y

def TLAsk(x1,x,y1,m):
    return m*(x-x1)+ y1

def derivative(equation, z):
    return (float(eval(translate(equation.replace("x","("+str(z+0.0000000001)+")")))-eval(translate(equation.replace("x","("+str(z)+")")))))/0.0000000001

def pi():
    return 16*arctan(1/5)-4*arctan(1/239)

def quad(a,b,c):
    while a==0:
        return "a cannot be 0"
    if b**2-4*a*c>0:
        d=(-b+(b**2-4*a*c)**0.5)/(2*a)
        e=(-b-(b**2-4*a*c)**0.5)/(2*a)
        return "The roots are " + str(d) + " and " + str(e)
    elif b**2-4*a*c==0:
        d=(-b+(b**2-4*a*c)**0.5)/(2*a)
        return "The root is " + str(d)
    elif b**2-4*a*c<0:
        return "The roots are imaginary"
def sqr(x):
    x=x**2
    return x

def sqrt(x):
    x=x**0.5
    return x

def cubert(x):
    x=x**(1/3)
    return x

def pwrraise(x,*args):
    num=x
    for numbers in args:
    	result= num**numbers
    	num=result
    return result

def rational_zero(equation,largest,constant):
    zeroes = []
    #find largest degree polynomial and the constant term <<<< TODO : rest should already work if we can find these two
    #xList = [i for i, n in enumerate(equation) if n == 'x']
    #largest_degree = 0
    #^to get rid of parameters largest and constant
    possible = possible_matches(find_factor(largest), find_factor(constant))
    for match in possible:
        if is_zero(equation,match):
            zeroes.append(match)
    return zeroes  
def get_coefficient(term):
    return term[0:term.index("x")]
def easter_egg():
    print("Yes?")
def find_factor(number):
    list =[ ]
    if number<0:
        number*=-1
    for i in range(1,int(number**0.5)+1):
        if number % i == 0:
            list.append(i)
            list.append(i*-1)
            if not number/i == i:
                list.append(int(number/i*-1))
                list.append(int(number/i))
    list.sort()
    return list
def possible_matches(listA,listB):
    list = []
    for a in listA:
        for b in listB:
            if not b/a in list:
                list.append(b/a) 
    list.sort()
    return list
def is_zero(equation,value):
    return eval(translate(equation.replace("x","(" + str(value) + ")")))==0

def arctan(x):
    arctan=0
    for i in range(1000):
        arctan+= ((-1)**i*(x**(2*i+1)))/(2*i+1)
    return arctan

def arcsin(x):
    return 2*arctan(x/(1+(1-x**2)**0.5))

def arccos(x):
    return (pi()/2 - arcsin(x))

def cls():
    for i in range(0,10):
        print("\n" * 10)

def help():
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print("Welcome to πthon by Anna Zou, Jack Liu, and Noel Cercizi")
    print("Here, you can do many functions such as deriving, integrating, finding rational zeroes and much more")
    print("Remember, all equation must be in a string and use x as the variable")
    print("Here are a list of commands you can do")
    print("help - get this message to pop up")
    print("clear - clears the screen")
    print("accuracy - changes what digit you round to")
    print("Basic info - you can use e,π/pi and factorial as e,π/pi and !")
    print("Basic commands - sin,cos,tan,arcsin,arccos,arctan,ln,sqr,sqrt,cubert")
    print("pwrraise - the number you want to raise, any amount of numbers after to raise that number to")
    print("e - the number you want to raise")
    print("log - the number you want to log, then the base")
    print("quad - a, b, c *quadratic formula")
    print("Functions You Need to Get a FIVE on the AP Calc BC Exam!")
    print("derivative - equation, a value to plug in")
    print("integrate - type the equation, then the bounds of the integral")
    print("riemann_sum - type the equation, then type the bounds of the sum and the △x * only left")
    print("revolve - type the equation, then type the bounds of the revolution * this only works revolving around x")
    print("average_value - type the equation, then the bounds of the equation")
    print("euler_method - the equation, the start, the stop, and the step size to guess a value")
    print("TLAsk - x1, x, y1, and m * used to approximate a tangent line")
    print("rational_zero - equaation, the coefficient of the largest term, the constant")
    
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    
#remove_quotation_later_to_run_calculator = """ remove '#' to bug fix
ans = 0
accuracy_variable = 5
help()
while True:
    print("πthon will solve any question you have!")
    equation = input()
    #print(eval(translate(equation)))  #for debugging
    try:
        equation = equation.lower().replace("answer","ans")
        ans = "" if eval(translate(equation)) == None else round(eval(translate(equation)),accuracy_variable) if str(eval(translate(equation)))[0:1].isdigit() else eval(translate(equation))
        print(ans)
    except:
        if "acc" in equation.lower():
            print("Please pick a number between 0 and 16 to determine how many digits to round to")
            new_accuracy = int(input("Accuracy:"))
            accuracy_variable = new_accuracy if new_accuracy > 0 and new_accuracy < 16 else accuracy_variable
            print("I will now round to",accuracy_variable,"digits!")
        elif not len(equation.replace(" ","")) == 0:
            print("πthon couldn't solve the problem :(")
        pass
#"""


#Notes:
#   equations must always be in a string "equation"
#   use ( ) to clarify equations

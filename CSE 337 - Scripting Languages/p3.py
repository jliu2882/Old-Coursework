#Jack Liu
#jalliu
#112655156
from tkinter import * 

bgColor = "gray75" #don't make white, so we can see text area :)
buttonColor = "gray50" #don't make black, so we can see text :)
answerColor = "white" #keep as white cause I like the black text with white bg :)

root = Tk()
root.geometry("201x318")#look, these numbers make me happy ok
root.title("πthon")
root.configure(bg = bgColor)

expression = ""


def chooseNumber(choice):
    global expression
    expression = expression + choice
    label.config(text = expression)

def clearScreen():
    global expression
    expression = ""
    label.config(text = expression)

def deleteLast():
    global expression
    expression = expression[:-1]
    label.config(text = expression)

def solveEquation():
    global expression
    try:
        expression = expression + "=" + str(eval(expression)) #this allows for floor/exponent on top of required functionality
    except:
        expression = "Expression is invalid"
    label.config(text = expression)
    expression = "" #Clears expression after each use, could save result in an "ANS" variable or even just save the value in expression in general but

label = Label(root, text = "", font = ("Lucida Console", 10), height = 2, bg = answerColor)
label.configure(anchor = "center")
paddingx = Label(root, text = " ", bg = bgColor)
paddingy = Label(root, text = " ", bg = bgColor)

btn1 = Button(root, text = "1", command = lambda: chooseNumber("1"), height = 2, width = 5, bg = buttonColor)
btn2 = Button(root, text = "2", command = lambda: chooseNumber("2"), height = 2, width = 5, bg = buttonColor)
btn3 = Button(root, text = "3", command = lambda: chooseNumber("3"), height = 2, width = 5, bg = buttonColor)
btn4 = Button(root, text = "4", command = lambda: chooseNumber("4"), height = 2, width = 5, bg = buttonColor)
btn5 = Button(root, text = "5", command = lambda: chooseNumber("5"), height = 2, width = 5, bg = buttonColor)
btn6 = Button(root, text = "6", command = lambda: chooseNumber("6"), height = 2, width = 5, bg = buttonColor)
btn7 = Button(root, text = "7", command = lambda: chooseNumber("7"), height = 2, width = 5, bg = buttonColor)
btn8 = Button(root, text = "8", command = lambda: chooseNumber("8"), height = 2, width = 5, bg = buttonColor)
btn9 = Button(root, text = "9", command = lambda: chooseNumber("9"), height = 2, width = 5, bg = buttonColor)
btn0 = Button(root, text = "0", command = lambda: chooseNumber("0"), height = 2, width = 5, bg = buttonColor)
btnAdd = Button(root, text = "+", command = lambda: chooseNumber("+"), height = 2, width = 5, bg = buttonColor)
btnSub = Button(root, text = "-", command = lambda: chooseNumber("-"), height = 2, width = 5, bg = buttonColor)
btnMul = Button(root, text = "*", command = lambda: chooseNumber("*"), height = 2, width = 5, bg = buttonColor)
btnDiv = Button(root, text = "/", command = lambda: chooseNumber("/"), height = 2, width = 5, bg = buttonColor)
btnOpen = Button(root, text = "(", command = lambda: chooseNumber("("), height = 2, width = 5, bg = buttonColor)
btnClose = Button(root, text = ")", command = lambda: chooseNumber(")"), height = 2, width = 5, bg = buttonColor)

btnClear = Button(root, text = "Clear", command = clearScreen, height = 2, width = 5, bg = buttonColor)
btnCalculate = Button(root, text = "=", command = solveEquation, height = 2, width = 5, bg = buttonColor)
btnDelete = Button(root, text = "Delete", command = deleteLast, height = 2, width = 5, bg = buttonColor)


paddingx.grid(row=0,column=0,rowspan=5)
paddingy.grid(row=0,column=0,columnspan=5)
label.grid(row=1,column=1,columnspan=4,sticky=EW)

btn0.grid(row=5,column=2,sticky=EW,pady=5)
btn1.grid(row=4,column=1,sticky=EW,pady=5)
btn2.grid(row=4,column=2,sticky=EW,pady=5)
btn3.grid(row=4,column=3,sticky=EW,pady=5)
btn4.grid(row=3,column=1,sticky=EW,pady=5)
btn5.grid(row=3,column=2,sticky=EW,pady=5)
btn6.grid(row=3,column=3,sticky=EW,pady=5)
btn7.grid(row=2,column=1,sticky=EW,pady=5)
btn8.grid(row=2,column=2,sticky=EW,pady=5)
btn9.grid(row=2,column=3,sticky=EW,pady=5)

btnDiv.grid(row=2,column=4,sticky=EW,pady=5)
btnMul.grid(row=3,column=4,sticky=EW,pady=5)
btnSub.grid(row=4,column=4,sticky=EW,pady=5)
btnAdd.grid(row=5,column=4,sticky=EW,pady=5)
btnOpen.grid(row=5,column=1,sticky=EW,pady=5)
btnClose.grid(row=5,column=3,sticky=EW,pady=5)
btnClear.grid(row=6,column=1,sticky=EW,pady=5)
btnDelete.grid(row=6,column=4,sticky=EW,pady=5)
btnCalculate.grid(row=6,column=2,columnspan=2,sticky=EW,pady=5)


mainloop()

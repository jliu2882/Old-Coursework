# Jack Liu
# 112655156
# JALLIU
#
# IAE 101 (Fall 2019)
# HW 3, Problem 1

# DON'T CHANGE OR REMOVE THIS IMPORT
from random import shuffle

# DON'T CHANGE OR REMOVE THESE LISTS
# The first is a list of all possible card ranks: 2-10, Jack, King, Queen, Ace
# The second is a list of all posible card suits: Hearts, Diamonds, Clubs, Spades
ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
suits = ["H", "D", "C", "S"]

# This class represents an individual playing card
class Card():
    def __init__(self, suit, rank):
        self.suit = suit
        self.rank = rank
        
    # DON'T CHANGE OR REMOVE THIS
    # This function creates a string out of a Card for easy printing.
    def __str__(self):
        return "[" + self.suit + ", " + self.rank + "]"

# This class represents a deck of playing cards
class Deck():
    def __init__(self):
        self.cards = []
        for i in range(0,13):
            for j in range(0,4):
                self.cards.append(Card(suits[j],ranks[i]))
        
    # DON'T CHANGE OR REMOVE THIS
    # This function will shuffle the deck, randomizing the order of the cards
    # inside the deck.
    # It takes an integer argument, which determine how many times the deck is
    # shuffled.
    def shuffle_deck(self, n = 5):
        for i in range(n):
            shuffle(self.cards)

    # This function will deal a card from the deck. The card should be removed
    # from the deck and added to the player's hand.
    def deal_card(self, player):
        player.hand.append(self.cards.pop()) #can choose to pop from index 0, but 'top of the deck' is subjective

    # DON"T CHANGE OR REMOVE THIS
    # This function constructs a string out of a Deck for easy printing.
    def __str__(self):
        res = "[" + str(self.cards[0])
        for i in range(1, len(self.cards)):
            res += ", " + str(self.cards[i])
        res += "]"
        return res

# This class represents a player in a game of Blackjack
class Player():
    def __init__(self, name):
        self.name = name
        self.hand = []
        self.status = True

    def value(self):
        value = 0
        aceCount = 0
        for i in self.hand:
            rankIndex = ranks.index(i.rank)
            if rankIndex<9:
                value+=rankIndex+2 #account for first number in ranks is 2 not 0
            elif rankIndex!=12: #or i !="A"
                value+=10
            else:
                aceCount+=1
        for i in range(0,aceCount):
            if value+11>21:
                value+=1
            else:
                value+=11
        return value
                

    def choose_play(self):
        if self.status == False or self.value()>=17:
            self.status = False
            return "Stay"
        return "Hit" #can only return hit if they are still playing or the hand is less than 17

    # DON'T CHANGE OR REMOVE THIS
    # This function creates a string representing a player for easy printing.
    def __str__(self):
        res = "Player: " + self.name + "\n"
        res += "\tHand: " + str(self.hand[0])
        for i in range(1, len(self.hand)):
            res += ", " + str(self.hand[i])
        res += "\n"
        res += "\tValue: " + str(self.value())
        return res

# This class represents a game of Blackjack
class Blackjack():
    def __init__(self, players):
        self.players = players
        self.deck = Deck()
        self.deck.shuffle_deck(10)
        for i in range(0,2):
            for i in players:
                self.deck.deal_card(i) #could just do this twice but it feels more real when every player gets the first card first

    def play_game(self):
        gameStatus = True
        while(gameStatus):
            gameStatus = False
            for i in players:
                if i.status:
                    gameStatus = True #if any players are still playing, game continues
                    if i.choose_play() == "Hit":
                        self.deck.deal_card(i)
                        if i.value()>21:
                            print(i.name + " has busted")
        print()#new line
        currentWinner = "No one"
        closestNum = 21
        for i in players:
            if (21 - i.value()>=0 and 21-i.value()<closestNum):
                currentWinner = i.name
                closestNum = 21-i.value()
        if(closestNum ==21):
            print("No one won the game")
            return #ends it if everyone busted
        allWinners = [] #checks all the players for ties for first place
        for i in players:
            if 21-i.value() == closestNum:
                allWinners.append(i.name)
        allWinnerStr = allWinners[0] #adds the first person in the winner
        for i in range(1,len(allWinners)): #appends the rest if they exist
            if(i == len(allWinners)-1): # checks for grammatical purposes :D
                allWinnerStr=allWinnerStr+ " and "  + allWinners[i]
            else:
                allWinnerStr=allWinnerStr + ", " + allWinners[i]
        print(allWinnerStr + " won the game!" if len(allWinners)==1 else allWinnerStr + " won the game together!")

    # DON'T CHANGE OR REMOVE THIS
    # This function creates a string representing the state of a Blackjack game
    # for easy printing.
    def __str__(self):
        res = "Current Deck:\n\t" + str(self.deck)
        res = "\n"
        for p in self.players:
            res += str(p)
            res += "\n"
        return res

# DO NOT DELETE THE FOLLOWING LINES OF CODE! YOU MAY
# CHANGE THE FUNCTION CALLS TO TEST YOUR WORK WITH
# DIFFERENT INPUT VALUES.
if __name__ == "__main__":
    # Uncomment each section of test code as you finish implementing each class
    # for this problem. Uncomment means remove the '#' at the front of the line
    # of code.
    
    # Test Code for your Card class
    c1 = Card("H", "10")
    c2 = Card("C", "A")
    c3 = Card("D", "7")

    print(c1)
    print(c2)
    print(c3)

    print()

    # Test Code for your Deck class
    d1 = Deck()
    d1.shuffle_deck(10)
    print(d1)

    print()

    # Test Code for your Player class
    p1 = Player("Alice")
    p2 = Player("Bob")
    d1.deal_card(p1)
    d1.deal_card(p2)
    print(p1.value())
    print(p2.value())
    d1.deal_card(p1)
    d1.deal_card(p2)
    print(p1.value())
    print(p2.value())
    d1.deal_card(p1)
    d1.deal_card(p2)
    print(p1.value())
    print(p2.value())
    print(p1)
    print(p2)
    print(p1.choose_play())
    print(p2.choose_play())

    print()

    # Test Code for your Blackjack class
    players = [Player("Summer"), Player("Rick"), Player("Morty"), Player("Jerry")]
    game = Blackjack(players)
    print(game)
    game.play_game()
    print(game)

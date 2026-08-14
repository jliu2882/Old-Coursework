# mytwitterbot.py
# IAE 101, Fall 2019
# Project 02 - Building a Twitterbot
# Name: Jack Liu      
# netid: jalliu      
# Student ID: 112655156

import sys
import simple_twit as st
import poetry_generator as pg
import PokeTyping as pt
import random
import json

#
# CREDIT TO FANZEYI AT https://github.com/fanzeyi/pokemon.json FOR THE POKEMON JSON FILE
# CREDIT TO CHRISTOPHER KANE FOR POETRY GENERATOR AND SIMPLETWEET
# AM I CREDITING RIGHT?
#

#Get the JSON file and opens it
def getJSON(filePathAndName):
    with open(filePathAndName, 'r', encoding="utf8") as fp:
        return json.load(fp)
#gets a list of the pokemons name only
def getPokemonList():
    pokemons = []
    pokemonJSON = getJSON('pokedex.json')
    for pokemonObj in pokemonJSON:
        pokemons.append(pokemonObj['name']['english'])
    return pokemons
#pushes the pokemon file to the text file to keep track of what pokemons are left
def pushPokemonFile(pokemonList):
    print("\n Pokedex update in progress..." )
    f = open("pokedex.txt", "w")
    for i in pokemonList:
        f.write(i.replace("Mr. Mime","Mr.Mime").replace("Mime Jr.","MimeJr.").replace("Tapu Koko","TapuKoko")
                .replace("Tapu Lele","TapuLele").replace("Tapu Bulu","TapuBulu").replace("Tapu Fini","TapuFini").replace("Type: Null","Type:Null")+ "\n")
    f.close()
    f = open("pokedex.txt", "r")
    print("...Pokedex succesfully updated \n")
#reverts the changes that was made so it would fit properly in a file
def revertChanges(pokemon):
    #Nidorans hard coded first because unicode issue?
    return pokemon.replace("Mr.Mime","Mr. Mime").replace("MimeJr.","Mime Jr.").replace("TapuKoko","Tapu Koko").replace("TapuLele","Tapu Lele").replace("TapuBulu","Tapu Bulu").replace("TapuFini","Tapu Fini").replace("Type:Null","Type: Null")
#gets the image
def getPokeImage(pokemon):
    pokemon = revertChanges(pokemon)
    pokemonDesc = None
    pokemons = getJSON('pokedex.json')
    for pokemonObj in pokemons:
        if(pokemonObj['name']['english'] == pokemon):
            pokemonDesc = pokemonObj
    pokeid = str(pokemonDesc['id'])
    while(len(pokeid)<3):
        pokeid = "0"+pokeid
    return "images/" + pokeid + ".png"
#creates a tweet to be sent out
#The tweet will contain the pokemon's number and type coverages along with a haiku
def createTweet(pokemon):
    pokemon = revertChanges(pokemon)
    pokemonDesc = None
    pokemons = getJSON('pokedex.json')
    for pokemonObj in pokemons:
        if(pokemonObj['name']['english'] == pokemon):
            pokemonDesc = pokemonObj
    pokeTypes = pokemonDesc['type']
    if(len(pokeTypes)==1):
        pokeType = pokeTypes[0] + " type"
    else:
        pokeType = pokeTypes[0] + "-" + pokeTypes[1] + " type"
    pokeid = str(pokemonDesc['id'])
    while(len(pokeid)<3):
        pokeid = "0"+pokeid
    return ("Pokemon #" + pokeid + ": " + pokemon + "\n \n" + pokemon + " is a " + pokeType + ", and is weak to the " + pt.getAdvantages(pokeTypes) + ". " + pokemon + " defends well against the " + pt.getDisadvantages(pokeTypes) + ". \n \n" + pg.haiku(pokemon))


api = st.create_api()
st.version()
print("\n \n \n \n")
pokemons = open('pokedex.txt','r').read().split()
print(createTweet(pokemons[0]))
st.send_media_tweet(api,createTweet(pokemons[0]),getPokeImage(pokemons.pop(0)))
pushPokemonFile(pokemons)

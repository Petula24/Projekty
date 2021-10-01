import random
from random import randint
import traceback

def game():
    cara = "-" *36
    print("HI THERE")
    print(cara)
    gennumber = str(random.randint(1000, 9999))
    gennumberarray = [int(i) for i in str(gennumber)]
    print("Solution key = " + str(gennumber))
    print("I'VE GENERATED A RANDOM 4 DIGIT NUMBER FOR YOU.")
    print("LET'S PLAY BULLS AND COWS GAME.")
    print(cara)
    inputnumber = str(0)
    while inputnumber != gennumber:
        bulls = 0
        cows = 0
        x = 0
        y = 0
        i = 0

        try:
            inputnumber = int(input("ENTER A NUMBER: "))

        except ValueError:
            print("Only number, please!")
            return traceback.format_exc()


        print(cara)
        inputnumberarray = [int(i) for i in str(inputnumber)]
        if inputnumber >= 1000 and inputnumber <= 9999:

            while x != 4:
                if inputnumberarray[x] == gennumberarray[x]:
                    bulls += 1
                x += 1

            i = len(list(set(inputnumberarray).intersection(gennumberarray)))

            cows = i - bulls
            if inputnumberarray == gennumberarray:
                print("YOU WIN")
                break

            if bulls == 1:
                if cows == 1:
                    print(str(bulls) + " bull, " + str(cows) + " cow")
                elif cows > 1 or cows == 0:
                    print(str(bulls) + " bull, " + str(cows) + " cows")
            elif bulls > 1 or bulls <= 0:
                if cows == 1:
                    print(str(bulls) + " bulls, " + str(cows) + " cow")
                elif cows > 1 or cows <= 0:
                    print(str(bulls) + " bulls, " + str(cows) + " cows")
            elif inputnumber not in gennumber:
                print("Neplatná volba")
            print(cara)

        elif inputnumber < 1000 or inputnumber > 9999:
            print("NUMBER WITH INCORRECT LENGHT INPUTTED!")
            print(cara)

            break



game()
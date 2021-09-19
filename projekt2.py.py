import random


def game(number):
    print("HI THERE!")
    cara = "-" * 36
    print(cara)
    gennumber = [random.randint(1, 9) for x in range(number)]
    print("I´VE GENERATED A RANDOM 4 DIGIT NUMBER FOR YOU")
    print("LET´S PLAY BULLS AND COWS GAME!")
    print(cara)

    inputnumber = 0
    while True:
        inputnumber += 1
        print("Guess: " + str(inputnumber))

        print("Enter a number: ")
        print(cara)
        inputer = [int(n) for n in str(input())]
        print(cara)

        if inputer == gennumber:
            print("Correct, you´ve guessed the right number,")
            print("in " + str(inputnumber) + " guesses.")
            break
        elif inputnumber < 1 or inputnumber > 9:
            print("NUMBER WITH INCORRECT LENGHT INPUTTED!")
            print(cara)
        else:
            cows = 0
            bulls = 0

            for x in range(0, number):
                if inputer[x] == inputer[x]:
                    cows += 1
                elif inputer[x] in gennumber:
                    bulls += 1

        print("Cows: " + str(cows) + " Bulls: " + str(bulls))


game(4)
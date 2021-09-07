TEXTS = ['''
Situated about 10 miles west of Kemmerer
Fossil Butte, is a ruggedly impressive,
topographic feature that rises sharply
some 1000 feet above Twin Creek Valley
to an elevation of more than 7500 feet
above sea level. The butte is located just
north of US 30N and the Union Pacific Railroad,
which traverse the valley. ''',

'''At the base of Fossil Butte are the bright
red, purple, yellow and gray beds of the Wasatch
Formation. Eroded portions of these horizontal
beds slope gradually upward from the valley floor
and steepen abruptly. Overlying them and extending
to the top of the butte are the much steeper
buff-to-white beds of the Green River Formation,
which are about 300 feet thick.''',

'''The monument contains 8198 acres and protects
a portion of the largest deposit of freshwater fish
fossils in the world. The richest fossil fish deposits
are found in multiple limestone layers, which lie some
100 feet below the top of the butte. The fossils
represent several varieties of perch, as well as
other freshwater genera and herring similar to those
in modern oceans. Other fish such as paddlefish,
garpike and stingray are also present.'''
]

usernameinput = input("USERNAME: ")
passwordinput = input("PASSWORD: ")
registered = {"bob" : "123", "ann" : "pass123", "mike" : "password123", "liz" : "pass123"}
cara = "-" *35
if registered.get(usernameinput) == passwordinput:
    print("Welcome", usernameinput, "!")
    print(cara)
else:
    print("Error! You are not a registred")
    exit()

print(cara)
print("WELCOME TO THE APP, ", usernameinput)
print("WE HAVE 3 TEXTS TO BE ANALYZED.")
print(cara)
text_number = (input("ENTER A NUMBER BTW. 1 AND 3 TO SELECT: "))
if text_number == "1" or text_number == "2" or text_number == "3":
    print(cara)
else:
    print("Error! It´s not integeer")
    exit()
text_number = int(text_number)
text_selected = (TEXTS[text_number - 1].split())
print("THERE ARE " + str(len(text_selected)) + " WORDS IN THE SELECTED TEXT.")
print("THERE ARE " + str(sum(c.istitle() for c in text_selected)) + " TITLECASED WORDS.")
print("THERE ARE " + str(sum(c.isupper() for c in text_selected)) + " UPPERCASE WORDS.")
print("THERE ARE " + str(sum(c.islower() for c in text_selected)) + " LOWERCASE WORDS.")
print("THERE ARE " + str(sum(c.isnumeric() for c in text_selected)) + "ISNUMERIC STRINGS.")
count = len([c for c in text_selected if c.isnumeric()])
print("There are", count, "numeric strings.")
print(cara)

clean_text = [word0.strip(',.!?') for word0 in text_selected]
letters = {}
for i in clean_text:
    if len(i) not in letters:
        letters[len(i)] = 1
    else:
        letters[len(i)] += 1
letters_counts = sorted(letters.items(), key=lambda x: x[0])
for c in letters_counts:
    print(str(c[0]), "|", ("*" * c[1]), "|", str(c[1]), )
print(cara)







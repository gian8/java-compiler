



# Specs



### Input language
The input file is composed of two sections: header and light sections, separated by means of the two characters
"\%%". A "\#" character identifies the start of a comment, which is defined from the "\#" character to the end of the line.

### Header section: lexicon
The header section can contain 3 types of tokens, each terminated with the character ";" :

**<token1>:** an odd hexadecimal number between -12E and 87C, the character "$", which is optionally followed by a word of at least 6 uppercase alphabetic letters (in an even number), followed by the word "hello" or by 3 or more repetitions of the words ("xyx", "yxy"), which can appear in any possible combination
(e.g., xyxxyxyxyxyx, xyxyxyyxy, ...).

**<token2>:** is the character "!" followed by a binary number containing 3, 4 or 7 characters \0" (e.g.,!1110010111, !100001000, ...), or the character "&" followed by a hour with the format "HH:MM:SS"
between 06:16:23 and 18:31:21.

**<token3>:** it starts with a word composed of at least 7 and at most 25 repetitions of the following words of three characters: "+++" and "***" (as a consequence, the number of characters of the first part of this token ranges between 21 and 75). The first part of the token is followed by at least 3 words in even number.
Each word is composed of 2, 4 or 12 alphabetic characters. The words are separated with the character "@".


### Header section: grammar
In the header section **<token1>** and **<token2>** can appear in any order and number (also 0 times), instead, **<token3>** can appear only 1 or 3 times.


### Flight section: grammar and semantic
The flight section starts with the **INIT** instruction, which sets the state of an airplane in terms of fuel (F) and
altitude (A). The INIT instruction has the syntax `INIT F fuel - A altitude;`, where F and A are signed integer numbers. F fuel sets the fuel of the airplane to the values F, while A altitude sets the altitude to A. The order of F fuel and A altitude inside the INIT instruction can be inverted, and both parts can be optional. In the case one or both are not present, default values are 100 for F and 0 for A. 
_Examples_: ```INIT - 50 fuel;```
            ```(sets F:50 A:0)```.
After the INIT instruction, there is a list of **<commands>**. The number of commands is odd and at least 5.
The following two commands are defined:

**SET**: it is the SET word, followed by a list of <attr> between square brackets ("[" and "]") and separated with commas, followed by the symbol "->" and by a <var name>. Each <attr> is an <attr name> (a string of letters and numbers starting with a letter), a ":", and a <value> (i.e., a signed integer number).
This command stores the tuples <attr name>, <value> in a hash table (or other data structures) with key <var name>. The hash table is the only global variable allowed in all the program, and it must only contain the information derived from the SET command.

**IF:** it is the IF word, followed by a <var name>.<attr name> and by an <is list>. In particular, <var name>.<attr name> represents the <value> that was previously stored in the hash table. It can be obtained by accessing the hash table. Its value cannot be modified inside the current IF command.
<is list> is a not empty list of <is> statements. Each <is> is the word IS, a <comparison>, the word
THEN, a "[", a <list of actions> (i.e., a not empty list of <action>), and a "]".

<comparison> in composed of an <operator> (< minor, == equal, or > major) followed by a <number> (i.e., a signed integer number).
If <var name>.<attr name> <operator> <number> (e.g., passengers.type A > 100) represents a true boolean expression with the usual rules of the C programming language, the <list of actions> associated to the current <is> statement is executed. Inside the <is> statement, to obtain the <value> associated to <var name>.<attr name>, inherited attributes must be used.
In the last <is> statement of an IF command, <comparison> is equal to ELSE and the associated <list of actions> is executed only if all previous <comparisons> are false.
An <action> is a <name>, followed of an operator (-= or +=) followed by a signed integer number.
If <name> is fuel or altitude the state of the airplane, which is memorized in the parser stack, is modified (reduced -= or increased += of a quantity equal to the signed integer number) and the new state is printed in the screen. 
The state of the airplane cannot be stored into a global variable.
Use instead inherited attributes to access from the parser stack the old state. If <name> is <var name>.<attr name>, the corresponding value inside the hash table is modified and the new value is printed in the screen.

### EXAMPLE

##### Input:
_____________________________________________________________
~~~~
-E$ABCDEFGHhello; # <token1>
!1110010101; # <token2>
+++***++++++***+++***aC@ABCD@ab@xy@yz; # <token3>
81A$xyxxyxyxyxyx; # <token1>
&06:17:01; # <token2>
%%
INIT 150 fuel - 10 altitude; # F:150 A:10
SET [ type_A : 110, type_B :20] -> passengers;
SET [ suitcases : 1200, fuel: 2000 ] -> weight;

IF passengers.type_A # passengers.type_A equals 110
    IS > 100 THEN [ # true
        fuel -= 3; # print F:147 A:10
        weight.fuel -= 300; # print weight.fuel = 1700
        altitude += 100; # print F:147 A:110
    ]
    IS > 200 THEN [ # false
        weight->fuel -= 200;
        fuel -= 2;
    ]
    IS ELSE THEN [ # false
        fuel -= 1;
    ]
DONE;

SET [height: 2000] -> mountain;
IF mountain.height # mountain.height equals 2000
    IS > 3000 THEN [ # false
        fuel -= 10; weight.fuel -= 1000; altitude += 4000;
    ]
    IS ELSE THEN [ # true
        fuel -= 5; # print F:142 A:110
         weight.fuel -= 500; # print weight.fuel = 1200
        altitude += 1000; # print F:142 A:1110
    ]
DONE;
~~~~

##### Output
_____________________________________________________________
~~~~
F:147 A:10
weight.fuel = 1700
F:147 A:110
F:142 A:110
weight.fuel = 1200
F:142 A:1110
~~~~


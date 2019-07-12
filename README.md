# java-compiler
Using the JFLEX lexer generator and the CUP parser generator, realize a JAVA program capable of recognizing
and executing the programming language described in the following specifications.

### Language Example

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
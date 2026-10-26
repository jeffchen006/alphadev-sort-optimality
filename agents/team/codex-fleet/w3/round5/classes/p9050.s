# n=5 model=out iset=I1 prefix14_class=9050
mov S1, P0
mov S0, P2
cmp P1, S1
cmovle S1, P1
cmovle P1, P0
cmp P3, S0
cmovle P2, P3
cmovg S0, P3
cmp S0, P1
cmovle P3, S0
cmovl S0, P1
cmovl P1, P3
mov S0, P2
cmp S0, S1

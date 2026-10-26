# n=5 model=out iset=I1 prefix14_class=4606
mov S1, P0
cmp P3, P0
cmovg S1, P3
cmovle P0, P3
cmp P2, P1
cmovle P3, P1
cmovle P1, P2
mov S2, S1
cmovle P2, P3
cmp P2, S1
mov S0, P0
cmovl S1, P2
cmovg S2, P2
cmp P1, S0

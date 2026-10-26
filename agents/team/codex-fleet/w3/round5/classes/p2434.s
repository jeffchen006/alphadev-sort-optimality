# n=5 model=out iset=I1 prefix14_class=2434
mov S0, P3
cmp P1, S0
cmovg S0, P1
cmovle P3, P1
cmp P2, P0
cmovle P1, P2
cmovl P2, P0
cmovle P0, P1
mov S2, S0
cmp P2, S2
cmovg S2, P2
cmovg P2, S0
cmp P3, P0
mov S1, P0

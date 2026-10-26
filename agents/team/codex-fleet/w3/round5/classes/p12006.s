# n=5 model=out iset=I1 prefix14_class=12006
cmp P3, P1
mov S0, P3
cmovg S0, P1
cmovg P1, P3
cmp P0, P2
cmovle P3, P0
cmovl P0, P2
mov S2, S0
cmovle P2, P3
mov S1, P0
cmp P2, S2
cmovl S2, P2
cmovl P2, S0
cmp P1, P0

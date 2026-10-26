# n=5 model=out iset=I1 prefix14_class=12588
mov S2, P2
cmp P2, P0
cmovl P2, P0
cmovg S2, P0
cmp P3, P1
cmovl S0, P1
cmovle P1, P3
cmovl P3, S0
cmp P1, S2
mov P0, S2
cmovle P0, P1
cmovle P1, S2
mov P0, P3
cmp P0, P2

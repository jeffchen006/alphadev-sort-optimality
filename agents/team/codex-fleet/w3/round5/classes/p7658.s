# n=5 model=out iset=I1 prefix14_class=7658
mov S0, P2
cmp P3, S0
cmovle P2, P3
cmovg S0, P3
cmp P0, P1
cmovl S2, P0
cmovle P0, P1
cmovl P1, S2
mov S1, P1
mov P3, P0
cmp P1, P2
cmovl P1, P2
cmovle P2, S1
cmp P0, S0

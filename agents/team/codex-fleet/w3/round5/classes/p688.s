# n=5 model=out iset=I1 prefix14_class=688
mov S0, P0
cmp P3, S0
cmovl S0, P3
mov S2, P2
cmovl P3, P0
cmp S2, P1
cmovle P2, P1
cmovg S2, P1
cmp P3, P2
mov S1, P3
cmovl S1, P2
cmovle P2, P3
mov P3, S2
cmp P3, S0

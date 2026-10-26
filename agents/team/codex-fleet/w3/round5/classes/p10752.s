# n=5 model=out iset=I1 prefix14_class=10752
mov S0, P3
cmp P2, P3
cmovle S0, P2
cmovg P3, P2
cmp P1, P0
cmovl S2, P1
cmovle P1, P0
mov P2, P1
cmovl P0, S2
cmp P1, P3
cmovl P1, P3
cmovl P3, P2
cmp S0, P0
mov P2, P0

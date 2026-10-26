# n=5 model=out iset=I1 prefix14_class=783
mov S0, P2
mov S2, P3
cmp P3, P0
cmovl S2, P0
cmovl P0, P3
cmp S0, P1
cmovg S0, P1
cmovle P2, P1
mov P3, S2
mov P1, P0
cmp P2, S2
cmovg S2, P2
cmovl P3, P2
cmp P0, S0
